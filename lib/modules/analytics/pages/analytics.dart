import 'package:callerxyz/modules/analytics/widget/main_graph_card.dart';
import 'package:callerxyz/modules/analytics/widget/track_record_tile.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/riverpod/records_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class Analytics extends ConsumerStatefulWidget {
  final List<RecordModel> records;
  const Analytics({super.key, required this.records});

  @override
  ConsumerState<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<Analytics> {
  final supabase = Supabase.instance.client;
  List<FlSpot> dialed = [];
  List<FlSpot> connected = [];
  List<FlSpot> meetings = [];
  List<FlSpot> conversions = [];
  List<FlSpot> dialToConnected = [];

  getUserData() async {
    List<RecordModel> results = widget.records;

    List<RecordModel> records = results;
    // debugPrint("-------------------------all records: $records");

    final totalDialed = records
        .where((record) => DateTime.parse(record.date)
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .map((record) => record.dialed != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.dialed.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalConnected = records
        .where((record) => DateTime.parse(record.date)
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .map((record) => record.connected != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.connected.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalMeetings = records
        .where((record) => DateTime.parse(record.date)
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .map((record) => record.meetings != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.meetings.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalConversions = records
        .where((record) => DateTime.parse(record.date)
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .map((record) => record.conversions != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.conversions.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalDialToConnected = records
        .where((record) => DateTime.parse(record.date)
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .map((record) => record.dialed != 0 && record.connected != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                (record.connected / record.dialed * 100).toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    setState(() {
      dialed = totalDialed;
      connected = totalConnected;
      meetings = totalMeetings;
      conversions = totalConversions;
      dialToConnected = totalDialToConnected;
    });
  }

  @override
  void initState() {
    getUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.black,
        onPressed: () {
          getUserData();
        },
        child: const Icon(
          Icons.refresh,
          color: CustomColors.white,
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "Analytics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // ref.read(analyticsProvider.notifier).updateSelectedIndex(0);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "Last Week",
                      style: TextStyle(color: CustomColors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // ref.read(analyticsProvider.notifier).updateSelectedIndex(1);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "Last Month",
                      style: TextStyle(color: CustomColors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // ref.read(analyticsProvider.notifier).updateSelectedIndex(2);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "Last Year",
                      style: TextStyle(color: CustomColors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // ref.read(analyticsProvider.notifier).updateSelectedIndex(3);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "All Time",
                      style: TextStyle(color: CustomColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MainGraphCard(
                  pointsList: dialed,
                  timeFrame: List.generate(
                      7,
                      (index) =>
                          DateTime.now().subtract(Duration(days: index))),
                  title: "Dialed Record",
                ),
                MainGraphCard(
                  pointsList: dialToConnected,
                  timeFrame: List.generate(
                      7,
                      (index) =>
                          DateTime.now().subtract(Duration(days: index))),
                  title: "Dial-to-Connect %",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Track Record",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TrackRecordTile(title: "Dialed", value: dialed.length),
                TrackRecordTile(title: "Connected", value: connected.length),
                TrackRecordTile(title: "Meetings", value: meetings.length),
                TrackRecordTile(
                    title: "Conversions", value: conversions.length),
              ],
            ),
          )
        ],
      ),
    );
  }
}
