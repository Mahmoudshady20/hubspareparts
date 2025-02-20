import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../services/app_strings_service.dart';
import 'common_helper.dart';

class LogInHelper {
  loginPopup(BuildContext context, {title, description}) async {
    final asProvider = Provider.of<AppStringService>(context, listen: false);
    bool loggedIn = false;
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
                title ?? AppLocalizations.of(context)!.login_to_checkout,
                style: TextStyle(color: cc.greytitle, fontSize: 17),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                description ??
                    AppLocalizations.of(context)!
                        .you_have_to_login_to_proceed_the_checkout,
                style: TextStyle(color: cc.greyParagraph, fontSize: 13),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  OutlinedButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.sign_In),
                    onPressed: () {
                      // Provider.of<SignInSignUpService>(context, listen: false)
                      //     .getUserData();
                      // Provider.of<SignInSignUpService>(context, listen: false)
                      //     .toggleSigninSignup(value: true);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => LoginView(),
                      //   ),
                      // ).then((value) {
                      //   if (value == true) {
                      //     loggedIn = true;
                      //   }
                      //   Navigator.pop(context);
                      // });
                      // provider.logout(context);
                      //if logged in by google then logout from it
                      // GoogleSignInService().logOutFromGoogleLogin();

                      //if logged in by facebook then logout from it
                      // FacebookLoginService().logoutFromFacebook();
                    },
                  ),
                ],
              )
            ],
          ),
        )).show();
    return loggedIn;
  }
}
