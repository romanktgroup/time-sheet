import 'package:flutter/material.dart';
import 'package:time_sheet/core/theme/app_color.dart';
import 'package:time_sheet/core/theme/app_style.dart';

class BottomRow extends StatelessWidget {
  const BottomRow({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyle.inter18w500.copyWith(color: AppColor.black),
          ),
        ),
        const Spacer(),
        Text(
          text,
          style: AppStyle.inter18w500.copyWith(color: AppColor.black),
        ),
      ],
    );
  }
}
