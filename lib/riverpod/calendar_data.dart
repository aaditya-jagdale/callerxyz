import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarDataNotifier extends StateNotifier<List<int>> {
  CalendarDataNotifier() : super([]);

  void setCalendarData(List<int> data) {
    state = data;
  }

  void addDate(int date) {
    if (!state.contains(date)) {
      state = [...state, date];
    }
  }

  void removeDate(int date) {
    state = List.from(state)..remove(date);
  }

  void clearCalendarData() {
    state = [];
  }
}

final calendarDataProvider =
    StateNotifierProvider<CalendarDataNotifier, List<int>>((ref) {
  return CalendarDataNotifier();
});
