import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/intro_service.dart';
import 'package:safecart/utils/dot_indicator.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/common_services.dart';
import '../utils/custom_row_button.dart';
import '../utils/responsive.dart';
import 'home_front_view.dart';

class IntroView extends StatelessWidget {
  static String routeName = 'intro_view';

  IntroView({super.key});
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Consumer<IntroService>(builder: (context, iProvider, child) {
      if (iProvider.introList!.isEmpty) {
        Navigator.of(context).pushReplacementNamed(HomeFrontView.routeName);
      }
      return Scaffold(
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenWidth - 44,
                  child: PageView(
                      controller: controller,
                      onPageChanged: (index) {
                        iProvider.setIndex(index);
                      },
                      children: Provider.of<IntroService>(context,
                              listen: false)
                          .introList!
                          .map(
                            (e) => Container(
                              alignment: Alignment.bottomCenter,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: screenWidth - 60,
                                    width: screenWidth - 60,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList()),
                ),
                EmptySpaceHelper.emptyHight(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    iProvider.introList![iProvider.currentIndex]['title']
                        as String,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: cc.blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                EmptySpaceHelper.emptyHight(5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    iProvider.introList![iProvider.currentIndex]['description']
                        as String,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: cc.greyParagraph, fontSize: 15),
                  ),
                ),
                EmptySpaceHelper.emptyHight(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: iProvider.introList!
                      .map(
                        (e) => DotIndicator(
                            iProvider.introList!.indexOf(e) ==
                                iProvider.currentIndex,
                            dotCount: iProvider.introList?.length ?? 0),
                      )
                      .toList(),
                ),
              ]),
          bottomNavigationBar: Container(
            height: 50,
            margin: const EdgeInsets.all(20),
            child: CustomRowButton(
              bt1text: AppLocalizations.of(context)!.skip,
              bt1func: () {
                Provider.of<CommonServices>(context, listen: false)
                    .introSubmitted();
                Navigator.of(context)
                    .pushReplacementNamed(HomeFrontView.routeName);
              },
              bt2text: iProvider.currentIndex ==
                      ((iProvider.introList?.length ?? 0) - 1)
                  ? AppLocalizations.of(context)!.submit
                  : AppLocalizations.of(context)!.continue_button,
              bt2func: () {
                if (iProvider.introList!.indexOf(iProvider.introList!.last) ==
                    iProvider.currentIndex) {
                  Provider.of<CommonServices>(context, listen: false)
                      .introSubmitted();
                  Navigator.of(context)
                      .pushReplacementNamed(HomeFrontView.routeName);
                  return;
                }
                controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
            ),
          ));
    });
  }
}
