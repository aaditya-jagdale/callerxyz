import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  final RecordModel record;
  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                DateFormat('MMM dd, yyyy').format(DateTime.parse(record.date)),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                //day of the week
                DateFormat("EEEE").format(DateTime.parse(record.date)),
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
              Text(
                "${record.dial_to_connect}%",
                style: TextStyle(
                  color: record.dial_to_connect > 20
                      ? CustomColors.green
                      : CustomColors.red,
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
