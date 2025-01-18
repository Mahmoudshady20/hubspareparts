import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../utils/responsive.dart';

class OrderDetailsTileSkeleton extends StatelessWidget {
  const OrderDetailsTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 110,
            width: 110,
            padding: const EdgeInsets.all(2),
            color: Colors.white,
          ),
        ),
        EmptySpaceHelper.emptywidth(15),
        SizedBox(
          width: screenWidth - 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 180,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
              EmptySpaceHelper.emptyHight(5),
              SizedBox(
                height: 25,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 30,
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: cc.greyBorder2,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        EmptySpaceHelper.emptywidth(5),
                    itemCount: 10),
              ),
              EmptySpaceHelper.emptyHight(5),
              moneyRow(),
              EmptySpaceHelper.emptyHight(5),
              moneyRow(),
              EmptySpaceHelper.emptyHight(5),
              moneyRow(),
              EmptySpaceHelper.emptyHight(5),
            ],
          ),
        ),
      ],
    );
  }

  moneyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
        ),
        EmptySpaceHelper.emptywidth(5),
        Container(
          width: 30,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
