import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final void Function()? onTap;
  final Widget? child;
  final bool rounded;
  const CustomInkWell(this.onTap, this.child, {this.rounded = true, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: rounded ? BorderRadius.circular(10) : BorderRadius.zero,
      child: Material(
          child: InkWell(
        onTap: onTap,
        child: child,
      )),
    );
  }
}
