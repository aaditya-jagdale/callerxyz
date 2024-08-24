import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecordState {
  final String _date;
  final int _totalDialed;
  final int _connected;
  final int _callbackReq;
  final int _meetings;
  final int _conversions;

  RecordState({
    String date = '',
    int totalDialed = 0,
    int connected = 0,
    int callbackReq = 0,
    int meetings = 0,
    int conversions = 0,
  })  : _date = date.isNotEmpty
            ? date
            : DateFormat('MMM dd, yyyy').format(DateTime.now()),
        _totalDialed = totalDialed,
        _connected = connected,
        _callbackReq = callbackReq,
        _meetings = meetings,
        _conversions = conversions;

  String get date => _date;
  int get totalDialed => _totalDialed;
  int get connected => _connected;
  int get callbackReq => _callbackReq;
  int get meetings => _meetings;
  int get conversions => _conversions;
  double get dialToConnect => _connected / _totalDialed;
  double get connectToMeeting => _meetings / _connected;
  double get meetingToConversion => _conversions / _meetings;
  double get dialToMeeting => _conversions / _meetings;
}

class RecordDataProvider extends StateNotifier<RecordState> {
  RecordDataProvider() : super(RecordState());

  void updateDate(String newDate) {
    state = RecordState(date: newDate);
  }

  void updateTotalDialed(int newTotalDialed) {
    state = RecordState(totalDialed: newTotalDialed);
  }

  void dialedIncrement() {
    state = RecordState(totalDialed: state.totalDialed + 1);
  }

  void dialedDecrement() {
    if (state.totalDialed > 0) {
      state = RecordState(totalDialed: state.totalDialed - 1);
    }
  }

  void updateConnected(int newConnected) {
    state = RecordState(connected: newConnected);
  }

  void connectedIncrement() {
    state = RecordState(connected: state.connected + 1);
  }

  void connectedDecrement() {
    state = RecordState(connected: state.connected - 1);
  }

  void updateCallbackReq(int newCallbackReq) {
    state = RecordState(callbackReq: newCallbackReq);
  }

  void callbackReqIncrement() {
    state = RecordState(callbackReq: state.callbackReq + 1);
  }

  void callbackReqDecrement() {
    state = RecordState(callbackReq: state.callbackReq - 1);
  }

  void updateMeetings(int newMeetings) {
    state = RecordState(meetings: newMeetings);
  }

  void meetingsIncrement() {
    state = RecordState(meetings: state.meetings + 1);
  }

  void meetingsDecrement() {
    state = RecordState(meetings: state.meetings - 1);
  }

  void updateConversions(int newConversions) {
    state = RecordState(conversions: newConversions);
  }

  void conversionsIncrement() {
    state = RecordState(conversions: state.conversions + 1);
  }

  void conversionsDecrement() {
    state = RecordState(conversions: state.conversions - 1);
  }

  void reset() {
    state = RecordState();
  }
}

final recordDataController =
    StateNotifierProvider<RecordDataProvider, RecordState>((ref) {
  return RecordDataProvider();
});
