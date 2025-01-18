import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/payment/pagali_payment.dart';
import 'package:safecart/services/payment/toyyibpay_payment.dart';

import '../../services/payment/billplz_payment.dart';
import '../../services/payment/cinetpay_payment.dart';
import '../../services/payment/squareup_payment.dart';
import '../../services/payment/zitopay_payment.dart';
import '../../services/payment/mollie_payment.dart';
import '../../widgets/common/custom_common_button.dart';
import '../../helpers/common_helper.dart';
import '../payment/authorize_net_payment.dart';
import '../payment/cash_free_payment.dart';
import '../payment/flutter_wave_payment.dart';
import '../payment/instamojo_payment.dart';
import '../payment/mercado_pago_payment.dart';
import '../payment/mid_trans_payment.dart';
import '../payment/payfast_payment.dart';
import '../payment/paypal_payment.dart';
import '../payment/paystack_payment.dart';
import '../payment/paytabs_payment.dart';
import '../payment/paytm_payment.dart';
import '../payment/razorpay_payment.dart';
import '../payment/stripe_payment.dart';
import '../payment_gateway_service.dart';
import 'checkout_service.dart';

Future startPayment(
    BuildContext context, CheckoutService csProvider, pickedImage,
    {zUsername, authNetCard, authNetED, authcCode}) async {
  print('starting payment');
  final selectedGateaway =
      Provider.of<PaymentGatewayService>(context, listen: false)
          .selectedGateway;
  if (selectedGateaway == null) {
    snackBar(context, 'Select a payment Gateway', backgroundColor: cc.red);
    return;
  }
  final cProvider = Provider.of<CheckoutService>(context, listen: false);
  cProvider.clearSelectedImage();
  if (selectedGateaway.name.contains('bank_transfer') ||
      selectedGateaway.name.contains('manual_payment')) {
    bool continued = false;
    print(cProvider.pickedImage);
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
              onTap: (() {
                cProvider.imageSelector(context);
              }),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: cc.primaryColor,
                        )),
                    child: cProvider.pickedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image_outlined),
                              Text(asProvider
                                  .getString('Select an image from gallery')),
                            ],
                          )
                        : Image.file(cProvider.pickedImage!),
                  )),
            ),
            actions: [
              CustomCommonButton(
                btText: asProvider.getString('Continue'),
                isLoading: false,
                onPressed: Provider.of<CheckoutService>(context).pickedImage ==
                        null
                    ? () {
                        showToast(
                            asProvider.getString('Take an image to proceed'),
                            Colors.red);
                      }
                    : () {
                        continued = true;
                        Navigator.of(context).pop();
                      },
              )
            ],
          );
        });
    if (continued == true) {
      await csProvider.placeOrder(context);
      // Navigator.of(context).pop();
      return;
    }
    csProvider.pickedImage = null;
    return;
  }

  await csProvider.placeOrder(context);
  if (csProvider.orderId == null) {
    return;
  }
  if (selectedGateaway.name == 'cash_on_delivery' ||
      selectedGateaway.name == 'manual_payment' ||
      selectedGateaway.name == 'bank_transfer') {
    await showPaymentSuccessDialogue(context);
    // Navigator.of(context).pop();
    return;
  }
  print('no confirming');
  print(selectedGateaway.name);
  if (selectedGateaway.name.toLowerCase().contains('marcadopago')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MercadopagoPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('paytm')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaytmPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('paypal')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalPayment(
          onFinish: (number) async {
            // await Provider.of<ConfirmPaymentService>(context, listen: false)
            //     .confirmPayment(context);
          },
        ),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('stripe')) {
    print('here');
    await StripePayment().makePayment(context);
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('razorpay')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => RazorpayPayment(),
      ),
    );

    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('paystack')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaystackPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('flutterwave')) {
    FlutterWavePayment().makePayment(context);
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('cashfree')) {
    await CashFreePayment()
        .doPayment(context)
        .onError((error, stackTrace) => null);
    return;
  }

  // }
  if (selectedGateaway.name.toLowerCase().contains('payfast')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PayfastPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('zitopay')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ZitopayPayment(zUsername),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('paytabs')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaytabsPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('pagali')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PagaliPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('squareup')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SquareUpPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('cinetpay')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CinetPayPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('billplz')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => BillplzPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('toyyibpay')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ToyyibPayPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('authorizenet')) {
    await AuthrizeNetPay.authorizeNetPay(
        context, authNetCard, authNetED, authcCode);
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('midtrans')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MidtransPayment(),
      ),
    );

    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('instamojo')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => InstamojoPayment(),
      ),
    );
    return;
  }
  if (selectedGateaway.name.toLowerCase().contains('mollie')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MolliePayment(),
      ),
    );
    return;
  }
}
