import 'package:flutter/material.dart';

class SqueezedBox extends StatelessWidget {
  const SqueezedBox({
    super.key,
    required this.maxHeight,
    this.squeezeRatio = 2,
  });

  final double maxHeight;
  final double squeezeRatio;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: BoxConstraints(minHeight: maxHeight / squeezeRatio, maxHeight: maxHeight));
  }
}
