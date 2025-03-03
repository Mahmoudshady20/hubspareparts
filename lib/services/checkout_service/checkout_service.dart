// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/models/vendor_details_list_model.dart';
import 'package:safecart/services/cart_data_service.dart';
import 'package:safecart/services/checkout_service/calculate_tax_service.dart';
import 'package:safecart/services/payment/paytm_payment.dart';
import 'package:safecart/services/payment_gateway_service.dart';

import '../../../helpers/common_helper.dart';
import 'shipping_address_service.dart';

class CheckoutService with ChangeNotifier {
  bool differentSL = false;
  File? pickedImage;
  double taxPercent = 0;
  double couponDiscount = 0;
  double totalShippingCost = 0;
  bool loadingCouponApply = false;
  bool loadingVendorDetailsList = false;
  bool loadingPlaceOrder = false;
  List shippingCost = [];
  List vendorShippingId = [];
  List vendorShippingCost = [];
  Map updatePaymentBody = {};
  dynamic orderId;
  double totalOrderAmount = 0;
  String? couponText;
  Map<String, ATVendor> advanceTaxData = {};
  CartDataService? cartDataService;

  VendorDetailListModel? vendorDetailsList;

  setCartDataService(value) {
    cartDataService = value;
  }

  setATData(map) {
    advanceTaxData = {};
    map.keys.toList().forEach((key) {
      advanceTaxData.putIfAbsent(key, () => map[key]);
    });
    notifyListeners();
  }

  get totalCalculation {
    if (rtlProvider.taxSystem == "advance_tax_system") {
      num subTotal = 0;
      advanceTaxData.values.toList().forEach((element) {
        subTotal += element.subTotal + element.taxAmount;
      });
      subTotal -= couponDiscount;
      return (subTotal) + totalShippingCost;
    }
    var subTotal = cartDataService!.calculateSubtotal().toDouble();
    return (subTotal - couponDiscount) +
        ((subTotal - couponDiscount) * taxPercent) +
        totalShippingCost;
  }

  get totalTax {
    if (rtlProvider.taxSystem == "advance_tax_system") {
      num taxTotal = 0;
      advanceTaxData.values.toList().forEach((element) {
        taxTotal += element.taxAmount;
      });
      return (taxTotal);
    }
    var subTotal = cartDataService!.calculateSubtotal().toDouble();
    return taxPercent * (subTotal - couponDiscount);
  }

  get totalItemCost {
    if (rtlProvider.taxSystem == "advance_tax_system") {
      num subTotal = 0;
      advanceTaxData.values.toList().forEach((element) {
        subTotal += element.subTotal;
      });
      return (subTotal);
    }
    var subTotal = cartDataService!.calculateSubtotal().toDouble();
    return subTotal;
  }

  toggleDifferentSL({value}) {
    if (value == differentSL) {
      return;
    }
    differentSL = value ?? !differentSL;
    notifyListeners();
  }

  clearSelectedImage() {
    pickedImage = null;
    notifyListeners();
  }

  setTaxPercentage(value) {
    if (value == taxPercent) {
      return;
    }
    taxPercent = value;
    notifyListeners();
  }

  setLoadingCouponApply(value) {
    loadingCouponApply = value;
    notifyListeners();
  }

  setLoadingVendorDetailsList(value) {
    loadingVendorDetailsList = value;
    notifyListeners();
  }

  setLoadingPlaceOrder(value) {
    loadingPlaceOrder = value;
    notifyListeners();
  }

  isShippingMethodSelected(vendorId, shippingMethods) {
    var selectedShippingMethod;
    debugPrint(shippingMethods.map((elem) => elem.id).toString());
    debugPrint(vendorId.toString());
    debugPrint(vendorShippingId.toString());
    shippingMethods.forEach((element) {
      for (var e in vendorShippingId) {
        if (e.containsKey(vendorId) && e[vendorId] == element.id.toString()) {
          selectedShippingMethod = element;
          break;
        }
      }
    });
    return selectedShippingMethod;
  }

