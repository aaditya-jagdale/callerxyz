import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecordState {
  late final String date;
  final int totalDialed;
  final int connected;
  final int callbackReq;
  final int meetings;
  final int conversions;

  RecordState({
    String? date,
    int? totalDialed,
    int? connected,
    int? callbackReq,
    int? meetings,
    int? conversions,
  })  : date = date ?? DateFormat('MMM dd, yyyy').format(DateTime.now()),
        totalDialed = totalDialed ?? 0,
        connected = connected ?? 0,
        callbackReq = callbackReq ?? 0,
        meetings = meetings ?? 0,
        conversions = conversions ?? 0;

  RecordState copyWith({
    String? date,
    int? totalDialed,
    int? connected,
    int? callbackReq,
    int? meetings,
    int? conversions,
  }) {
    return RecordState(
      date: date ?? this.date,
      totalDialed: totalDialed ?? this.totalDialed,
      connected: connected ?? this.connected,
      callbackReq: callbackReq ?? this.callbackReq,
      meetings: meetings ?? this.meetings,
      conversions: conversions ?? this.conversions,
    );
  }

  double get dialToConnect => totalDialed == 0 ? 0 : connected / totalDialed;
  double get connectToMeeting => connected == 0 ? 0 : meetings / connected;
  double get meetingToConversion => meetings == 0 ? 0 : conversions / meetings;
  double get dialToMeeting => totalDialed == 0 ? 0 : meetings / totalDialed;
}

class RecordDataProvider extends StateNotifier<RecordState> {
  RecordDataProvider() : super(RecordState());

  void initializeRecord(RecordModel record) {
    state = RecordState(
      date: record.date,
      totalDialed: record.dialed,
      connected: record.connected,
      callbackReq: record.callbacks,
      meetings: record.meetings,
      conversions: record.conversions,
    );
  }

  void updateDate(String newDate) {
    state = state.copyWith(date: newDate);
  }

  void updateTotalDialed(int newTotalDialed) {
    state = state.copyWith(
      totalDialed: newTotalDialed,
      connected:
          newTotalDialed < state.connected ? newTotalDialed : state.connected,
      meetings:
          newTotalDialed < state.meetings ? newTotalDialed : state.meetings,
      conversions: newTotalDialed < state.conversions
          ? newTotalDialed
          : state.conversions,
    );
  }

  void dialedIncrement() {
    state = state.copyWith(totalDialed: state.totalDialed + 1);
  }

  void dialedDecrement() {
    if (state.totalDialed > 0) {
      state = state.copyWith(
        totalDialed: state.totalDialed - 1,
        connected: state.connected > state.totalDialed - 1
            ? state.totalDialed - 1
            : state.connected,
        meetings: state.meetings > state.totalDialed - 1
            ? state.totalDialed - 1
            : state.meetings,
        conversions: state.conversions > state.totalDialed - 1
            ? state.totalDialed - 1
            : state.conversions,
      );
    }
  }

  void updateConnected(int newConnected) {
    state = state.copyWith(
      connected:
          newConnected > state.totalDialed ? state.totalDialed : newConnected,
      meetings: newConnected < state.meetings ? newConnected : state.meetings,
      conversions:
          newConnected < state.conversions ? newConnected : state.conversions,
    );
  }

  void connectedIncrement() {
    if (state.connected < state.totalDialed) {
      state = state.copyWith(connected: state.connected + 1);
    }
  }

  void connectedDecrement() {
    if (state.connected > 0) {
      state = state.copyWith(
        connected: state.connected - 1,
        meetings: state.meetings > state.connected - 1
            ? state.connected - 1
            : state.meetings,
        conversions: state.conversions > state.connected - 1
            ? state.connected - 1
            : state.conversions,
      );
    }
  }

  void updateCallbackReq(int newCallbackReq) {
    state = state.copyWith(
      callbackReq:
          newCallbackReq > state.connected ? state.connected : newCallbackReq,
    );
  }

  void callbackReqIncrement() {
    if (state.callbackReq < state.connected) {
      state = state.copyWith(callbackReq: state.callbackReq + 1);
    }
  }

  void callbackReqDecrement() {
    if (state.callbackReq > 0) {
      state = state.copyWith(callbackReq: state.callbackReq - 1);
    }
  }

  void updateMeetings(int newMeetings) {
    state = state.copyWith(
      meetings: newMeetings > state.connected ? state.connected : newMeetings,
      conversions:
          newMeetings < state.conversions ? newMeetings : state.conversions,
    );
  }

  void meetingsIncrement() {
    if (state.meetings < state.connected) {
      state = state.copyWith(meetings: state.meetings + 1);
    }
  }

  void meetingsDecrement() {
    if (state.meetings > 0) {
      state = state.copyWith(
        meetings: state.meetings - 1,
        conversions: state.conversions > state.meetings - 1
            ? state.meetings - 1
            : state.conversions,
      );
    }
  }

  void updateConversions(int newConversions) {
    state = state.copyWith(
      conversions:
          newConversions > state.meetings ? state.meetings : newConversions,
    );
  }

  void conversionsIncrement() {
    if (state.conversions < state.meetings) {
      state = state.copyWith(conversions: state.conversions + 1);
    }
  }

  void conversionsDecrement() {
    if (state.conversions > 0) {
      state = state.copyWith(conversions: state.conversions - 1);
    }
  }

  double get meetingsToConversion {
    if (state.meetings == 0) return 0;
    return state.conversions / state.meetings;
  }


  

  void reset() {
    state = RecordState();
  }
}

final recordDataController =
    StateNotifierProvider<RecordDataProvider, RecordState>((ref) {
  return RecordDataProvider();
});
