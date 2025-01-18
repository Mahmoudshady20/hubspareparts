// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/country_state_service.dart';
import 'package:safecart/services/intro_service.dart';
import 'package:safecart/services/profile_info_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../helpers/db_helper.dart';
import '../helpers/network_connectivity.dart';
import '../services/cart_data_service.dart';
import '../services/common_services.dart';
import '../services/payment_gateway_service.dart';
import '../services/wishlist_data_service.dart';
import '../utils/responsive.dart';
import 'home_front_view.dart';
import 'intro_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    dbInit(context);
    initiateStartingSequence(context);
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: cc.primaryColor,
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
            ),
          ),
          Consumer<RTLService>(builder: (context, rtlProvider, child) {
            return Positioned(
                bottom: screenWidth / 2.5,
                child: rtlProvider.noConnection
                    ? TextButton(
                        onPressed: () {
                          initiateStartingSequence(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: cc.primaryColor,
                          backgroundColor: cc.pureWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          surfaceTintColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          elevation: 0,
                        ),
                        child: Text(
                          asProvider.getString('Retry'),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: cc.primaryColor),
                        ),
                      )
                    : CustomPreloader(
                        whiteColor: true,
                        width: 80,
                      ));
          })
        ],
      ),
    );
  }

  dbInit(BuildContext context) {
    List databases = ['cart', 'wishlist'];
    databases.map((e) => DbHelper.database(e));
    Provider.of<CartDataService>(context, listen: false).fetchCarts();
    Provider.of<WishlistDataService>(context, listen: false)
        .fetchWishlistItem();
  }

  initiateStartingSequence(BuildContext context) async {
    final hasConnection = await checkConnection(context);
    if (!hasConnection) {
      rtlProvider.setNoConnection(true);
      return;
    }

    final NetworkConnectivity networkConnectivity =
        NetworkConnectivity.instance;
    networkConnectivity.listenToConnectionChange(context);
    await Provider.of<RTLService>(context, listen: false)
        .fetchCurrency(context);
    await Provider.of<RTLService>(context, listen: false).fetchLang(context);
    await Provider.of<SaveSignInInfoService>(context, listen: false)
        .getSaveinfos(context);
    log("fetching filter options");
    Provider.of<SearchFilterDataService>(context, listen: false)
        .fetchSearchfilterData(context);
    final gotoIntro =
        await Provider.of<CommonServices>(context, listen: false).checkIntro();

    Provider.of<PaymentGatewayService>(context, listen: false)
        .fetchGateways(context);

    final pi = Provider.of<ProfileInfoService>(context, listen: false);
    if (!gotoIntro) {
      await Provider.of<IntroService>(context, listen: false)
          .fetchIntro(context);
      Navigator.of(context).popAndPushNamed(IntroView.routeName);
    } else {
      await pi.fetchProfileInfo(context);
      Navigator.of(context).popAndPushNamed(HomeFrontView.routeName);
    }
    if (pi.profileInfo == null) {
      setToken('');
    }
  }
}
