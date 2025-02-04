import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/otp_service.dart';
import 'package:safecart/services/auth_service/reset_password_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/field_title.dart';
import 'new_password_view.dart';

class EnterOtpView extends StatelessWidget {
  static const routeName = 'enter_otp_view';
  String otp;
  bool fromRegister;
  EnterOtpView(this.otp, {this.fromRegister = false, super.key});
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
            color: cc.primaryColor,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                leadingWidth: 60,
                toolbarHeight: 60,
                foregroundColor: cc.greyHint,
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: screenHeight / 3.3,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: screenHeight / 3.7,
                    width: double.infinity,
                    // padding: EdgeInsets.only(top: screenHeight / 7),
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.verification_Code,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: cc.pureWhite, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Column(
                    children: [
                      BoxedBackButton(() {
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            // AuthAppBar(),
                            Form(
                                child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FieldTitle(asProvider.getString(
                                        'Enter your verification Code')),
                                    EmptySpaceHelper.emptyHight(20),
                                    Center(child: otpPinput(context)),
                                    EmptySpaceHelper.emptyHight(30),
                                    SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            RichText(
                                              softWrap: true,
                                              text: TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .didn_t_received,
                                                style: TextStyle(
                                                  color: cc.greyHint,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            EmptySpaceHelper.emptywidth(5),
                                            Consumer<OtpService>(
                                              builder: (context, otpProvider,
                                                  child) {
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    child!,
                                                    if (otpProvider
                                                        .loadingSendOTP)
                                                      Container(
                                                        color: Colors.white54,
                                                        height: 40,
                                                        width: 80,
                                                        child: FittedBox(
                                                            child:
                                                                CustomPreloader()),
                                                      )
                                                  ],
                                                );
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            controller!.clear();
                                                            Provider.of<OtpService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .sendOTP(
                                                                    context,
                                                                    null);
                                                          },
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .send_again,
                                                    style: TextStyle(
                                                        color: cc.primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    // CustomCommonButton('Sent verification code', onPressed: () {
                                    //   Navigator.of(context).pop();
                                    //   Navigator.of(context).push(PageRouteBuilder(
                                    //       pageBuilder: (context, animation, anotherAnimation) {
                                    //     return NewPasswordView();
                                    //   },
                                    //       // transitionDuration:
                                    //       //     const Duration(milliseconds: 300),
                                    //       transitionsBuilder:
                                    //           (context, animation, anotherAnimation, child) {
                                    //     animation = CurvedAnimation(
                                    //         curve: Curves.decelerate, parent: animation);
                                    //     return Align(
                                    //       child: FadeTransition(
                                    //         opacity: animation,
                                    //         // axisAlignment: 0.0,
                                    //         child: child,
                                    //       ),
                                    //     );
                                    //   }));
                                    // }),
                                  ]),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Pinput otpPinput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 70,
      height: 56,
      textStyle: TextStyle(
        fontSize: 17,
        color: cc.greyParagraph,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: cc.greyBorder),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: cc.primaryColor),
      borderRadius: BorderRadius.circular(8),
    );
    return Pinput(
      controller: controller,
      separatorBuilder: (index) => EmptySpaceHelper.emptywidth(15),
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      validator: (s) {
        if (s != otp &&
            s != Provider.of<OtpService>(context, listen: false).otpCode) {
          controller!.clear();
          snackBar(context, AppLocalizations.of(context)!.wrong_OTP_Code,
              backgroundColor: cc.red,
              buttonText: AppLocalizations.of(context)!.resend_code, onTap: () {
            controller!.clear();
            Provider.of<OtpService>(context, listen: false)
                .sendOTP(context, null);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          });
          return;
        }
        if (fromRegister) {
          Navigator.pop(context, true);
          return;
        }
        Navigator.pop(context, true);
        Provider.of<ResetPasswordService>(context, listen: false)
            .setObscurePasswordOne(true);
        Provider.of<ResetPasswordService>(context, listen: false)
            .setObscurePasswordTwo(true);
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
          return NewPasswordView();
        },
            // transitionDuration:
            //     const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation =
              CurvedAnimation(curve: Curves.decelerate, parent: animation);
          return Align(
            child: FadeTransition(
              opacity: animation,
              // axisAlignment: 0.0,
              child: child,
            ),
          );
        }));

        // _scaffoldKey.currentState!.showSnackBar(snackBar);

        return;
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => print(pin),
    );
  }
}
