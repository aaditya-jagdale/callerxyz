import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:intl/intl.dart';

class RecordState {
  final List<RecordModel> records;
  final RecordModel todayRecord;

  RecordState({required this.records, this.todayRecord = const RecordModel()});

  List<RecordModel> get sortedRecords {
    return List.from(records)..sort((a, b) => b.date.compareTo(a.date));
  }
}

class YourRecordsNotifier extends StateNotifier<RecordState> {
  YourRecordsNotifier() : super(RecordState(records: []));

  void setTodayRecord(RecordModel record) {
    state = RecordState(records: state.records, todayRecord: record);
  }

  void setRecords(List<RecordModel> records) {
    state = RecordState(
        records: records
            .where((e) =>
                e.date != DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .toList());
  }

  void addRecord(RecordModel record) {
    state = RecordState(records: [...state.records, record]);
  }

  void updateRecord(RecordModel updatedRecord) {
    state = RecordState(records: [
      for (final record in state.records)
        if (record.id == updatedRecord.id) updatedRecord else record
    ]);
  }

  void removeRecord(String recordId) {
    state = RecordState(
      records: state.records.where((record) => record.id != recordId).toList(),
    );
  }

  void clearRecords() {
    state = RecordState(records: []);
  }
}

final yourRecordsProvider =
    StateNotifierProvider<YourRecordsNotifier, RecordState>((ref) {
  return YourRecordsNotifier();
});
