import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/utils/city_dropdown.dart';
import 'package:safecart/utils/country_dropdown.dart';
import 'package:safecart/utils/state_dropdown.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';

class AddNewShippingAddressView extends StatelessWidget {
  static const routeName = 'add_new_shipping_address_view';
  AddNewShippingAddressView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  tryAddingNewAddress(BuildContext context) {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    debugPrint(saProvider.selectedCountry.toString());
    if (saProvider.selectedCountry == null) {
      showToast(
          AppLocalizations.of(context)!.you_have_to_select_a_country, cc.red);
      return;
    }
    if (saProvider.selectedState == null) {
      showToast(
          AppLocalizations.of(context)!.you_have_to_select_a_state, cc.red);
      return;
    }

    saProvider.addShippingAddress(
      context,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      city: _cityController.text,
      zipcode: _zipcodeController.text,
      address: _addressController.text,
    );
  }

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
                expandedHeight: screenHeight / 3.7,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: screenHeight / 3.7,
                    width: double.infinity,
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.add_new_address,
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
                            Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FieldTitle(
                                            AppLocalizations.of(context)!.title),
                                        TextFormField(
                                          style: getFieldStyle(context),
                                          controller: _nameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)!.enter_a_title,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.length < 3) {
                                              return AppLocalizations.of(context)!.enter_a_valid_name;
                                            }
                                            return null;
                                          },
                                        ),
                                        FieldTitle(
                                            AppLocalizations.of(context)!.email),
                                        TextFormField(
                                          controller: _emailController,
                                          style: getFieldStyle(context),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)!.enter_an_email,
                                          ),
                                          validator: (value) {
                                            if (!EmailValidator.validate(
                                                value ?? '')) {
                                              return AppLocalizations.of(context)!.enter_a_valid_email_address;
                                            }
                                            return null;
                                          },
                                        ),
                                        FieldTitle(
                                            AppLocalizations.of(context)!.phone),
                                        TextFormField(
                                          controller: _phoneController,
                                          style: getFieldStyle(context),
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)!.enter_a_phone_number,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(context)!.enter_a_phone_number;
                                            }
                                            return null;
                                          },
                                        ),
                                        Consumer<ShippingAddressService>(
                                            builder:
                                                (context, saProvider, child) {
                                          return CountryDropdown(
                                            selectedValue: saProvider
                                                .selectedCountry?.name,
                                            onChanged: (country) {
                                              debugPrint(country.toString());
                                              saProvider.setCountry(country);
                                            },
                                          );
                                        }),
                                        Consumer<ShippingAddressService>(
                                            builder:
                                                (context, saProvider, child) {
                                          return StateDropdown(
                                            countryId:
                                                saProvider.selectedCountry?.id,
                                            selectedValue:
                                                saProvider.selectedState?.name,
                                            onChanged: (state) {
                                              debugPrint(state.toString());
                                              saProvider.setState(state);
                                            },
                                          );
                                        }),
                                        Consumer<ShippingAddressService>(
                                            builder:
                                                (context, saProvider, child) {
                                          return CityDropdown(
                                            selectedValue:
                                                saProvider.selectedCity?.name,
                                            stateId:
                                                saProvider.selectedState?.id,
                                            onChanged: (city) {
                                              saProvider.setTownCity(city);
                                            },
                                          );
                                        }),
                                        FieldTitle(
                                            AppLocalizations.of(context)!.zipcode),
                                        TextFormField(
                                          controller: _zipcodeController,
                                          style: getFieldStyle(context),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)!.enter_zipcode,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(context)!.enter_zipcode;
                                            }
                                            if (value.trim().length <= 3) {
                                              return AppLocalizations.of(context)!.enter_your_zipcode;
                                            }
                                            return null;
                                          },
                                        ),
                                        FieldTitle(
                                            AppLocalizations.of(context)!.address),
                                        TextFormField(
                                          controller: _addressController,
                                          style: getFieldStyle(context),
                                          textInputAction: TextInputAction.done,
                                          maxLines: 6,
                                          minLines: 3,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)!.enter_address,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(context)!.enter_address;
                                            }
                                            if (value.trim().length <= 2) {
                                              return AppLocalizations.of(context)!.enter_a_valid_address;
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(25),
                                        Consumer<ShippingAddressService>(
                                            builder:
                                                (context, saProvider, child) {
                                          return CustomCommonButton(
                                              btText: AppLocalizations.of(context)!.add_address,
                                              isLoading:
                                                  saProvider.loadingNewAddress,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                tryAddingNewAddress(context);
                                              });
                                        })
                                      ]),
                                ))
                          ],
                        ),
                      ),
                    ),
                    EmptySpaceHelper.emptyHight(50),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle getFieldStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(color: cc.greyHint);
  }
}
