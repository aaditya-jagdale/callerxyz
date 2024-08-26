import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:intl/intl.dart';

class RecordState {
  final List<RecordModel> records;
  final RecordModel todayRecord;

  RecordState({required this.records, required this.todayRecord});

  List<RecordModel> get sortedRecords {
    return List.from(records)..sort((a, b) => b.date.compareTo(a.date));
  }
}

class YourRecordsNotifier extends StateNotifier<RecordState> {
  YourRecordsNotifier()
      : super(RecordState(records: [], todayRecord: RecordModel()));

  void setTodayRecord(RecordModel record) {
    debugPrint("------------setting today record: $record");
    state = RecordState(records: state.records, todayRecord: record);
  }

  void setRecords(List<RecordModel> records) {
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayRecord = records.firstWhere(
      (e) => e.date == todayDate,
      orElse: () => RecordModel(),
    );

    state = RecordState(
      records: records.where((e) => e.date != todayDate).toList(),
      todayRecord: todayRecord,
    );
  }

  void addRecord(RecordModel record) {
    state = RecordState(
        records: [...state.records, record], todayRecord: state.todayRecord);
  }

  RecordModel getRecord(RecordModel record) {
    return state.records.firstWhere((element) => element.id == record.id);
  }

  void updateRecord(RecordModel updatedRecord) {
    debugPrint("------------update record: $updatedRecord");

    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (updatedRecord.date == todayDate) {
      state = RecordState(records: state.records, todayRecord: updatedRecord);
    } else {
      state = RecordState(
        records: [
          for (final record in state.records)
            if (record.id == updatedRecord.id) updatedRecord else record
        ],
        todayRecord: state.todayRecord,
      );
    }
  }

  void removeRecord(String recordId) {
    state = RecordState(
      records: state.records.where((record) => record.id != recordId).toList(),
      todayRecord: state.todayRecord,
    );
  }

  void clearRecords() {
    state = RecordState(records: [], todayRecord: RecordModel());
  }
}

final yourRecordsProvider =
    StateNotifierProvider<YourRecordsNotifier, RecordState>((ref) {
  return YourRecordsNotifier();
});
