import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsData {
  final List<FlSpot> dialed;
  final List<FlSpot> connected;
  final List<FlSpot> meetings;
  final List<FlSpot> conversions;
  final List<DateTime> timeFrame;

  const AnalyticsData({
    List<FlSpot>? dialed,
    List<FlSpot>? connected,
    List<FlSpot>? meetings,
    List<FlSpot>? conversions,
    List<DateTime>? timeFrame,
  })  : dialed = dialed ?? const [],
        connected = connected ?? const [],
        meetings = meetings ?? const [],
        conversions = conversions ?? const [],
        timeFrame = timeFrame ?? const [];

  AnalyticsData copyWith({
    List<FlSpot>? dialed = const [],
    List<FlSpot>? connected = const [],
    List<FlSpot>? meetings = const [],
    List<FlSpot>? conversions = const [],
    List<DateTime>? timeFrame = const [],
  }) {
    return AnalyticsData(
      dialed: dialed ?? this.dialed,
      connected: connected ?? this.connected,
      meetings: meetings ?? this.meetings,
      conversions: conversions ?? this.conversions,
      timeFrame: timeFrame ?? this.timeFrame,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsData> {
  AnalyticsNotifier() : super(const AnalyticsData());

  void updateTimeframe(int index) {
    List<DateTime> timeFrame = [];
    if (index == 0) {
      timeFrame = [DateTime.now().subtract(const Duration(days: 7))];
    }
    if (index == 1) {
      timeFrame = [DateTime.now().subtract(const Duration(days: 30))];
    }
    if (index == 2) {
      timeFrame = [DateTime.now().subtract(const Duration(days: 90))];
    }
    state = state.copyWith(timeFrame: timeFrame);
  }

  void updateDailed(List<int> dialed) {
    //convert to FlSpot
    List<FlSpot> dialedSpots =
        dialed.map((e) => FlSpot(e.toDouble(), e.toDouble())).toList();

    state = state.copyWith(dialed: dialedSpots);
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsData>((ref) {
  return AnalyticsNotifier();
});
