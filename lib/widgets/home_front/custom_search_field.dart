import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/navigation_helper.dart';

import '../../helpers/common_helper.dart';
import '../../services/search_seatvice.dart';
import '../../utils/responsive.dart';

class CustomSearchField extends StatelessWidget {
  TextEditingController textEditingController;
  bool showField;
  void Function()? onFieldSubmit;
  final width;

  CustomSearchField({
    required this.textEditingController,
    required this.showField,
    required this.onFieldSubmit,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationHelper>(builder: (context, nhProvider, child) {
      return GestureDetector(
        onTap: () {
          textEditingController.clear();
          Provider.of<SearchService>(context, listen: false)
              .setShowSearchBar(!showField);
        },
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 500),
          // width: width ?? (screenWidth - 40),
          width: showField
              ? screenWidth -
                  (nhProvider.currentIndex == 4
                      ? 30
                      : nhProvider.currentIndex == 1
                          ? 107
                          : 58)
              : 45,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cc.greyBorder),
              color: cc.pureWhite),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),

            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 5),
              GestureDetector(
                  onTap: () {
                    onFieldSubmit!();
                    textEditingController.clear();
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: cc.blackColor,
                  )),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width:
                      screenWidth - (nhProvider.currentIndex == 4 ? 100 : 152),
                  // width: showField ? screenWidth - 120 : 0,
                  child: TextField(
                    controller: textEditingController,
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.search_your_need_here,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      onFieldSubmit!();
                      textEditingController.clear();
                    },
                  )),

              // const Spacer(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: showField
                    ? Icon(
                        Icons.close,
                        color: cc.blackColor,
                      )
                    : GestureDetector(
                        child: SvgPicture.asset(
                        'assets/icons/only_search.svg',
                        width: 22,
                      )),
              ),
            ].reversed.toList(),
          ),
        ),
      );
    });
  }
}
