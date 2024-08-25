import 'package:callerxyz/modules/home/widgets/record_card.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:callerxyz/riverpod/your_records.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  getUserRecord() {
    //get user record from the database
    supabase
        .from("user_records")
        .select()
        .eq("uid", supabase.auth.currentUser!.id)
        .select()
        .order('date')
        .then((results) {
      debugPrint("${results.length} records fetched");
      ref
          .watch(yourRecordsProvider.notifier)
          .setRecords(results.map((e) => RecordModel.fromJson(e)).toList());
      setState(() {
        _loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint("Error fetching records: $error");
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_loading)
              Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child:
                    const CircularProgressIndicator(strokeCap: StrokeCap.round),
              ),
            const Text(
              "Your Record",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (ref.watch(yourRecordsProvider).records.isEmpty && !_loading)
          Expanded(
            child: Center(
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
          ),
        if (_loading)
          Expanded(
            child: ListView.builder(
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
          ),
        if (!_loading && ref.watch(yourRecordsProvider).records.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: ref.watch(yourRecordsProvider).records.length,
              itemBuilder: (context, index) {
                final record = ref.watch(yourRecordsProvider).records[index];
                return RecordCard(record: record);
              },
            ),
          ),
      ],
    );
  }
}