  changeVendorShippingMethod(vendorId, shippingMethods, shippingMethodName) {
    print(vendorId);
    debugPrint("$vendorId is vendor id........................".toString());
    if (vendorId == 'admin') {
      print('returning early because its admin');
      var shippingMethod = vendorDetailsList!.defaultVendor.shippingMethods
          .firstWhere((element) => element.title == shippingMethodName);
      for (var element in vendorShippingCost) {
        if (element.containsKey(vendorId.toString())) {
          (element as Map)
              .update(vendorId.toString(), (value) => shippingMethod.cost);
        }
      }
      for (var element in vendorShippingId) {
        if (element.containsKey(vendorId.toString())) {
          (element as Map).update(
              vendorId.toString(), (value) => shippingMethod.id.toString());
        }
      }
      calculateTotalShippingCost();
      return;
    }
    var shippingMethod = vendorDetailsList!.vendors
        .firstWhere((element) => element.id.toString() == vendorId.toString())
        .shippingMethod!
        .firstWhere((element) => element.title == shippingMethodName);
    print(shippingMethod.title);

    bool priceUpdated = false;
    for (var element in vendorShippingCost) {
      if (element.containsKey(vendorId.toString())) {
        priceUpdated = true;
        (element as Map)
            .update(vendorId.toString(), (value) => shippingMethod.cost);
      }
    }
    if (!priceUpdated) {
      try {
        vendorShippingCost.add({vendorId.toString(): shippingMethod.cost});
      } catch (e) {}
    }
    for (var element in vendorShippingId) {
      if (element.containsKey(vendorId.toString())) {
        (element as Map).update(
            vendorId.toString(), (value) => shippingMethod.id.toString());
      }
    }
    calculateTotalShippingCost();
    print(vendorShippingCost);
  }

  calculateTotalShippingCost() {
    double totalCost = 0;
    for (var element in vendorShippingCost) {
      element.values.toList().forEach((cost) {
        totalCost += cost;
      });
    }
    totalShippingCost = totalCost;
    notifyListeners();
  }

