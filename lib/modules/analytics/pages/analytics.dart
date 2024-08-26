import 'package:callerxyz/modules/analytics/widget/main_graph_card.dart';
import 'package:callerxyz/modules/analytics/widget/track_record_tile.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/riverpod/analytics_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class Analytics extends ConsumerStatefulWidget {
  const Analytics({super.key});

  @override
  ConsumerState<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<Analytics> {
  final supabase = Supabase.instance.client;

  getUserData() async {
    List results = await supabase
        .from('user_records')
        .select()
        .eq('uid', supabase.auth.currentUser!.id)
        .select();
    List<RecordModel> records =
        results.map((record) => RecordModel.fromJson(record)).toList();

    //Check the value of dialed where date is higher than 2024-06-20
    final dailyDialed = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(DateTime.parse('2024-06-20')))
        .map((record) => FlSpot(DateTime.parse(record.date).day.toDouble(),
            record.dialed.toDouble()))
        .toList();

    final dialToConnect = records
        .where((record) =>
            DateTime.parse(record.date).isAfter(DateTime.parse('2024-06-20')))
        .map((record) {
      double percentage =
          record.dialed > 0 ? (record.connected / record.dialed) * 100 : 0;
      return FlSpot(DateTime.parse(record.date).day.toDouble(), percentage);
    }).toList();

    // ref.watch(analyticsProvider.notifier).updateDailed(dailyDialed);
    // ref.watch(analyticsProvider.notifier).updateDailedToConnect(dialToConnect);
    debugPrint("-------------------------dialed: $dailyDialed");
  }

  @override
  void initState() {
    getUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
                // MainGraphCard(
                //   pointsList: ref.watch(analyticsProvider).dailed,
                //   timeFrame: ref.watch(analyticsProvider).timePeriods,
                //   title: "Dialed Record",
                // ),
                // MainGraphCard(
                //   pointsList: ref.watch(analyticsProvider).dailedToConnect,
                //   timeFrame: ref.watch(analyticsProvider).timePeriods,
                //   title: "Dial-to-Connect %",
                // ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Track Record",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TrackRecordTile(title: "Dialed", value: 1000000),
                TrackRecordTile(title: "Connected", value: 1065650),
                TrackRecordTile(title: "Meetings", value: 100),
                TrackRecordTile(title: "Conversions", value: 5100),
              ],
            ),
          )
        ],
      ),
    );
  }
}
