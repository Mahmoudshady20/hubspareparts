import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/payment_gateway_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/views/order_details_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/app_strings_service.dart';
import '../services/checkout_service/checkout_service.dart';
import '../utils/constant_colors.dart';
import '../views/home_front_view.dart';
import '../views/payment_status_view.dart';
import 'empty_space_helper.dart';

ConstantColors cc = ConstantColors();

const String baseApi = 'https://safecart.bytesed.com/api/v1';
String _globalToken = '';
String imageLoadingAppIcon =
    'https://i.postimg.cc/85gKpbT5/shopcartappicon.png';
String imageLoadingProductCard =
    'https://i.postimg.cc/25C8rXcp/product-card-loader-image.png';
String avatarImage = 'https://i.postimg.cc/nzF847n2/avatar.png';

String paymentGatewayKey = "b8f4a0ba4537ad6c3ee41ec0a43549d1";
String paymentStatusUpdateKey = "fdg86dghs54gh6gf5j7hdfg4hbf32gh1dfgh3d13";

late AppStringService asProvider;
late RTLService rtlProvider;
late SharedPreferences sPref;

String get getToken {
  return _globalToken;
}

setToken(token) {
  _globalToken = token;
}

initiateAppStringProvider(BuildContext context) async {
  asProvider = Provider.of<AppStringService>(context, listen: false);
  rtlProvider = Provider.of<RTLService>(context, listen: false);
  sPref = await SharedPreferences.getInstance();
}

snackBar(BuildContext context, String content,
    {String? buttonText,
    void Function()? onTap,
    Color? backgroundColor,
    Duration? duration}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

      // width: screenWidth - 100,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5),
      backgroundColor: backgroundColor ?? cc.primaryColor,
      duration: duration ?? const Duration(seconds: 2),
      content: Row(
        children: [
          Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (buttonText != null)
            GestureDetector(
              onTap: onTap,
              child: Text(buttonText),
            )
        ],
      )));
}

void showToast(String msg, Color? color, {int timeInSecForIosWeb = 1}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: asProvider.getString(msg),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<bool> checkConnection(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (ConnectivityResult.none == connectivityResult) {
    showToast(
        AppLocalizations.of(context)!.please_turn_on_your_internet_connection,
        cc.blackColor);
    return false;
  } else {
    return true;
  }
}

paymentFailAlert(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(asProvider.getString('Are you sure?')),
          content: Text(asProvider
              .getString('Your payment process will get terminated.')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PaymentStatusView(true)),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: cc.primaryColor),
              ),
            )
          ],
        );
      });
}

signInUpFailedForDeletedAccount(
  BuildContext context,
  String title,
  String message,
) async {
  await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(asProvider.getString(title)),
          content: Text(asProvider.getString(message)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                asProvider.getString('Close'),
                style: TextStyle(color: cc.primaryColor),
              ),
            )
          ],
        );
      });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

errorWidget() {
  return Column(
    children: [
      Image.asset('assets/images/error.png'),
      EmptySpaceHelper.emptyHight(15),
      Center(
        child: Text(
          asProvider.getString('Loading failed'),
          style: TextStyle(color: cc.greyParagraph),
        ),
      )
    ],
  );
}

paymentFailedDialogue(BuildContext context, descriptionText) async {
  await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(asProvider.getString('Payment failed!')),
          content: descriptionText != null ? Text(descriptionText) : null,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PaymentStatusView(true)),
                  (Route<dynamic> route) => false),
              child: Text(
                asProvider.getString('Return'),
                style: TextStyle(color: cc.primaryColor),
              ),
            )
          ],
        );
      });
}

Future showPaymentSuccessDialogue(BuildContext context) async {
  final cProvider = Provider.of<CheckoutService>(context, listen: false);
  await showDialog(
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 300,
          child: AlertDialog(
            title: Text(asProvider.getString('Order submitted!')),
            content: SizedBox(
              width: 200,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: asProvider.getString(
                      "Your order has been successful! You'll receive ordered items in 3-5 days."),
                  style: Theme.of(context).textTheme.bodySmall,
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Provider.of<PaymentGatewayService>(context,
                                  listen: false)
                              .setIsLoading(false);
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                OrderDetailsView(cProvider.orderId.toString()),
                          ));
                        },
                      text: " \n${asProvider.getString("Your order ID  is")}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Provider.of<PaymentGatewayService>(context,
                                    listen: false)
                                .setIsLoading(false);
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  OrderDetailsView(cProvider.orderId.toString(),
                                      goHome: true),
                            ));
                          },
                        text: ' #${cProvider.orderId}',
                        style: TextStyle(color: cc.primaryColor)),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  asProvider.getString('Ok'),
                  style: TextStyle(color: cc.primaryColor),
                ),
              )
            ],
          ),
        );
      }).then((value) => Navigator.of(
          context)
      .pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeFrontView()),
          (Route<dynamic> route) => false));
}