  Future<void> imageSelector(
    BuildContext context,
  ) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],
        allowMultiple: false,
      );
      pickedImage = File(file!.paths.first!);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> fetchVendorDetails(BuildContext context,
      {bool loadShippingZone = false, bool fetchWithoutNew = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      vendorShippingCost = [];
      vendorShippingId = [];
      totalShippingCost = 0;
      shippingCost = [];
      vendorDetailsList = null;
      orderId = null;
      couponText = '';

      setLoadingVendorDetailsList(true);
      final vendorsList =
          Provider.of<CartDataService>(context, listen: false).vendorIds;
      final hasDefaultVendor = vendorsList.contains('admin');
      if (hasDefaultVendor) {
        vendorsList.remove('admin');
      }
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('$baseApi/checkout-contents');
      final body = json.encode(
          {"vendor_ids": vendorsList, "default_vendor": hasDefaultVendor});
      print(body);
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['default_vendor']);
        vendorDetailsList = VendorDetailListModel.fromJson(data);
        for (var vendor in vendorDetailsList!.vendors) {
          bool addedShipping = false;
          for (var sm in vendor.shippingMethod!) {
            if (sm.isDefault == true) {
              addedShipping = true;
              vendorShippingId.add({vendor.id.toString(): sm.id.toString()});
              vendorShippingCost.add({vendor.id.toString(): sm.cost});
            }
          }
          if (addedShipping == false &&
              vendor.shippingMethod?.isNotEmpty == true) {
            vendorShippingId.add({
              vendor.id.toString(): vendor.shippingMethod![0].id.toString()
            });
            vendorShippingCost
                .add({vendor.id.toString(): vendor.shippingMethod![0].cost});
          }
        }
        if (hasDefaultVendor) {
          for (var sm in vendorDetailsList!.defaultVendor.shippingMethods) {
            if (sm.isDefault == true) {
              vendorShippingCost.add({'admin': sm.cost});
              vendorShippingId.add({'admin': sm.id.toString()});
            }
          }
        }
        print(vendorShippingId);
        print(vendorShippingCost);

        calculateTotalShippingCost();
        setLoadingVendorDetailsList(false);
        return;
      } else {
        print(response.body);
        setLoadingVendorDetailsList(false);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      setLoadingVendorDetailsList(false);
    } catch (err) {
      showToast(asProvider.getString(err.toString()), cc.red);
      setLoadingVendorDetailsList(false);
      print(err);
      rethrow;
    }
  }

  Future<dynamic> getCouponDiscountAmount(
      BuildContext context, couponText) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    if (couponText == null || couponText == '') {
      showToast(AppLocalizations.of(context)!.enter_a_valid_coupon, cc.red);
      return;
    }
    setLoadingCouponApply(true);
    try {
      final cdProvider = Provider.of<CartDataService>(context, listen: false);
      final productIds = cdProvider.cartItemIds();
      final subtotal = cdProvider.calculateSubtotal().toDouble();
      print(productIds);
      print(subtotal);
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$baseApi/apply-coupon'));
      request.body = json.encode({
        "product_ids": productIds,
        "coupon": couponText,
        "subTotal": subtotal
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);
        if (data['type'] == 'success') {
          couponDiscount = data['coupon_amount'] is String
              ? double.parse(data['coupon_amount'])
              : data['coupon_amount'].toDouble();
          this.couponText = couponText;
          showToast(data["msg"], cc.green);
        } else {
          showToast(data["msg"], cc.red);
        }

        setLoadingCouponApply(false);
        return;
      } else {
        setLoadingCouponApply(false);
        print(await response.stream.bytesToString());
      }
    } on TimeoutException {
      setLoadingCouponApply(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoadingCouponApply(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
      print(err);
      rethrow;
    }
  }

  Future<dynamic> placeOrder(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingPlaceOrder(true);
    try {
      final cdProvider = Provider.of<CartDataService>(context, listen: false);
      final productIds = cdProvider.cartItemIds();
      final subtotal = cdProvider.calculateSubtotal().toDouble();
      final paymentGateway =
          Provider.of<PaymentGatewayService>(context, listen: false);
      final shippingAddress =
          Provider.of<ShippingAddressService>(context, listen: false);
      final calculateTax =
          Provider.of<CalculateTaxService>(context, listen: false);
      final cartData = Provider.of<CartDataService>(context, listen: false);

      if (calculateTax.selectedCountry == null ||
          calculateTax.selectedState == null) {
        showToast(
            AppLocalizations.of(context)!.please_enter_all_the_information,
            cc.red);
        setLoadingPlaceOrder(false);
        return;
      }

      Map shippingCost = {};
      for (var element in vendorShippingId) {
        shippingCost.putIfAbsent(
            element.keys.toList().first, () => element.values.toList().first);
      }
      var headers = {
        'Authorization': 'Bearer $getToken',
      };

      debugPrint(jsonEncode(shippingCost).toString());
      debugPrint(({'cart_items': jsonEncode(cartData.cartList)}).toString());

      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/checkout'));
      request.fields.addAll({
        'full_name': shippingAddress.title ?? '',
        'note': shippingAddress.orderNote ?? '',
        'phone': shippingAddress.phone ?? '',
        'cart_items': jsonEncode(cartData.cartListWithoutAdmin),
        'selected_payment_gateway':
            paymentGateway.selectedGateway?.name ?? 'cash',
        'country_id': calculateTax.selectedCountry?.id.toString() ?? "",
        'state_id': calculateTax.selectedState?.id.toString() ?? "",
        'zip_code': shippingAddress.zipcode ?? '',
        'email': shippingAddress.email ?? '',
        'shipping_cost': jsonEncode(shippingCost),
        'address': shippingAddress.streetAddress ?? '',
        'agree': 'on',
        'coupon': couponText ?? ''
      });

      if (calculateTax.selectedCity?.id != null) {
        request.fields.putIfAbsent(
          "city",
          () => calculateTax.selectedCity?.id.toString() ?? '',
        );
      }
      dev.log(jsonEncode(cartData.cartListWithoutAdmin));
      debugPrint(jsonEncode({
        'cart_items': jsonEncode(cartData.cartList),
      }));
      dev.log(jsonEncode({
        'cart_items': jsonEncode(cartData.cartList),
        'name': shippingAddress.title,
        'message': shippingAddress.orderNote,
        'phone': shippingAddress.phone,
        'selected_payment_gateway':
            paymentGateway.selectedGateway?.name ?? 'cash',
        'country_id': calculateTax.selectedCountry?.id.toString() ?? "",
        'state_id': calculateTax.selectedState?.id.toString() ?? "",
        'zip_code': shippingAddress.zipcode,
        'email': shippingAddress.email,
        'shipping_cost': jsonEncode(shippingCost),
        'address': shippingAddress.streetAddress,
        'agree': 'on',
      }));

      if (pickedImage != null &&
          paymentGateway.selectedGateway?.name == 'manual_payment') {
        print(pickedImage?.path);
        snackBar(
            context,
            AppLocalizations.of(context)!
                .uploading_image_this_might_take_some_time,
            backgroundColor: cc.green,
            duration: const Duration(seconds: 1000));
        request.files.add(await http.MultipartFile.fromPath(
            'transaction_attachment', pickedImage!.path));
      }
      if (pickedImage == null &&
          paymentGateway.selectedGateway?.name == 'manual_payment') {
        showToast(AppLocalizations.of(context)!.please_provide_payment_document,
            cc.red);
        return;
      }
      request.headers.addAll(headers);
      Timer scheduleTimeout = Timer(const Duration(seconds: 10), () {
        showToast(AppLocalizations.of(context)!.server_connection_slow,
            cc.blackColor);
      });
      http.StreamedResponse response = await request.send();
      scheduleTimeout.cancel();

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final resData = await response.stream.bytesToString();
      debugPrint(resData.toString());
      if (paymentGateway.selectedGateway?.name == "paytm" &&
          response.statusCode == 200) {
        cartData.emptyCart();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaytmPayment(
            html: resData,
          ),
        ));
        setLoadingPlaceOrder(false);
        return;
      }
      final data = jsonDecode(resData);
      if (response.statusCode == 200 && data['success'] == true) {
        print(data);
        cartData.emptyCart();
        final hashTwo = data['hash-two'];
        final orderSecretKey = data['secrete_key'];
        updatePaymentBody = data;
        updatePaymentBody.remove('hash-two');
        updatePaymentBody.remove("secrete_key");
        updatePaymentBody['status'] = 'complete';
        updatePaymentBody['success'] = 'complete';
        updatePaymentBody['type'] = 'success';
        updatePaymentBody['order_secret_id'] = orderSecretKey;
        updatePaymentBody['hash_two'] = hashTwo;
        orderId = data['order_id'];
        totalOrderAmount = data['total_amount'] is String
            ? double.parse(data['total_amount'])
            : data['total_amount'].toDouble();

        setLoadingPlaceOrder(false);
        return;
      } else {
        showToast(asProvider.getString('$data'), cc.red);
        setLoadingPlaceOrder(false);
        print(data);
      }
    } on TimeoutException {
      setLoadingPlaceOrder(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoadingPlaceOrder(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
      print(err);
      rethrow;
    }
  }

  Future<dynamic> updatePaymentStatus(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    try {
      final cdProvider = Provider.of<CartDataService>(context, listen: false);
      final productIds = cdProvider.cartItemIds();
      final subtotal = cdProvider.calculateSubtotal().toDouble();
      final paymentGateway =
          Provider.of<PaymentGatewayService>(context, listen: false);
      final shippingAddress =
          Provider.of<ShippingAddressService>(context, listen: false);
      final calculateTax =
          Provider.of<CalculateTaxService>(context, listen: false);
      final cartData = Provider.of<CartDataService>(context, listen: false);

      Map shippingCost = {};
      for (var element in vendorShippingId) {
        shippingCost.putIfAbsent(
            element.keys.toList().first, () => element.values.toList().first);
      }
      var headers = {
        'app-secret-key': paymentStatusUpdateKey,
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse('$baseApi/update-payment'));
      request.body = json.encode(updatePaymentBody);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      debugPrint(json.encode(updatePaymentBody));
      dev.log(json.encode(updatePaymentBody));
      if (response.statusCode == 200 && data['data']?['success'] == true) {
        print(data);
        showToast(AppLocalizations.of(context)!.payment_confirm_success,
            cc.primaryColor);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        return;
      } else {
        snackBar(
          context,
          AppLocalizations.of(context)!.payment_confirm_failed,
          buttonText: AppLocalizations.of(context)!.retry,
          duration: const Duration(seconds: 60),
          onTap: () async {
            await updatePaymentStatus(context);
          },
        );
        print(data);
      }
    } on TimeoutException {
      snackBar(
        context,
        AppLocalizations.of(context)!.payment_confirm_failed,
        buttonText: AppLocalizations.of(context)!.retry,
        duration: const Duration(seconds: 60),
        onTap: () async {
          await updatePaymentStatus(context);
        },
      );
    } catch (err) {
      snackBar(
        context,
        AppLocalizations.of(context)!.payment_confirm_failed,
        buttonText: AppLocalizations.of(context)!.retry,
        duration: const Duration(seconds: 60),
        onTap: () async {
          await updatePaymentStatus(context);
        },
      );
      print(err);
      rethrow;
    }
  }
}
