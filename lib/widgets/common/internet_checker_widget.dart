import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/internet_checker_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import 'custom_common_button.dart';

class InternetCheckerWidget extends StatelessWidget {
  final Widget widget;
  final Widget loadingWidget;
  final retryFunction;

  const InternetCheckerWidget(
      {required this.widget,
      required this.loadingWidget,
      this.retryFunction,
      super.key});

  @override
  Widget build(BuildContext context) {
    final ic = Provider.of<InternetCheckerService>(context, listen: false);
    return FutureBuilder(
      future: ic.checkConnection(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        }
        return ic.haveConnection
            ? widget
            : Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight / 1.5,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'assets/animations/no_internet.json',
                                  height: screenHeight / 2,
                                ),
                              ],
                            ),
                          ]),
                    ),
                    EmptySpaceHelper.emptyHight(16),
                    Text(
                      AppLocalizations.of(context)!.oops,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    EmptySpaceHelper.emptyHight(8),
                    Text(
                      AppLocalizations.of(context)!.no_wifi_or_cellular_data_found,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    EmptySpaceHelper.emptyHight(24),
                    if (retryFunction != null)
                      CustomCommonButton(
                          onPressed: () async {
                            ic.setHaveConnection(true);
                            retryFunction();
                          },
                          btText: 'Retry',
                          width: 100,
                          isLoading: false)
                  ],
                ),
              );
      },
    );
  }
}
