// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/views/refund_list_view.dart';
import 'package:safecart/views/settings_view.dart';

import '../../services/auth_service/sign_in_service.dart';
import '../../views/shipping_address_list_view.dart';
import '../../views/sign_in_view.dart';
import '../../views/ticket_list_view.dart';
import '../helpers/account_delete_helper.dart';
import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../helpers/logout_helper.dart';
import '../helpers/navigation_helper.dart';
import '../services/profile_info_service.dart';
import '../services/rtl_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/profile_view.dart/profile_info.dart';
import 'change_password_view.dart';
import 'edit_profile_view.dart';
import 'orders_list_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          Provider.of<NavigationHelper>(context, listen: false).setNavIndex(0),
      child: Consumer<ProfileInfoService>(builder: (context, pProvider, child) {
        return pProvider.profileInfo != null
            ? Stack(
                children: [
                  Container(
                    height:
                        screenHeight / 2.5 >= 300 ? screenHeight / 2.5 : 300,
                    width: double.infinity,
                    color: cc.primaryColor,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: screenHeight - 188,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              'v1.0',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight,
                    child: CustomScrollView(slivers: [
                      SliverAppBar(
                        elevation: 0,
                        leadingWidth: 60,
                        toolbarHeight: 60,
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        expandedHeight: screenHeight / 3.3 >= 230
                            ? screenHeight / 3.4
                            : 230,
                        flexibleSpace: FlexibleSpaceBar(
                          background: ProfileInfo(),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 5,
                                  color: cc.pureWhite,
                                  surfaceTintColor: cc.pureWhite,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 35),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Column(children: [
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!.my_orders,
                                        'assets/icons/orders.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              OrdersListView.routeName);
                                        },
                                      ),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!.refund_status,
                                        'assets/icons/refund.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              RefundListView
                                                  .routeName);
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!
                                            .shipping_address,
                                        'assets/icons/menu_shipping_address.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ShippingAddressListView
                                                  .routeName);
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!
                                            .support_Ticket,
                                        'assets/icons/support_ticket.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              TicketListView.routeName);
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!.language,
                                        'assets/icons/language.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              SettingsView.routeName);
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!
                                            .edit_profile,
                                        'assets/icons/edit_profile.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              EditProfileView.routeName);
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!
                                            .change_Password,
                                        'assets/icons/change_pass.svg',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ChangePasswordView.routeName);
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!
                                            .delete_account,
                                        'assets/icons/profile_delete.svg',
                                        onTap: () async {
                                          bool continueLogout = false;
                                          continueLogout = await AccountDelete()
                                              .delete(context);
                                          if (continueLogout) {
                                            Provider.of<ProfileInfoService>(
                                                    context,
                                                    listen: false)
                                                .logout();
                                          }
                                        },
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      profileItem(
                                        context,
                                        AppLocalizations.of(context)!.sign_out,
                                        'assets/icons/sign_out.svg',
                                        divider: false,
                                        onTap: () async {
                                          bool continueLogout = false;
                                          continueLogout = await LogoutHelper()
                                              .logout(context);
                                          if (continueLogout) {
                                            Provider.of<ProfileInfoService>(
                                                    context,
                                                    listen: false)
                                                .logout();
                                          }
                                        },
                                      ),
                                    ]),
                                  ),
                                ),
                                EmptySpaceHelper.emptyHight(230),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    height: screenHeight / 3 >= 200 ? screenHeight / 3 : 200,
                    width: double.infinity,
                    color: cc.primaryColor,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: screenHeight - 175,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              'v1.0',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EmptySpaceHelper.emptyHight(screenHeight / 7),
                                  Card(
                                    elevation: 5,
                                    color: cc.pureWhite,
                                    surfaceTintColor: cc.pureWhite,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 35),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Container(
                                            alignment: Alignment.center,
                                            constraints: const BoxConstraints(
                                                maxWidth: 300),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'assets/images/avatar.png',
                                                    height: screenHeight / 6,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 30),
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .you_ll_have_to_Sign_in_Sign_up_to_edit_or_see_your_profile_info,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ))),
                                                const SizedBox(height: 20),
                                                CustomCommonButton(
                                                    btText: AppLocalizations.of(
                                                            context)!
                                                        .sign_in_Sign_up,
                                                    isLoading: false,
                                                    onPressed: () async {
                                                      Provider.of<SignInService>(
                                                              context,
                                                              listen: false)
                                                          .setObscurePassword(
                                                              true);
                                                      Navigator.of(context)
                                                          .pushNamed(SignInView
                                                              .routeName)
                                                          .then(
                                                        (value) {
                                                          SystemChrome
                                                              .setSystemUIOverlayStyle(
                                                                  const SystemUiOverlayStyle(
                                                            statusBarColor: Colors
                                                                .transparent, // transparent status bar
                                                            statusBarIconBrightness:
                                                                Brightness.dark,
                                                          ));
                                                        },
                                                      );
                                                    },
                                                    width: screenWidth / 2)
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget profileItem(
    BuildContext context,
    String itemText,
    String iconPath, {
    void Function()? onTap,
    bool icon = true,
    double imageSize = 35,
    double imageSize2 = 35,
    double textSize = 16,
    bool divider = true,
  }) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            child: ListTile(
              onTap: onTap,
              visualDensity: const VisualDensity(vertical: -3),
              dense: false,
              leading: icon
                  ? SvgPicture.asset(
                      iconPath,
                      height: imageSize,
                    )
                  : Image.asset(
                      iconPath,
                      height: imageSize,
                    ),
              title: Text(
                itemText,
                style: TextStyle(
                  fontSize: textSize,
                  color: cc.blackColor,
                ),
              ),
              trailing: Container(
                margin: Provider.of<RTLService>(context, listen: false).langRtl
                    ? const EdgeInsets.only(left: 25)
                    : null,
                child: Transform(
                  transform:
                      Provider.of<RTLService>(context, listen: false).langRtl
                          ? Matrix4.rotationY(pi)
                          : Matrix4.rotationY(0),
                  child: SvgPicture.asset(
                    'assets/icons/arrow_boxed_right.svg',
                  ),
                ),
              ),
            ),
          ),
          if (divider) const Divider()
        ],
      ),
    );
  }
}
