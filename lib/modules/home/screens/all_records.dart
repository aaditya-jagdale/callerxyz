import 'package:callerxyz/modules/home/widgets/record_card.dart';
import 'package:callerxyz/riverpod/records_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllRecords extends ConsumerStatefulWidget {
  const AllRecords({super.key});

  @override
  ConsumerState<AllRecords> createState() => _AllRecordsState();
}

class _AllRecordsState extends ConsumerState<AllRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "All Records",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ref.watch(yourRecordsProvider).records.isEmpty
            ? const Expanded(
                child: Center(
                  child: Text("No calling history"),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ref.watch(yourRecordsProvider).records.length,
                itemBuilder: (context, index) {
                  final record = ref.watch(yourRecordsProvider).records[index];
                  return RecordCard(record: record);
                },
              ),
      ),
    );
  }
}
