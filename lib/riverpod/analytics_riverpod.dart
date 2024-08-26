// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';

// class AnalyticsState {
//   final List<FlSpot> dialed;
//   final List<FlSpot> connected;
//   final List<FlSpot> meetings;
//   final List<FlSpot> conversions;

//   AnalyticsState({
//     required this.dialed,
//     required this.connected,
//     required this.meetings,
//     required this.conversions,
//   });

//   AnalyticsState copyWith({
//     List<FlSpot>? dialed,
//     List<FlSpot>? connected,
//     List<FlSpot>? meetings,
//     List<FlSpot>? conversions,
//   }) {
//     return AnalyticsState(
//       dialed: dialed ?? this.dialed,
//       connected: connected ?? this.connected,
//       meetings: meetings ?? this.meetings,
//       conversions: conversions ?? this.conversions,
//     );
//   }
// }

// class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
//   AnalyticsNotifier()
//       : super(AnalyticsState(
//           dialed: [],
//           connected: [],
//           meetings: [],
//           conversions: [],
//         ));

//   void updateDialed(List<FlSpot> dialed) {
//     state = state.copyWith(dialed: dialed);
//   }

//   void updateConnected(List<FlSpot> connected) {
//     state = state.copyWith(connected: connected);
//   }

//   void updateMeetings(List<FlSpot> meetings) {
//     state = state.copyWith(meetings: meetings);
//   }

//   void updateConversions(List<FlSpot> conversions) {
//     state = state.copyWith(conversions: conversions);
//   }
// }

// final analyticsProvider =
//     StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
//   return AnalyticsNotifier();
// });
