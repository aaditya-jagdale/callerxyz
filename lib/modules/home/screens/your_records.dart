import 'dart:math';

import 'package:callerxyz/modules/home/screens/all_records.dart';
import 'package:callerxyz/modules/home/widgets/record_card.dart';
import 'package:callerxyz/modules/home/widgets/today_tile.dart';
import 'package:callerxyz/modules/records/screens/record_details.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:callerxyz/modules/shared/widgets/transitions.dart';
import 'package:callerxyz/riverpod/calendar_data.dart';
import 'package:callerxyz/riverpod/record_data.dart';
import 'package:callerxyz/riverpod/records_riverpod.dart';
import 'package:dotted_line/dotted_line.dart';
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

  Future createTodayRecord() async {
    await supabase.from('user_records').insert({
      "uid": supabase.auth.currentUser!.id,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    }).then((value) {
      getUserRecord();
      debugPrint("----------------new record created");
    }).catchError((error) {
      debugPrint("----------------error creating record: $error");
    });
  }

  //functions
  getUserRecord() async {
    await supabase
        .from("user_records")
        .select()
        .eq("uid", supabase.auth.currentUser!.id)
        .select("*")
        .order('date')
        .then((results) {
      debugPrint("----------------results: $results");
      if (results.isEmpty) {
        createTodayRecord();
      } else {
        if (results[0]['date'] !=
            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
          createTodayRecord();
        }

        ref
            .watch(yourRecordsProvider.notifier)
            .setRecords(results.map((e) => RecordModel.fromJson(e)).toList());
      }
      setState(() {
        _loading = false;
      });
    }).onError((error, stackTrace) {
      errorSnackBar(context, "Error fetching records");
      debugPrint("----------------error fetching records: $error");
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserRecord();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's record
        if (!_loading)
          GestureDetector(
            onTap: () {
              rightSlideTransition(
                  context,
                  RecordDetails(
                      record: ref.watch(yourRecordsProvider).records[0]),
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
                        'callbacks':
                            ref.watch(recordDataController).callbackReq,
                      })
                      .eq('uid', supabase.auth.currentUser!.id)
                      .eq('id', ref.watch(yourRecordsProvider).records[0].id)
                      .select()
                      .then((record) {
                        if (record.isNotEmpty) {
                          ref
                              .watch(yourRecordsProvider.notifier)
                              .updateRecord(RecordModel.fromJson(record[0]));
                          if (record[0]['dialed'] == 0) {
                            ref
                                .watch(calendarDataProvider.notifier)
                                .removeDate('isConverted', 0);
                          } else {
                            ref
                                .watch(calendarDataProvider.notifier)
                                .addDate('isConverted', 0);
                          }
                        }
                      })
                      .catchError((error, stackTrace) {
                        debugPrint("Error updating record: $error");
                        errorSnackBar(context, "Error updating record");
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: DottedLine(
                      dashColor: CustomColors.black50,
                      dashGapLength: 4,
                      dashLength: 4,
                      lineThickness: 1,
                      dashRadius: 0,
                    ),
                  ),
                  TodayTile(
                    title: 'Dialed',
                    icon: SvgPicture.asset(
                      "assets/phone_outgoing.svg",
                      height: 20,
                      width: 20,
                    ),
                    value: ref.watch(yourRecordsProvider).records[0].dialed,
                  ),
                  TodayTile(
                    title: 'Connected',
                    icon: SvgPicture.asset(
                      "assets/chat.svg",
                      height: 20,
                      width: 20,
                    ),
                    value: ref.watch(yourRecordsProvider).records[0].connected,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),

        // Your Record
        GestureDetector(
          onTap: () {
            rightSlideTransition(context, const AllRecords());
          },
          child: Padding(
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
        ),
        if (ref.watch(yourRecordsProvider).records.isEmpty && !_loading)
          Container(
              height: 300,
              width: double.infinity,
              alignment: Alignment.center,
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
            itemCount: min(ref.watch(yourRecordsProvider).records.length, 10),
            itemBuilder: (context, index) {
              final record = ref.watch(yourRecordsProvider).records[index];
              return RecordCard(record: record);
            },
          ),
      ],
    );
  }
}
