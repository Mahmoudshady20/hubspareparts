import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../helpers/common_helper.dart';

class ShippingAddressTile extends StatelessWidget {
  final dynamic id;
  final dynamic title;
  final dynamic address;

  const ShippingAddressTile({this.id, this.title, this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cc.whiteGrey,
          border: Border.all(color: cc.lightPrimary10, width: .5)),
      child: Stack(children: [
        ListTile(
          // contentPadding: const EdgeInsets.all(0),
          // minVerticalPadding: -3,
          // dense: false,
          horizontalTitleGap: 8,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // width: 80,
                child: SvgPicture.asset('assets/icons/shipping_address.svg',
                    color: cc.greyParagraph),
              ),
            ],
          ),
          title: Text(
            title,
            style: TextStyle(color: cc.blackColor),
          ),
          subtitle: Text(
            address,
            style: TextStyle(color: cc.greyParagraph),
          ),
          trailing: GestureDetector(
              onTap: (() {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title:
                              Text(AppLocalizations.of(context)!.are_you_sure),
                          content: Text(AppLocalizations.of(context)!
                              .this_address_will_be_deleted_permanently),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    cc.primaryColor),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.no),
                            ),
                            Consumer<ShippingAddressService>(
                                builder: (context, saProvider, child) {
                              return TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          cc.primaryColor),
                                ),
                                onPressed: saProvider.loadingDeleteAddress
                                    ? () {}
                                    : (() async {
                                        // Provider.of<ShippingAddressesService>(
                                        //         context,
                                        //         listen: false)
                                        //     .setAlertBoxLoading(true);
                                        await saProvider.deleteSingleAddress(
                                            context, id);

                                        // Provider.of<ShippingAddressesService>(
                                        //         context,
                                        //         listen: false)
                                        //     .setAlertBoxLoading(false);
                                        Navigator.pop(context);
                                      }),
                                child: saProvider.loadingDeleteAddress
                                    ? SizedBox(
                                        height: 20,
                                        width: 60,
                                        child:
                                            FittedBox(child: CustomPreloader()))
                                    : Text(
                                        AppLocalizations.of(context)!.yes,
                                        style: TextStyle(color: cc.pink),
                                      ),
                              );
                            }),
                            // FlatButton(
                            //     onPressed:
                            //         Provider.of<ShippingAddressesService>(
                            //                     context)
                            //                 .alertBoxLoading
                            //             ? () {}
                            //             : (() async {
                            //                 Provider.of<ShippingAddressesService>(
                            //                         context,
                            //                         listen: false)
                            //                     .setAlertBoxLoading(true);
                            //                 await Provider.of<
                            //                             ShippingAddressesService>(
                            //                         context,
                            //                         listen: false)
                            //                     .deleteSingleAddress(id);

                            //                 Provider.of<ShippingAddressesService>(
                            //                         context,
                            //                         listen: false)
                            //                     .setAlertBoxLoading(false);
                            //                 Navigator.pop(context);
                            //               }),
                            //     child: Provider.of<ShippingAddressesService>(
                            //                 context)
                            //             .alertBoxLoading
                            //         ? SizedBox(
                            //             height: 20,
                            //             width: 40,
                            //             child: loadingProgressBar(size: 15))
                            //         : Text(
                            //             'Yes',
                            //             style: TextStyle(color: cc.pink),
                            //           ))
                          ],
                        ));
              }),
              child: SvgPicture.asset(
                'assets/icons/trash.svg',
                height: 22,
                width: 22,
                color: cc.red,
              )),
        ),
      ]),
    );
  }
}
