import 'package:callerxyz/modules/analytics/widget/main_graph_card.dart';
import 'package:callerxyz/modules/analytics/widget/track_record_tile.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
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
  DateTime afterDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day));
  List<DateTime> timeFrame = List.generate(
      7, (index) => DateTime.now().subtract(Duration(days: index)));
  List<FlSpot> dialed = [];
  List<FlSpot> connected = [];
  List<FlSpot> meetings = [];
  List<FlSpot> conversions = [];
  List<FlSpot> dialToConnected = [];

  getUserData() async {
    List<RecordModel> results = widget.records;
    List<RecordModel> records = results;

    final totalDialed = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.dialed != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.dialed.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalConnected = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.connected != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.connected.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalMeetings = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.meetings != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.meetings.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalConversions = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.conversions != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                record.conversions.toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    final totalDialToConnected = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.dialed != 0 && record.connected != 0
            ? FlSpot(DateTime.parse(record.date).day.toDouble(),
                (record.connected / record.dialed * 100).toDouble())
            : null)
        .where((spot) => spot != null)
        .cast<FlSpot>()
        .toList();

    debugPrint("-------------------------totalDialed: $totalDialed");
    debugPrint("-------------------------totalConnected: $totalConnected");
    debugPrint("-------------------------totalMeetings: $totalMeetings");
    debugPrint("-------------------------totalConversions: $totalConversions");
    debugPrint(
        "-------------------------totalDialToConnected: ${totalDialToConnected.length}");

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    afterDate = DateTime.now()
                        .subtract(Duration(days: DateTime.now().weekday + 1));
                    setState(() {
                      timeFrame = List.generate(
                          7,
                          (index) =>
                              DateTime.now().subtract(Duration(days: index)));
                    });
                    getUserData();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: timeFrame.length == 7
                          ? CustomColors.black
                          : CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Last Week",
                      style: TextStyle(
                        color: timeFrame.length == 7
                            ? CustomColors.white
                            : CustomColors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    afterDate =
                        DateTime(DateTime.now().year, DateTime.now().month)
                            .subtract(const Duration(days: 1));
                    setState(() {
                      timeFrame = List.generate(
                          30,
                          (index) =>
                              DateTime.now().subtract(Duration(days: index)));
                    });
                    getUserData();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: timeFrame.length == 30
                          ? CustomColors.black
                          : CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Last Month",
                      style: TextStyle(
                        color: timeFrame.length == 30
                            ? CustomColors.white
                            : CustomColors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    afterDate = DateTime(DateTime.now().year)
                        .subtract(const Duration(days: 1));
                    setState(() {
                      timeFrame = List.generate(
                          365,
                          (index) =>
                              DateTime.now().subtract(Duration(days: index)));
                    });
                    getUserData();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: timeFrame.length == 365
                          ? CustomColors.black
                          : CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Last Year",
                      style: TextStyle(
                        color: timeFrame.length == 365
                            ? CustomColors.white
                            : CustomColors.black,
                      ),
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
                  timeFrame: timeFrame,
                  title: "Dialed Record",
                ),
                MainGraphCard(
                  pointsList: dialToConnected,
                  timeFrame: timeFrame,
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
