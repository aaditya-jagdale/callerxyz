import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/widgets.dart';

class TodayTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final int value;
  final VoidCallback? onTap;
  const TodayTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CustomColors.black10,
      ),
      width: double.infinity,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
