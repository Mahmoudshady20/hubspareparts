import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/calculate_tax_service.dart';
import 'package:safecart/utils/city_dropdown.dart';
import 'package:safecart/utils/country_dropdown.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/utils/state_dropdown.dart';

import '../../helpers/empty_space_helper.dart';
import '../../models/city_dropdown_model.dart';
import '../../models/country_model.dart';
import '../../models/state_model.dart';
import '../../services/auth_service/sign_in_service.dart';
import '../../services/checkout_service/shipping_address_service.dart';
import '../../services/profile_info_service.dart';
import '../../views/add_new_shipping_address_view.dart';
import '../../views/sign_in_view.dart';
import '../common/custom_outlined_button.dart';
import '../common/field_title.dart';
import 'shipping_address_chip.dart';

class SippingAddressCheckout extends StatelessWidget {
  SippingAddressCheckout({super.key});
  final ExpandableController _expandableController =
      ExpandableController(initialExpanded: false);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();

  setInfoFromProfile(BuildContext context) {
    final piProvider = Provider.of<ProfileInfoService>(context, listen: false)
        .profileInfo
        ?.userDetails;
    if (piProvider == null) {
      return;
    }
    _titleController.text = piProvider.name;
    _emailController.text = piProvider.email;
    _phoneController.text = piProvider.phone ?? '';
    _cityController.text = piProvider.city ?? '';
    _addressController.text = piProvider.address ?? '';
    _zipcodeController.text = piProvider.zipcode ?? '';
    var country = Country(
        id: piProvider.userCountry?.id, name: piProvider.userCountry?.name);
    var state =
        States(id: piProvider.userState?.id, name: piProvider.userState?.name);
    var city =
        City(id: piProvider.userState?.id, name: piProvider.userState?.name);
    Provider.of<CalculateTaxService>(context, listen: false)
        .setFromSA(context, country, state, city);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    saProvider.setCountry(country);
    saProvider.setState(state);
    saProvider.setTownCity(city);
    saProvider.setTitle(_titleController.text);
    saProvider.setEmail(_emailController.text);
    saProvider.setPhone(_phoneController.text);
    saProvider.setStreetAddress(_addressController.text);
    saProvider.setZipCode(_zipcodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    setInfoFromProfile(context);
    return Consumer<ShippingAddressService>(
        builder: (context, saProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.saved_Addresses,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          EmptySpaceHelper.emptyHight(10),
          Consumer<ProfileInfoService>(builder: (context, piProvider, child) {
            return SizedBox(
              height: 56,
              child: piProvider.profileInfo == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: CustomOutlinedButton(
                          onPressed: (() {
                            Provider.of<SignInService>(context, listen: false)
                                .setObscurePassword(true);
                            Navigator.of(context)
                                .pushNamed(SignInView.routeName)
                                .then((value) async {
                              Provider.of<ShippingAddressService>(context,
                                      listen: false)
                                  .fetchShippingAddress(context);
                              setInfoFromProfile(context);
                            });
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
                                    onPressed: () {
                                      Provider.of<ShippingAddressService>(
                                              context,
                                              listen: false)
                                          .setCountry(null);
                                      Provider.of<ShippingAddressService>(
                                              context,
                                              listen: false)
                                          .setState(null);
                                      Navigator.of(context)
                                          .push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            anotherAnimation) {
                                          return AddNewShippingAddressView();
                                        },
                                      ));
                                    },
                                    btText: AppLocalizations.of(context)!
                                        .add_new_Address,
                                    isLoading: false)
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    itemBuilder: (context, index) {
                                      final element = saProvider
                                          .shippingAddressList![index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (saProvider
                                                  .selectedShippingAddress !=
                                              element) {
                                            _titleController.text =
                                                element.shippingAddressName ??
                                                    "";
                                            _emailController.text =
                                                element.email;
                                            _phoneController.text =
                                                element.phone;
                                            _addressController.text =
                                                element.address ?? "";
                                            _zipcodeController.text =
                                                element.zipCode ?? "";
                                            if (!_expandableController
                                                .expanded) {
                                              _expandableController.toggle();
                                            }
                                          }
                                          Provider.of<ShippingAddressService>(
                                                  context,
                                                  listen: false)
                                              .setSelectedShippingAddress(
                                                  element, context);
                                        },
                                        child: ShippingAddressChip(
                                          title:
                                              element.shippingAddressName ?? "",
                                          isSelected: saProvider
                                                  .selectedShippingAddress ==
                                              element,
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
          }),
          EmptySpaceHelper.emptyHight(10),
          ExpandableNotifier(
            initialExpanded: false,
            child: ExpandablePanel(
              controller: _expandableController,
              collapsed: const Text(''),
              header: Row(
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.shipping_information,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              expanded: Container(
                  //Dropdown
                  margin: const EdgeInsets.only(bottom: 20, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldTitle(AppLocalizations.of(context)!.title),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.enter_a_title),
                        onChanged: (value) {
                          saProvider.setTitle(value);
                          saProvider.setSelectedShippingAddress(null, context);
                        },
                      ),
                      EmptySpaceHelper.emptyHight(10),
                      FieldTitle(AppLocalizations.of(context)!.email),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.enter_an_email),
                        onChanged: (value) {
                          saProvider.setEmail(value);
                          saProvider.setSelectedShippingAddress(null, context);
                        },
                      ),
                      EmptySpaceHelper.emptyHight(10),
                      FieldTitle(AppLocalizations.of(context)!.phone),
                      TextFormField(
                        controller: _phoneController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .enter_a_phone_number),
                        onChanged: (value) {
                          saProvider.setPhone(value);
                          saProvider.setSelectedShippingAddress(null, context);
                        },
                      ),
                      EmptySpaceHelper.emptyHight(10),
                      Consumer<ShippingAddressService>(
                          builder: (context, saProvider, child) {
                        return Consumer<CalculateTaxService>(
                            builder: (context, ctProvider, child) {
                          return CountryDropdown(
                            onChanged: (value) {
                              saProvider.setSelectedShippingAddress(
                                  null, context);
                              saProvider.setCountry(value);
                              ctProvider.setSelectedCountry(context, value);
                            },
                            selectedValue:
                                saProvider.selectedShippingAddress != null
                                    ? saProvider
                                        .selectedShippingAddress?.country?.name
                                    : ctProvider.selectedCountry?.name,
                          );
                        });
                      }),
                      Consumer<ShippingAddressService>(
                          builder: (context, saProvider, child) {
                        return Consumer<CalculateTaxService>(
                            builder: (context, ctProvider, child) {
                          return StateDropdown(
                            countryId: ctProvider.selectedCountry?.id,
                            onChanged: (value) {
                              saProvider.setSelectedShippingAddress(
                                  null, context);
                              saProvider.setState(value);
                              ctProvider.setSelectedState(
                                context,
                                value,
                              );
                            },
                            selectedValue:
                                saProvider.selectedShippingAddress != null
                                    ? saProvider
                                        .selectedShippingAddress?.state?.name
                                    : ctProvider.selectedState?.name,
                          );
                        });
                      }),
                      Consumer<ShippingAddressService>(
                          builder: (context, saProvider, child) {
                        return Consumer<CalculateTaxService>(
                            builder: (context, ctProvider, child) {
                          return CityDropdown(
                            stateId: ctProvider.selectedState?.id,
                            onChanged: (value) {
                              saProvider.setSelectedShippingAddress(
                                  null, context);
                              saProvider.setTownCity(value);
                              ctProvider.setSelectedCity(
                                context,
                                value,
                              );
                            },
                            selectedValue: saProvider.selectedShippingAddress !=
                                    null
                                ? saProvider.selectedShippingAddress?.city?.name
                                : ctProvider.selectedCity?.name,
                          );
                        });
                      }),
                      FieldTitle(AppLocalizations.of(context)!.address),
                      TextFormField(
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.enter_an_address),
                        onChanged: (value) {
                          saProvider.setStreetAddress(value);
                          saProvider.setSelectedShippingAddress(null, context);
                        },
                      ),
                      EmptySpaceHelper.emptyHight(10),
                      FieldTitle(AppLocalizations.of(context)!.zipcode),
                      TextFormField(
                        controller: _zipcodeController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enter_zipcode,
                        ),
                        onChanged: (value) {
                          saProvider.setZipCode(value);
                          saProvider.setSelectedShippingAddress(null, context);
                        },
                      ),
                      EmptySpaceHelper.emptyHight(10),
                      FieldTitle(AppLocalizations.of(context)!.order_note),
                      TextFormField(
                        controller: _orderNoteController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.enter_Order_note),
                        onChanged: (value) {
                          saProvider.setOrderNote(value);
                        },
                      ),
                      EmptySpaceHelper.emptyHight(10),
                    ],
                  )),
            ),
          ),
        ],
      );
    });
  }
}
