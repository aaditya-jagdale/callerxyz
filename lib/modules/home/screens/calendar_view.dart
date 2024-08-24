import 'dart:math';

import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CallendarView extends StatefulWidget {
  const CallendarView({super.key});

  @override
  State<CallendarView> createState() => _CallendarViewState();
}

class _CallendarViewState extends State<CallendarView> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<int> dates = [];

  final startDate = DateTime.now().subtract(const Duration(days: 365 - 1));

  insertRecord() async {
    final data = await supabase.from('user_records').insert({
      'uid': supabase.auth.currentUser!.id,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'day': DateFormat('EEEE').format(DateTime.now()),
      'dialed': Random().nextInt(10),
      'connected': Random().nextInt(10),
      'callbacks': Random().nextInt(10),
      'meetings': Random().nextInt(10),
      'conversions': Random().nextInt(10),
    });

    debugPrint("Record Inserted: $data");
  }

  getCalendarData() async {
    final data = await supabase
        .from('user_records')
        .select("date")
        .eq("uid", supabase.auth.currentUser!.id);
    setState(() {
      dates = data
          .map<int>((e) => DateTime.now()
              .difference(DateTime.parse(e["date"].toString()))
              .inDays)
          .toList();
      _isLoading = false;
    });

    debugPrint("Calendar Data: $dates");
  }

  @override
  void initState() {
    getCalendarData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: CustomColors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isLoading
                    ? Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          strokeCap: StrokeCap.round,
                          color: CustomColors.white,
                        ),
                      )
                    : SvgPicture.asset("assets/bicep.svg"),
              ),
              const SizedBox(width: 8),
              const Text(
                "Streak",
                style: TextStyle(
                  color: CustomColors.black25,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 108,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 365,
              itemBuilder: (context, index) {
                int today = DateTime.now().weekday - 1;
                bool isSuccessful = dates.contains(index - today);

                if (mounted) {
                  return Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: isSuccessful
                          ? CustomColors.black25
                          : CustomColors.black25.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
