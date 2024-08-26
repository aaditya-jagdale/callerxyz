import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarDataNotifier extends StateNotifier<List<int>> {
  CalendarDataNotifier() : super([]);

  void setCalendarData(List<int> data) {
    state = data;
  }

  void addDate(int date) {
    state = [...state, date];
  }

  void removeDate(int date) {
    state = state.where((element) => element != date).toList();
  }

  void clearCalendarData() {
    state = [];
  }
}

final calendarDataProvider = StateNotifierProvider<CalendarDataNotifier, List<int>>((ref) {
  return CalendarDataNotifier();
});

