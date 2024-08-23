import 'package:callerxyz/shared/widgets/colors.dart';
import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String title;
  final Widget? btnIcon;
  final void Function()? onTap;
  const CustomPrimaryButton({
    super.key,
    required this.title,
    this.btnIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: CustomColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (btnIcon != null) btnIcon!,
            if (btnIcon != null) const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: CustomColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
