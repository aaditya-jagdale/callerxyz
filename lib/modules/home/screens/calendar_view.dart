import 'dart:math';

import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/widgets.dart';
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
  List<DateTime> dates = [];
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

    debugPrint("Record Inserted: ${data}");
  }

  getCalendarData() async {
    final data = await supabase
        .from('user_records')
        .select("date")
        .eq("uid", supabase.auth.currentUser!.id);

    dates = data
        .map<DateTime>((e) => DateTime.parse(e["date"].toString()))
        .toList();

    debugPrint("Calendar Data: $data");
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
              GestureDetector(
                onTap: () => insertRecord(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: CustomColors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset("assets/bicep.svg"),
                ),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                40,
                (index) => Column(
                  children: List.generate(
                    7,
                    (index) => Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: CustomColors.black25.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: const EdgeInsets.all(3),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
