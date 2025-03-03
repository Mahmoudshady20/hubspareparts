import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/views/add_new_shipping_address_view.dart';
import 'package:safecart/widgets/shipping_address_list_view/shipping_address_tile.dart';
import 'package:safecart/widgets/skelletons/shipping_address_tile_skeleton.dart';

import '../helpers/common_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';

class ShippingAddressListView extends StatelessWidget {
  static const routeName = 'shipping_address_list_view';
  ShippingAddressListView({Key? key}) : super(key: key);
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ShippingAddressService>(context, listen: false)
        .fetchShippingAddress(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
            color: cc.primaryColor,
            alignment: Alignment.topCenter,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 1,
                leadingWidth: 60,
                toolbarHeight: 60,
                foregroundColor: cc.greyHint,
                backgroundColor: Colors.transparent,
                expandedHeight: screenHeight / 3.7,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: screenHeight / 3.7,
                    width: double.infinity,
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.shipping_address,
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
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FutureBuilder(
                            future: Provider.of<ShippingAddressService>(context,
                                    listen: false)
                                .fetchShippingAddress(context),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  children: Iterable.generate(3)
                                      .map((e) =>
                                          const ShippingAddressTileSkeleton())
                                      .toList(),
                                );
                              }

                              return Consumer<ShippingAddressService>(
                                  builder: (context, saProvider, child) {
                                return saProvider.shippingAddressList != null &&
                                        saProvider
                                            .shippingAddressList!.isNotEmpty
                                    ? Column(
                                        children:
                                            saProvider.shippingAddressList!
                                                .toList()
                                                .map((e) => ShippingAddressTile(
                                                      id: e.id ?? '',
                                                      title:
                                                          e.shippingAddressName ??
                                                              '',
                                                      address: e.address ?? '',
                                                    ))
                                                .toList(),
                                      )
                                    : SizedBox(
                                        height: screenHeight / 2,
                                        child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .no_address_found),
                                        ),
                                      );
                              });
                            })),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 46,
          child: CustomCommonButton(
            btText: AppLocalizations.of(context)!.add_new_Address,
            isLoading: false,
            onPressed: () {
              FocusScope.of(context).unfocus();
              Provider.of<ShippingAddressService>(context, listen: false)
                  .setCountry(null);
              Provider.of<ShippingAddressService>(context, listen: false)
                  .setState(null);
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, anotherAnimation) {
                  return AddNewShippingAddressView();
                },
              ));
            },
          ),
        ),
      ),
    );
  }
}
