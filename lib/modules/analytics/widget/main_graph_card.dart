import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MainGraphCard extends StatelessWidget {
  final List<FlSpot> pointsList;
  // final List<DateTime> timeFrame;
  final String title;

  const MainGraphCard({
    super.key,
    required this.pointsList,
    // required this.timeFrame,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      width: w * 0.8,
      height: 260,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: CustomColors.black25,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    preventCurveOverShooting: true,
                    color: CustomColors.black,
                    belowBarData: BarAreaData(
                      show: true,
                      color: CustomColors.black.withOpacity(0.2),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 2,
                          color: CustomColors.black,
                          strokeWidth: 1,
                          strokeColor: CustomColors.white,
                        );
                      },
                    ),
                    spots: pointsList,
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        if (value <= 0 || value > 100) {
                          return const SizedBox();
                        }
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        DateTime date = DateTime.now()
                            .subtract(Duration(days: value.toInt()));
                        //only display first and last dates
                        if (value.toInt() == 0) {
                          return Text(
                            DateFormat('dd/MM').format(date),
                            style: const TextStyle(fontSize: 12),
                          );
                        }
                        if (value.toInt() ==
                            pointsList[pointsList.length - 1].x) {
                          return Text(
                            DateFormat('dd/MM').format(date),
                            style: const TextStyle(fontSize: 12),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: CustomColors.black, width: 1),
                    left: BorderSide(color: CustomColors.black, width: 1),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) {
                      return CustomColors.black;
                    },
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          title == "Dialed Record"
                              ? '${flSpot.y.toStringAsFixed(0)} calls'
                              : '${flSpot.y.toStringAsFixed(0)} %',
                          const TextStyle(
                            color: CustomColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
