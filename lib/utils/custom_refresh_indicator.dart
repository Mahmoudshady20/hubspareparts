import 'package:flutter/material.dart';
import 'package:safecart/helpers/common_helper.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final child;
  final onRefresh;
  const CustomRefreshIndicator({super.key, this.child, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: cc.primaryColor,
        color: cc.pureWhite,
        child: child,
        onRefresh: onRefresh);
  }
}
