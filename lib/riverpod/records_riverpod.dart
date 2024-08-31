import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';

class RecordState {
  final List<RecordModel> records;

  RecordState({required this.records});

  List<RecordModel> get sortedRecords {
    return List.from(records)..sort((a, b) => b.date.compareTo(a.date));
  }
}

class YourRecordsNotifier extends StateNotifier<RecordState> {
  YourRecordsNotifier() : super(RecordState(records: []));

  void setRecords(List<RecordModel> records) {
    state = RecordState(records: records);
  }

  void addRecord(RecordModel record) {
    state = RecordState(records: [...state.records, record]);
  }

  RecordModel getRecord(RecordModel record) {
    return state.records.firstWhere((element) => element.id == record.id);
  }

  void updateRecord(RecordModel updatedRecord) {
    state = RecordState(
      records: [
        for (final record in state.records)
          if (record.id == updatedRecord.id) updatedRecord else record
      ],
    );
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
