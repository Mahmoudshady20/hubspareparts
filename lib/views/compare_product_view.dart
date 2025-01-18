import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/compare_product_view/compare_product_card.dart';

import '../widgets/common/custom_icon_button.dart';

class CompareProductView extends StatelessWidget {
  const CompareProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: (screenHeight - 60) / 2,
                child: const CompareProductCard(),
                // SizedBox(
                //     height: (screenHeight - 60) / 2,
                //     child: const CompareProductCard()
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomIconButton(
              SvgPicture.asset(
                'assets/icons/arrow_left.svg',
                color: cc.pureWhite,
              ),
              onPressed: () {},
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomIconButton(
              SvgPicture.asset(
                'assets/icons/arrow_right.svg',
                color: cc.pureWhite,
              ),
              onPressed: () {},
            ),
          ),
        )
      ],
    )

        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   padding: const EdgeInsets.symmetric(vertical: 20),
        //   child: Row(
        //     children: [
        //       for (var i in [5, 5, 6, 4, 6]) const CompareProductCard(),
        //     ],
        //   ),
        ;
  }
}
