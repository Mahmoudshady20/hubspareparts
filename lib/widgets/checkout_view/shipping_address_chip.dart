import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class ShippingAddressChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  const ShippingAddressChip(
      {this.isSelected = false, this.title = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? null : Border.all(color: cc.greyBorder),
        color: isSelected ? cc.primaryColor : null,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? cc.pureWhite : cc.greyHint),
      ),
    );
  }
}
