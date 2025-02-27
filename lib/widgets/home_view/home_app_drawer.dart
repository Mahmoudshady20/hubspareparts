import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/views/settings_view.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../helpers/logout_helper.dart';
import '../../services/auth_service/sign_in_service.dart';
import '../../services/profile_info_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/responsive.dart';
import '../../views/change_password_view.dart';
import '../../views/edit_profile_view.dart';
import '../../views/orders_list_view.dart';
import '../../views/shipping_address_list_view.dart';
import '../../views/sign_in_view.dart';
import '../../views/ticket_list_view.dart';
import '../common/custom_common_button.dart';
import '../profile_view.dart/profile_info.dart';

class HomeAppDrawer extends StatelessWidget {
  const HomeAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cc.pureWhite,
      child: Consumer<ProfileInfoService>(builder: (context, pProvider, child) {
        return pProvider.profileInfo != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: screenHeight / 2.5 >= 300
                            ? screenHeight / 2.5
                            : 300,
                        width: double.infinity,
                        color: cc.primaryColor,
                        child: Center(child: ProfileInfo()),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(children: [
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.my_orders,
                            'assets/icons/orders.svg',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(OrdersListView.routeName);
                            },
                          ),
                          EmptySpaceHelper.emptyHight(10),
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.shipping_address,
                            'assets/icons/menu_shipping_address.svg',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ShippingAddressListView.routeName);
                            },
                          ),
                          EmptySpaceHelper.emptyHight(10),
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.support_Ticket,
                            'assets/icons/support_ticket.svg',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(TicketListView.routeName);
                            },
                          ),
                          EmptySpaceHelper.emptyHight(10),
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.language,
                            'assets/icons/language.svg',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SettingsView.routeName);
                            },
                          ),
                          EmptySpaceHelper.emptyHight(10),
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.edit_profile,
                            'assets/icons/edit_profile.svg',
                            onTap: () {
                              // final pProvider = Provider.of<ProfileInfoService>(
                              //     context,
                              //     listen: false);
                              // if (pProvider.profileInfo?.userDetails.userCountry
                              //         ?.name !=
                              //     null) {
                              //   Provider.of<CountryStateService>(context,
                              //           listen: false)
                              //       .fetchAllStates(
                              //           context,
                              //           Provider.of<CountryStateService>(
                              //                   context,
                              //                   listen: false)
                              //               .getCountryId(pProvider
                              //                   .profileInfo
                              //                   ?.userDetails
                              //                   .userCountry!
                              //                   .name));
                              // }
                              Navigator.of(context)
                                  .pushNamed(EditProfileView.routeName);
                            },
                          ),
                          EmptySpaceHelper.emptyHight(10),
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.change_Password,
                            'assets/icons/change_pass.svg',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ChangePasswordView.routeName);
                            },
                          ),
                          // EmptySpaceHelper.emptyHight(10),
                          // profileItem(
                          //   context,
                          //   asProvider.getString('Delete account'),
                          //   'assets/icons/delete.svg',
                          //   onTap: () async {
                          //     bool continueLogout = false;
                          //     continueLogout =
                          //         await AccountDelete().delete(context);
                          //     if (continueLogout) {
                          //       Provider.of<ProfileInfoService>(context,
                          //               listen: false)
                          //           .logout();
                          //     }
                          //   },
                          // ),
                          EmptySpaceHelper.emptyHight(10),
                          profileItem(
                            context,
                            AppLocalizations.of(context)!.sign_out,
                            'assets/icons/sign_out.svg',
                            divider: false,
                            onTap: () async {
                              bool continueLogout = false;
                              continueLogout =
                                  await LogoutHelper().logout(context);
                              if (continueLogout) {
                                Provider.of<ProfileInfoService>(context,
                                        listen: false)
                                    .logout();
                              }
                            },
                          ),
                          const Divider(),
                          SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'v1.0',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          EmptySpaceHelper.emptyHight(30),
                        ]),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height - 150,
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profileItem(
                          context,
                          AppLocalizations.of(context)!.language,
                          'assets/icons/language.svg',
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SettingsView.routeName);
                          },
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/avatar.png',
                            height: screenHeight / 6,
                            // width: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                                AppLocalizations.of(context)!
                                    .you_ll_have_to_Sign_in_Sign_up_to_edit_or_see_your_profile_info,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                ))),
                        const SizedBox(height: 20),
                        CustomCommonButton(
                            btText:
                                AppLocalizations.of(context)!.sign_in_Sign_up,
                            isLoading: false,
                            onPressed: () async {
                              // final continueLogin =
                              //     await LogInHelper().loginPopup(context);
                              // if (continueLogin) {
                              //   Provider.of<ProfileInfoService>(context,
                              //           listen: false)
                              //       .login();
                              // }

                              // Provider.of<SignInSignUpService>(context,
                              //         listen: false)
                              //     .getUserData();
                              // Provider.of<SignInSignUpService>(context,
                              //         listen: false)
                              //     .toggleSigninSignup(value: true);
                              // Provider.of<SignInService>(context, listen: false)
                              //     .setRememberPassword(true);
                              Provider.of<SignInService>(context, listen: false)
                                  .setObscurePassword(true);
                              Navigator.of(context)
                                  .pushNamed(SignInView.routeName)
                                  .then(
                                (value) {
                                  SystemChrome.setSystemUIOverlayStyle(
                                      const SystemUiOverlayStyle(
                                    statusBarColor: Colors
                                        .transparent, // transparent status bar
                                    statusBarIconBrightness: Brightness.dark,
                                  ));
                                },
                              );
                            },
                            width: screenWidth / 2)
                      ],
                    )),
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
