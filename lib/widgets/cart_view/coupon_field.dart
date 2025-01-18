import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/checkout_service.dart';

import '../../helpers/common_helper.dart';
import '../../utils/responsive.dart';
import '../common/custom_common_button.dart';

class CouponField extends StatelessWidget {
  CouponField({super.key});

  final TextEditingController _couponTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: _couponTextController,
      decoration: InputDecoration(
        hintText: asProvider.getString('Coupon Text'),
        suffixIcon: Container(
          width: screenWidth / 4 + 14,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child:
              Consumer<CheckoutService>(builder: (context, cProvider, child) {
            return CustomCommonButton(
              btText: asProvider.getString('Submit'),
              onPressed: () {
                _focusNode.unfocus();
                cProvider.getCouponDiscountAmount(
                    context, _couponTextController.text);
              },
              width: screenWidth / 4,
              height: 38,
              isLoading: cProvider.loadingCouponApply,
            );
          }),
        ),
      ),
      onFieldSubmitted: (value) {
        Provider.of<CheckoutService>(context, listen: false)
            .getCouponDiscountAmount(context, _couponTextController.text);
      },
    );
  }
}
