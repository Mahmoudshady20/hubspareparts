import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class CategoryChip extends StatelessWidget {
  String title;
  bool isSelected;
  void Function()? onTap;
  CategoryChip(this.title, this.isSelected, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? null : Border.all(color: cc.greyBorder),
            color: isSelected ? cc.primaryColor : null,
          ),
          child:
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              // SizedBox(
              //   height: 35,
              //   width: 35,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(602),
              //     child: CachedNetworkImage(
              //       fit: BoxFit.cover,
              //       // color: Colors.red,
              //       imageUrl:
              //           'https://img.freepik.com/free-photo/young-teen-woman-sunglasses-hat-holding-shopping-bags-her-hands-feeling-so-happiness-isolated-green-wall_231208-2681.jpg?w=1060&t=st=1671427887~exp=1671428487~hmac=bd891f5a97cbed3b154d12b7168fcb730c2463857a320f2385e1cbf3bd029753',
              //       placeholder: (context, url) {
              //         return Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               height: 40,
              //               width: 40,
              //               decoration: const BoxDecoration(
              //                   image: DecorationImage(
              //                       image: AssetImage(
              //                           'assets/images/app_icon.png'),
              //                       opacity: .5)),
              //             ),
              //           ],
              //         );
              //       },
              //       errorWidget: (context, url, error) {
              //         return Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               height: 40,
              //               width: 40,
              //               decoration: const BoxDecoration(
              //                   image: DecorationImage(
              //                       image: AssetImage(
              //                           'assets/images/app_icon.png'),
              //                       opacity: .5)),
              //             ),
              //           ],
              //         );
              //       },
              //     ),
              //   ),
              // ),
              // EmptySpaceHelper.emptywidth(5),
              Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? cc.pureWhite : cc.greyHint),
          ),
          //   ],
          // ),
        ));
  }
}
