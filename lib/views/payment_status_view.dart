import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/profile_info_service.dart';
import 'package:safecart/views/order_details_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../services/cart_data_service.dart';
import '../services/checkout_service/checkout_service.dart';
import '../utils/custom_row_button.dart';
import '../utils/responsive.dart';
import '../widgets/common/custom_common_button.dart';
import 'home_front_view.dart';

class PaymentStatusView extends StatelessWidget {
  static const routeName = 'payment_status_view';
  bool isError;
  PaymentStatusView(this.isError, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isError) {
      Provider.of<CheckoutService>(context, listen: false)
          .updatePaymentStatus(context);
    }
    final orderId =
        Provider.of<CheckoutService>(context, listen: false).orderId;
    final profileInfo = Provider.of<ProfileInfoService>(context, listen: false)
        .profileInfo
        ?.userDetails;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (!isError) {
            Provider.of<CartDataService>(context, listen: false).emptyCart();
            Navigator.of(context).pushReplacementNamed(HomeFrontView.routeName);
            return true;
          }
          Navigator.of(context).pushReplacementNamed(HomeFrontView.routeName);
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        // height: 150,
                        child: Lottie.asset(
                          isError
                              ? 'assets/animations/payment_failed.json'
                              : 'assets/animations/payment_success.json',
                          repeat: false,
                        ),
                      ),
                      const SizedBox(height: 45),
                      Text(
                        isError
                            ?AppLocalizations.of(context)!.oops
                            : AppLocalizations.of(context)!.payment_successful,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          // color: ConstantColors().titleTexts,
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: isError
                              ? asProvider.getString(
                                  "Your order has been placed, but there was an issue with your payment. Your order ID is ")
                              : AppLocalizations.of(context)!.your_order_has_been_successful_You_ll_receive_ordered_items_in_days_Your_order_ID_is,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            // if (!isError)
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = profileInfo == null
                                      ? null
                                      : () {
                                          // Provider.of<CartDataService>(context,
                                          //         listen: false)
                                          //     .emptyCart();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                OrderDetailsView(
                                                    orderId!.toString(),
                                                    goHome: true),
                                          ));
                                        },
                                text: ' #$orderId',
                                style: TextStyle(color: cc.primaryColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              profileInfo != null
                  ? CustomRowButton(
                      bt1text: asProvider.getString('Back to home'),
                      bt2text: asProvider.getString('Track your order'),
                      bt1func: () {
                        // Provider.of<CartDataService>(context, listen: false)
                        //     .emptyCart();
                        Navigator.of(context)
                            .pushReplacementNamed(HomeFrontView.routeName);
                      },
                      bt2func: () {
                        // Provider.of<CartDataService>(context, listen: false)
                        //     .emptyCart();
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) => OrderDetailsView(
                              orderId!.toString(),
                              goHome: true),
                        ));
                      })
                  : CustomCommonButton(
                      btText: asProvider.getString('Back to home'),
                      isLoading: false,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(HomeFrontView.routeName);
                      },
                      width: screenWidth - 50,
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
