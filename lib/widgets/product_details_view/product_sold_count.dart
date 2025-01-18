import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class ProductSoldCount extends StatelessWidget {
  const ProductSoldCount({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cc.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Text(
            '20 Product sold last day',
            style: TextStyle(color: cc.pureWhite, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
