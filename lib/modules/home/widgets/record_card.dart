import 'package:callerxyz/modules/records/screens/record_details.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:callerxyz/modules/shared/widgets/transitions.dart';
import 'package:callerxyz/riverpod/record_data.dart';
import 'package:callerxyz/riverpod/records_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecordCard extends ConsumerStatefulWidget {
  final RecordModel record;
  const RecordCard({super.key, required this.record});

  @override
  ConsumerState<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends ConsumerState<RecordCard> {
  final supabase = Supabase.instance.client;

  updateSupabase() async {
    await supabase
        .from('user_records')
        .update({
          'dialed': ref.read(recordDataController).totalDialed,
          'connected': ref.read(recordDataController).connected,
          'meetings': ref.read(recordDataController).meetings,
          'conversions': ref.read(recordDataController).conversions,
          'callbacks': ref.read(recordDataController).callbackReq,
        })
        .eq('uid', supabase.auth.currentUser!.id)
        .eq('id', widget.record.id)
        .select()
        .then((value) {
          ref
              .read(yourRecordsProvider.notifier)
              .updateRecord(RecordModel.fromJson(value[0]));
        })
        .onError((error, stackTrace) {
          errorSnackBar(context, "Error updating record");
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rightSlideTransition(context, RecordDetails(record: widget.record),
            onComplete: () {
          updateSupabase();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CustomColors.black10,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy')
                      .format(DateTime.parse(widget.record.date)),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  //day of the week
                  DateFormat("EEEE").format(DateTime.parse(widget.record.date)),
                  style: const TextStyle(
                    color: CustomColors.black50,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "DTC",
                  style: TextStyle(
                    color: CustomColors.black50,
                    fontSize: 14,
                  ),
                ),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(
                    begin: 0,
                    end: widget.record.dial_to_connect.toDouble(),
                  ),
                  builder: (context, value, child) {
                    return Text(
                      "${value.toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: value < 10
                            ? CustomColors.red
                            : value < 25
                                ? CustomColors.yellow
                                : CustomColors.green,
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
