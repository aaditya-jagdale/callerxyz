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
      DateTime.now().subtract(Duration(days: DateTime.now().weekday + 1));
  int timeFrameIndex = 0;
  List<FlSpot> dialed = [];
  List<FlSpot> connected = [];
  List<FlSpot> meetings = [];
  List<FlSpot> conversions = [];
  List<FlSpot> dialToConnected = [];
  int totalDialed = 0;
  int totalConnected = 0;
  int totalMeetings = 0;
  int totalConversions = 0;

  getUserData() async {
    List<RecordModel> results = widget.records;
    List<RecordModel> records = results;

    totalDialed = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.dialed)
        .reduce((a, b) => a + b)
        .toInt();

    totalConnected = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.connected)
        .reduce((a, b) => a + b)
        .toInt();

    totalMeetings = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.meetings)
        .reduce((a, b) => a + b)
        .toInt();

    totalConversions = records
        .where((record) => DateTime.parse(record.date).isAfter(afterDate))
        .map((record) => record.conversions)
        .reduce((a, b) => a + b)
        .toInt();

    final dialedList = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(afterDate) &&
            record.dialed != 0)
        .map((record) => FlSpot(
            DateTime.now()
                    .difference(DateTime.parse(record.date))
                    .inDays
                    .toDouble() *
                -1,
            record.dialed.toDouble()))
        .toList();

    final connectedList = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(afterDate) &&
            record.connected != 0)
        .map((record) => FlSpot(
            DateTime.now()
                    .difference(DateTime.parse(record.date))
                    .inDays
                    .toDouble() *
                -1,
            record.connected.toDouble()))
        .toList();

    final meetingList = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(afterDate) &&
            record.meetings != 0)
        .map((record) => FlSpot(
            DateTime.now()
                    .difference(DateTime.parse(record.date))
                    .inDays
                    .toDouble() *
                -1,
            record.meetings.toDouble()))
        .toList();

    final conversionsList = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(afterDate) &&
            record.conversions != 0)
        .map((record) => FlSpot(
            DateTime.now()
                    .difference(DateTime.parse(record.date))
                    .inDays
                    .toDouble() *
                -1,
            record.conversions.toDouble()))
        .toList();

    final dialToConnectList = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(afterDate) &&
            record.dialed != 0 &&
            record.connected != 0)
        .map((record) => FlSpot(
            DateTime.now()
                    .difference(DateTime.parse(record.date))
                    .inDays
                    .toDouble() *
                -1,
            (record.connected / record.dialed * 100).toDouble()))
        .toList();


    setState(() {
      dialed = dialedList;
      connected = connectedList;
      meetings = meetingList;
      conversions = conversionsList;
      dialToConnected = dialToConnectList;
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
                    timeFrameIndex = 0;
                    afterDate = DateTime.now()
                        .subtract(Duration(days: DateTime.now().weekday + 1));

                    getUserData();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: timeFrameIndex == 0
                          ? CustomColors.black
                          : CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Last Week",
                      style: TextStyle(
                        color: timeFrameIndex == 0
                            ? CustomColors.white
                            : CustomColors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    afterDate = DateTime(
                            DateTime.now().year, DateTime.now().month - 1, 1)
                        .subtract(const Duration(days: 1));
                    setState(() {
                      timeFrameIndex = 1;
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
                      color: timeFrameIndex == 1
                          ? CustomColors.black
                          : CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Last Month",
                      style: TextStyle(
                        color: timeFrameIndex == 1
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
                      timeFrameIndex = 2;
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
                      color: timeFrameIndex == 2
                          ? CustomColors.black
                          : CustomColors.black10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Year to date",
                      style: TextStyle(
                        color: timeFrameIndex == 2
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
                  // timeFrame: timeFrame,
                  title: "Dialed Record",
                ),
                MainGraphCard(
                  pointsList: dialToConnected,
                  // timeFrame: timeFrame,
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
                TrackRecordTile(title: "Dialed", value: totalDialed),
                TrackRecordTile(title: "Connected", value: totalConnected),
                TrackRecordTile(title: "Meetings", value: totalMeetings),
                TrackRecordTile(title: "Conversions", value: totalConversions),
              ],
            ),
          )
        ],
      ),
    );
  }
}
