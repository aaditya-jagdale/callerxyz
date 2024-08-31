import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarDataNotifier extends StateNotifier<Map<String, List<int>>> {
  CalendarDataNotifier() : super({'isSuccessful': [], 'isConverted': []});

  void setCalendarData(String key, List<int> data) {
    state = {...state, key: data};
  }

  void addDate(String key, int date) {
    state = {
      ...state,
      key: [...state[key]!, date]
    };
  }

  void removeDate(String key, int date) {
    state = {
      ...state,
      key: state[key]!.where((element) => element != date).toList()
    };
  }

  void clearCalendarData() {
    state = {'isSuccessful': [], 'isConverted': []};
  }
}

final calendarDataProvider = StateNotifierProvider<CalendarDataNotifier, Map<String, List<int>>>((ref) {
  return CalendarDataNotifier();
});
