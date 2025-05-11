import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';
import '../../utils/responsive.dart';

class PaymentGridTile extends StatelessWidget {
  final String imageUrl;
  bool isSelected;
  PaymentGridTile(this.imageUrl, this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: isSelected ? 2.5 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            height: 46,
            width: (screenWidth - 130) / 3,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cc.greyBorder2,
                width: 1,
              ),
              color:
                  isSelected ? cc.primaryColor.withOpacity(.1) : cc.pureWhite,
            ),
            child: Center(
              child: Image.network(
                imageUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
