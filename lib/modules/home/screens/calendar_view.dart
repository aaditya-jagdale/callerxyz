import 'dart:math';

import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/riverpod/calendar_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CallendarView extends ConsumerStatefulWidget {
  const CallendarView({super.key});

  @override
  ConsumerState<CallendarView> createState() => _CallendarViewState();
}

class _CallendarViewState extends ConsumerState<CallendarView> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  final startDate = DateTime.now().subtract(const Duration(days: 365 - 1));

  insertRecord() async {
    await supabase.from('user_records').insert({
      'uid': supabase.auth.currentUser!.id,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'day': DateFormat('EEEE').format(DateTime.now()),
      'dialed': Random().nextInt(10),
      'connected': Random().nextInt(10),
      'callbacks': Random().nextInt(10),
      'meetings': Random().nextInt(10),
      'conversions': Random().nextInt(10),
    });
  }

  getCalendarData() async {
    final data = await supabase
        .from('user_records')
        .select("date, conversions")
        .eq("uid", supabase.auth.currentUser!.id)
        .neq("dialed", 0);

    ref.read(calendarDataProvider.notifier).setCalendarData(
          data
              .map<int>((e) => DateTime.now()
                  .difference(DateTime.parse(e["date"].toString()))
                  .inDays)
              .toList(),
        );

    ref.read(calendarDataProvider.notifier).setCalendarData(
          data
              .where((e) => e["conversions"] != 0)
              .map<int>((e) => DateTime.now()
                  .difference(DateTime.parse(e["date"].toString()))
                  .inDays)
              .toList(),
        );

    _isLoading = false;
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
                int today = DateTime.now().weekday - 7;
                bool isSuccessful =
                    ref.watch(calendarDataProvider).contains(index + today);

                if (mounted) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
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
