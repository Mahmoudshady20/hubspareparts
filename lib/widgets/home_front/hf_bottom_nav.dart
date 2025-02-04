import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/services/cart_data_service.dart';
import 'package:safecart/services/wishlist_data_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/navigation_helper.dart';

class HFBottomNav extends StatefulWidget {
  const HFBottomNav({super.key});

  @override
  State<HFBottomNav> createState() => _HFBottomNavState();
}

class _HFBottomNavState extends State<HFBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationHelper>(builder: (context, nProvider, child) {
      return BottomNavigationBar(
        selectedItemColor: cc.primaryColor,
        unselectedItemColor: cc.greyHint,
        backgroundColor: cc.pureWhite,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: nProvider.currentIndex,
        onTap: (value) => nProvider.setNavIndex(value),
        items: items,
      );
    });
  }

  List<BottomNavigationBarItem> get items => [
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/home_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 27,
              color: cc.greyHint,
            ),
            label: AppLocalizations.of(context)!.home),
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/product_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/products.svg',
              height: 27,
              color: cc.greyHint,
            ),
            label: AppLocalizations.of(context)!.products),
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/cart_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon:
                Consumer<CartDataService>(builder: (context, cartData, child) {
              return badge.Badge(
                showBadge: cartData.cartList.isEmpty ? false : true,
                badgeContent: Text(
                  cartData.totalQuantity().toString(),
                  style: TextStyle(color: cc.pureWhite),
                ),
                child: SvgPicture.asset(
                  'assets/icons/cart.svg',
                  height: 27,
                  color: cc.greyHint,
                ),
              );
            }),
            label: AppLocalizations.of(context)!.cart),
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/wishlist_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: Consumer<WishlistDataService>(
                builder: (context, wishlistData, child) {
              return badge.Badge(
                showBadge: wishlistData.wishlistItems.isNotEmpty,
                badgeContent: Text(
                  wishlistData.wishlistItems.length.toString(),
                  style: TextStyle(color: cc.pureWhite),
                ),
                child: SvgPicture.asset(
                  'assets/icons/wishlist.svg',
                  height: 27,
                  color: cc.greyHint,
                ),
              );
            }),
            label: AppLocalizations.of(context)!.wishlist),
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/profile_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              height: 27,
              color: cc.greyHint,
            ),
            label: AppLocalizations.of(context)!.profile),
      ];
}
