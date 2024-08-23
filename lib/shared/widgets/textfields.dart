import 'package:callerxyz/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String? hint;
  final String? icon;
  final int? maxLines;
  final String? errorText;
  const CustomTextField({
    super.key,
    this.controller,
    required this.title,
    this.hint,
    this.icon,
    this.maxLines,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        maxLines: maxLines,
        controller: controller,
        style: const TextStyle(
          color: CustomColors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          errorText: errorText,
          alignLabelWithHint: true,
          prefixIcon: icon == null
              ? null
              : SvgPicture.asset(
                  icon!,
                  fit: BoxFit.scaleDown,
                  color: CustomColors.white,
                  height: 14,
                  width: 14,
                ),
          hintText: hint,
          hintStyle: const TextStyle(color: CustomColors.black25),
          labelStyle: const TextStyle(
            color: CustomColors.black,
            fontWeight: FontWeight.w500,
          ),
          focusColor: CustomColors.black,
          label: Text(
            title,
            style: const TextStyle(
              color: CustomColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: CustomColors.black.withOpacity(0.2), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: CustomColors.black, width: 2),
          ),
        ),
      ),
    );
  }
}
