import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/helpers/navigation_helper.dart';
import 'package:safecart/services/search_seatvice.dart';
import 'package:safecart/services/settings_services.dart';
import 'package:safecart/views/product_search_view.dart';
import 'package:safecart/widgets/home_front/custom_search_field.dart';

import '../../services/profile_info_service.dart';
import '../../services/search_product_service.dart';

class HFAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HFAppBar(this.scaffoldKey, {super.key});

  @override
  State<HFAppBar> createState() => _HFAppBarState();
}

class _HFAppBarState extends State<HFAppBar> {
  final searchBarFocusNode = FocusNode();
  bool showField = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Consumer<NavigationHelper>(builder: (context, nhProvider, child) {
      return SliverAppBar(
        backgroundColor:
            nhProvider.currentIndex == 4 ? cc.primaryColor : Colors.white,
        foregroundColor:
            nhProvider.currentIndex == 4 ? cc.primaryColor : cc.blackColor,
        toolbarHeight: 65,
        elevation: 0,
        pinned: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title:
            Consumer<ProfileInfoService>(builder: (context, pProvider, child) {
          return appBarTitle(pProvider, nhProvider.currentIndex);
        }),
        leading:
            Consumer<NavigationHelper>(builder: (context, nhProvider, child) {
          return nhProvider.currentIndex == 4
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10,
                            left: rtlProvider.langRtl ? 0 : 10,
                            right: rtlProvider.langRtl ? 10 : 0),
                        color: Colors.transparent,
                        child: GestureDetector(
                            child: SvgPicture.asset(
                          'assets/icons/menu.svg',
                        )),
                      ),
                    ),
                  ],
                );
        }),
        actions: [
          Stack(
            alignment: rtlProvider.langRtl
                ? Alignment.centerLeft
                : Alignment.centerRight,
            children: [
              Column(
                children: [
                  Container(
                    height: 55,
                    margin: EdgeInsets.only(
                        top: 10,
                        right: nhProvider.currentIndex == 1 ? 0 : 10,
                        left: nhProvider.currentIndex == 1 ? 0 : 10),
                    child: SizedBox(
                      height: 45,
                      child: Consumer<SearchService>(
                          builder: (context, sProvider, child) {
                        return CustomSearchField(
                            textEditingController: textEditingController,
                            showField: sProvider.showSearchBar,
                            onFieldSubmit: () {
                              if (textEditingController.text.isEmpty) {
                                return;
                              }
                              Provider.of<SearchProductService>(context,
                                      listen: false)
                                  .setFilterOptions(
                                      nameVal: textEditingController.text);
                              Provider.of<SearchProductService>(context,
                                      listen: false)
                                  .fetchProducts(context);
                              FocusScope.of(context).unfocus();
                              Navigator.of(context)
                                  .pushNamed(ProductSearchView.routeName);
                            });
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
          nhProvider.currentIndex == 1
              ? GestureDetector(
                  onTap: () async {
                    Provider.of<SearchProductService>(context, listen: false)
                        .setFilterOptions(nameVal: textEditingController.text);
                    Provider.of<SearchProductService>(context, listen: false)
                        .fetchProducts(context);
                    FocusScope.of(context).unfocus();
                    Navigator.of(context)
                        .pushNamed(ProductSearchView.routeName);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: cc.greyFive,
                        width: 1.5,
                      ),
                      color: cc.pureWhite,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/filter.svg',
                      color: cc.blackColor,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    });
  }

  appBarTitle(pProvider, index) {
    if (index == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            pProvider.profileInfo == null
                ? (AppLocalizations.of(context)!.welcome_to)
                : ('${AppLocalizations.of(context)!.welcome_back}!'),
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            pProvider.profileInfo == null
                ? (AppLocalizations.of(context)!.safeCart)
                : pProvider.profileInfo!.userDetails.name
                    .toString()
                    .capitalize(),
            style: const TextStyle(fontSize: 20),
          )
        ],
      );
    }
    if (index == 1) {
      return Text(
        AppLocalizations.of(context)!.products,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: cc.blackColor),
      );
    }
    if (index == 2) {
      return Text(
        AppLocalizations.of(context)!.my_Cart,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: cc.blackColor),
      );
    }
    if (index == 3) {
      return Text(
        AppLocalizations.of(context)!.my_wishlist,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: cc.blackColor),
      );
    }
    return const SizedBox();
  }
}
