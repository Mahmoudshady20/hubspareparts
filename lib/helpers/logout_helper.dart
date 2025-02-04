import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safecart/services/auth_service/sign_out_service.dart';
import 'package:safecart/widgets/common/custom_common_button.dart';
import 'package:safecart/widgets/common/custom_outlined_button.dart';

import 'common_helper.dart';

class LogoutHelper {
  logout(BuildContext context, {title, description}) async {
    bool logedIn = false;
    await Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: cc.blackColor.withValues(alpha: .6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: cc.blackColor.withValues(alpha: 0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Column(
            children: [
              Text(
                title ?? AppLocalizations.of(context)!.are_you_sure,
                style: TextStyle(color: cc.greytitle, fontSize: 17),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  CustomOutlinedButton(
                    isLoading: false,
                    width: 100,
                    btText: AppLocalizations.of(context)!.cancel,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Consumer<SignOutService>(
                      builder: (context, soProvider, child) {
                    return CustomCommonButton(
                      width: 100,
                      btText: AppLocalizations.of(context)!.sign_out,
                      isLoading: soProvider.loadingSignOut,
                      onPressed: () async {
                        await soProvider.signOut(context);
                        Navigator.pop(context);
                        // });
                        // provider.logout(context);
                        //if logged in by google then logout from it
                        // GoogleSignInService().logOutFromGoogleLogin();

                        //if logged in by facebook then logout from it
                        // FacebookLoginService().logoutFromFacebook();
                      },
                    );
                  }),
                ],
              )
            ],
          ),
        )).show();
    return logedIn;
  }
}
