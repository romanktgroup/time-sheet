import 'package:flutter/material.dart';
import 'package:time_sheet/core/theme/app_color.dart';
import 'package:time_sheet/core/theme/app_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.initialValue,
  });

  final void Function(String)? onChanged;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.blue),
      borderRadius: BorderRadius.circular(0),
    );
    return TextFormField(
      initialValue: initialValue,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: AppStyle.inter14w500.copyWith(color: AppColor.black),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        hintStyle: AppStyle.inter14w500.copyWith(color: AppColor.hint),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    );
  }
}
