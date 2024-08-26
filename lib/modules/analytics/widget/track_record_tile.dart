import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/widgets.dart';

class TrackRecordTile extends StatelessWidget {
  final String title;
  final int value;
  const TrackRecordTile({
    super.key,
    required this.title,
    required this.value,
  });

  String formatInt(int int) {
    return int.toString().replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'), (match) => '${match.group(0)},');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CustomColors.black10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            formatInt(value),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
