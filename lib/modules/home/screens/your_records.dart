import 'package:callerxyz/modules/home/widgets/record_card.dart';
import 'package:callerxyz/modules/home/widgets/today_tile.dart';
import 'package:callerxyz/modules/records/screens/record_details.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:callerxyz/modules/shared/widgets/transitions.dart';
import 'package:callerxyz/riverpod/record_data.dart';
import 'package:callerxyz/riverpod/records_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class YourRecordSection extends ConsumerStatefulWidget {
  const YourRecordSection({super.key});

  @override
  ConsumerState<YourRecordSection> createState() => _YourRecordSectionState();
}

class _YourRecordSectionState extends ConsumerState<YourRecordSection> {
  final supabase = Supabase.instance.client;
  bool _loading = true;

  //functions
  getUserRecord() {
    supabase
        .from("user_records")
        .select()
        .eq("uid", supabase.auth.currentUser!.id)
        .select()
        .order('date')
        .limit(10)
        .then((results) {
      ref
          .watch(yourRecordsProvider.notifier)
          .setRecords(results.map((e) => RecordModel.fromJson(e)).toList());

      if (results[0]['date'] ==
          DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        ref
            .watch(yourRecordsProvider.notifier)
            .setTodayRecord(RecordModel.fromJson(results[0]));
      } else {
        supabase
            .from('user_records')
            .insert({
              // "uid": supabase.auth.currentUser!.id,
              "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
              "day": DateFormat('EEEE').format(DateTime.now()),
              "dialed": 0,
              "connected": 0,
              "meetings": 0,
              "callbacks": 0,
            })
            .then((value) => debugPrint("----------------new record created"))
            .catchError((error) =>
                debugPrint("----------------error creating record: $error"));
        ref.watch(yourRecordsProvider.notifier).setTodayRecord(
              RecordModel(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              ),
            );
      }

      setState(() {
        _loading = false;
      });
    }).onError((error, stackTrace) {
      errorSnackBar(context, "Error fetching records");
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    getUserRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's record
        GestureDetector(
          onTap: () {
            rightSlideTransition(
                context,
                RecordDetails(
                    record: ref.watch(yourRecordsProvider).todayRecord),
                onComplete: () async {
              {
                await supabase
                    .from('user_records')
                    .update({
                      'dialed': ref.watch(recordDataController).totalDialed,
                      'connected': ref.watch(recordDataController).connected,
                      'meetings': ref.watch(recordDataController).meetings,
                      'conversions':
                          ref.watch(recordDataController).conversions,
                      'callbacks': ref.watch(recordDataController).callbackReq,
                    })
                    .eq('uid', supabase.auth.currentUser!.id)
                    .eq('date', DateFormat('yyyy-MM-dd').format(DateTime.now()))
                    .select()
                    .then((record) {
                      debugPrint("----------------record: $record");
                      ref
                          .watch(yourRecordsProvider.notifier)
                          .setTodayRecord(RecordModel.fromJson(record[0]));
                    });
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomColors.black10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      )
                    ],
                  ),
                ),
                TodayTile(
                  title: 'Dialed',
                  icon: SvgPicture.asset(
                    "assets/phone_outgoing.svg",
                    height: 20,
                    width: 20,
                  ),
                  value: ref.watch(yourRecordsProvider).todayRecord.dialed,
                  onTap: () {},
                ),
                TodayTile(
                  title: 'Connected',
                  icon: SvgPicture.asset(
                    "assets/chat.svg",
                    height: 20,
                    width: 20,
                  ),
                  value: ref.watch(yourRecordsProvider).todayRecord.connected,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Your Record
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_loading)
                Container(
                  height: 20,
                  width: 20,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: const CircularProgressIndicator(
                      strokeCap: StrokeCap.round),
                ),
              const Text(
                "Your Record",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              )
            ],
          ),
        ),
        if (ref.watch(yourRecordsProvider).records.isEmpty && !_loading)
          Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("No calling history"),
              const SizedBox(height: 12),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: CustomColors.black,
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: CustomColors.white,
                ),
                label: const Text(
                  "Start tracking calls now!",
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                ),
              ),
            ],
          )),
        if (_loading)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Arbitrary number of shimmer tiles
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        if (!_loading && ref.watch(yourRecordsProvider).records.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ref.watch(yourRecordsProvider).records.length,
            itemBuilder: (context, index) {
              final record = ref.watch(yourRecordsProvider).records[index];
              return RecordCard(record: record);
            },
          ),
      ],
    );
  }
}
