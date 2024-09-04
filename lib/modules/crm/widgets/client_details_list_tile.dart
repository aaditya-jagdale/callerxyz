import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';

class ClientDetailsListTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String placeholder;
  final String subtitle;
  final Function()? onTap;
  final Function()? onLongPress;
  const ClientDetailsListTile({
    super.key,
    required this.icon,
    this.title = '',
    required this.placeholder,
    this.subtitle = '',
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: CustomColors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 10),
            if (title.isEmpty)
              Text(
                placeholder,
                style: TextStyle(
                  color: CustomColors.black25,
                  fontSize: 16,
                ),
              ),
            if (title.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.black,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        height: 1,
                        color: CustomColors.black25,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
