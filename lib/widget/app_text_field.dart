import 'package:flutter/material.dart';
import 'package:time_sheet/core/theme/app_color.dart';
import 'package:time_sheet/core/theme/app_style.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.max,
    this.keyboardType,
    this.initialValue,
  });

  final void Function(String)? onChanged;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;

  final double? max;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final controller = TextEditingController(text: widget.initialValue);

  @override
  void initState() {
    super.initState();

    if (widget.max == null) return;
    controller.addListener(() {
      final val = double.tryParse(controller.text);
      if (val == null) return;
      if (widget.max! < val) {
        controller.text = widget.max.toString();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.blue),
      borderRadius: BorderRadius.circular(0),
    );
    return TextFormField(
      controller: controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      style: AppStyle.inter14w500.copyWith(color: AppColor.black),
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        hintStyle: AppStyle.inter14w500.copyWith(color: AppColor.hint),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    );
  }
}
