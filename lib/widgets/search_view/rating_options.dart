import 'package:flutter/material.dart';
import 'package:safecart/helpers/common_helper.dart';

import 'package:safecart/utils/responsive.dart';

class RatingOptions extends StatelessWidget {
  final int ratingPoint;
  final bool value;
  final String title;
  final Function onChanged;
  const RatingOptions(this.ratingPoint, this.value, this.title, this.onChanged,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth - 50,
      child: CheckboxListTile(
        checkColor: cc.primaryColor,
        activeColor: cc.primaryColor,
        selectedTileColor: cc.primaryColor,
        checkboxShape: const CircleBorder(),
        contentPadding: const EdgeInsets.all(0),
        visualDensity: const VisualDensity(vertical: -3),
        dense: false,
        title: Text(
          title,
          style: TextStyle(
              color: value ? cc.greyParagraph : cc.greyFour,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        value: value,
        onChanged: (newValue) {
          onChanged();
          // payProvider.changeOption(true);
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
