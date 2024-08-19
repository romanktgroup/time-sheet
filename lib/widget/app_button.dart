import 'package:flutter/material.dart';
import 'package:time_sheet/core/theme/app_color.dart';
import 'package:time_sheet/core/theme/app_style.dart';

enum AppButtonStyle { normal, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.style = AppButtonStyle.normal,
  });

  final String title;
  final VoidCallback onTap;
  final AppButtonStyle style;

  @override
  Widget build(BuildContext context) {
    const borderColor = AppColor.blue;
    final textColor = switch (style) {
      AppButtonStyle.normal => AppColor.white,
      AppButtonStyle.outlined => AppColor.blue,
    };
    final backgroundColor = switch (style) {
      AppButtonStyle.normal => AppColor.blue,
      AppButtonStyle.outlined => AppColor.white,
    };
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppStyle.inter18w500.copyWith(color: textColor),
        ),
      ),
    );
  }
}
