import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/rtl_service.dart';

class FilterRtlPadding extends StatelessWidget {
  final Widget child;
  final double? padding;
  const FilterRtlPadding({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final rtl = Provider.of<RTLService>(context, listen: false).langRtl;
    return Padding(
      padding: EdgeInsets.only(
        left: rtl ? 0 : padding ?? 25.0,
        right: rtl ? padding ?? 25 : 0,
      ),
      child: child,
    );
  }
}
