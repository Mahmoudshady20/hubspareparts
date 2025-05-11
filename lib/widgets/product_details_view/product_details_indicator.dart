import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class ProductDetailsIndicator extends StatefulWidget {
  bool isActive;
  ProductDetailsIndicator(this.isActive, {super.key});

  @override
  State<ProductDetailsIndicator> createState() =>
      _ProductDetailsIndicatorState();
}

class _ProductDetailsIndicatorState extends State<ProductDetailsIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.isActive
              ? cc.primaryColor
              : cc.primaryColor.withValues(alpha: .5),

          // color: widget.isActive
          //     ? ConstantColors().primaryColor
          //     : ConstantColors().greyDots,
        ),
      ),
    );
  }
}
