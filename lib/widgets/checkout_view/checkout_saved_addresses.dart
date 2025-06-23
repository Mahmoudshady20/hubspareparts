import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/auth_service/sign_in_service.dart';
import '../../services/profile_info_service.dart';
import '../../views/sign_in_view.dart';
import '../common/custom_outlined_button.dart';
import 'shipping_address_chip.dart';

class CheckoutSavedAddresses extends StatelessWidget {
  const CheckoutSavedAddresses({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileInfoService>(builder: (context, piProvider, child) {
      return SizedBox(
        height: 56,
        child: piProvider.profileInfo == null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomOutlinedButton(
                    onPressed: (() {
                      Provider.of<SignInService>(context, listen: false)
                          .setObscurePassword(true);
                      Navigator.of(context).pushNamed(SignInView.routeName);
                    }),
                    btText: AppLocalizations.of(context)!.sign_In,
                    isLoading: false),
              )
            : Consumer<ShippingAddressService>(
                builder: (context, saProvider, child) {
                  return saProvider.shippingAddressList == null
                      ? CustomPreloader()
                      : saProvider.shippingAddressList!.isEmpty
                          ? CustomOutlinedButton(
                              onPressed: () {},
                              btText:
                                  AppLocalizations.of(context)!.add_new_Address,
                              isLoading: false)
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<ShippingAddressService>(context,
                                            listen: false)
                                        .setSelectedShippingAddress(
                                            saProvider
                                                .shippingAddressList![index],
                                            context);
                                  },
                                  child: ShippingAddressChip(
                                    title: saProvider
                                            .shippingAddressList![index]
                                            .shippingAddressName ??
                                        "",
                                    isSelected: saProvider
                                            .selectedShippingAddress ==
                                        saProvider.shippingAddressList![index],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  EmptySpaceHelper.emptywidth(10),
                              itemCount:
                                  saProvider.shippingAddressList!.length);
                },
              ),
      );
    });
  }
}
