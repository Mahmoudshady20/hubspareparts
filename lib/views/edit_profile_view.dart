import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/utils/city_dropdown.dart';
import 'package:safecart/utils/country_dropdown.dart';
import 'package:safecart/utils/state_dropdown.dart';
import 'package:timezone_to_country/timezone_to_country.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/profile_info_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';
import '../widgets/profile_view.dart/profile_info.dart';

class EditProfileView extends StatelessWidget {
  static const routeName = 'edit_profile_view';
  EditProfileView({super.key});
  String? countryCode;
  setCountryCode() async {
    final timeZone = await TimeZoneToCountry.getLocalCountryCode();
    print(timeZone);
    countryCode = timeZone;

    print('currentTimeZone ${TimeZoneToCountry.getCountryCode(timeZone)} ');
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  setProfileInfo(BuildContext context) {
    final pProvider = Provider.of<ProfileInfoService>(context, listen: false);
    _nameController.text = pProvider.profileInfo!.userDetails.name;
    _emailController.text = pProvider.profileInfo!.userDetails.email;
    _phoneController.text = pProvider.profileInfo!.userDetails.phone ?? '';
    _cityController.text = pProvider.profileInfo!.userDetails.city ?? '';
    _zipcodeController.text = pProvider.profileInfo!.userDetails.zipcode ?? '';
    _addressController.text = pProvider.profileInfo!.userDetails.address ?? '';
    pProvider.setLoadingProfileUpdate(false);
  }

  tryUpdateProfile(BuildContext context) {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    final pProvider = Provider.of<ProfileInfoService>(context, listen: false);

    pProvider.updateProfileInfo(
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
    setCountryCode();
    setProfileInfo(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3 >= 325 ? screenHeight / 2.3 : 325,
            width: double.infinity,
            color: cc.primaryColor,
          ),
          CustomScrollView(slivers: [
            SliverAppBar(
              elevation: 0,
              leadingWidth: 60,
              toolbarHeight: 60,
              foregroundColor: cc.greyHint,
              backgroundColor: Colors.transparent,
              expandedHeight:
                  screenHeight / 3.3 >= 250 ? screenHeight / 3.3 : 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: ProfileInfo(editing: true),
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    BoxedBackButton(() {
                      Provider.of<ProfileInfoService>(context, listen: false)
                          .setSelectedImage(null);
                      Navigator.of(context).pop();
                    }),
                  ],
                ),
              ),
            ),
            WillPopScope(
              onWillPop: () async {
                Provider.of<ProfileInfoService>(context, listen: false)
                    .setSelectedImage(null);
                return true;
              },
              child: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 35),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Consumer<ProfileInfoService>(
                                  builder: (context, pProvider, child) {
                                return Form(
                                  key: _formKey,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FieldTitle(
                                            asProvider.getString('Name')),
                                        TextFormField(
                                          style: getFieldStyle(context),
                                          controller: _nameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: asProvider
                                                .getString('Enter your name'),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.length < 3) {
                                              return asProvider.getString(
                                                  'Enter a valid name');
                                            }
                                            return null;
                                          },
                                        ),
                                        FieldTitle(
                                            asProvider.getString('Email')),
                                        TextFormField(
                                          controller: _emailController,
                                          style: getFieldStyle(context),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: asProvider
                                                .getString('Enter your email'),
                                          ),
                                          validator: (value) {
                                            if (!EmailValidator.validate(
                                                value ?? '')) {
                                              return asProvider.getString(
                                                  'Enter a valid email address');
                                            }
                                            return null;
                                          },
                                        ),
                                        FieldTitle(
                                            asProvider.getString('Phone')),
                                        TextFormField(
                                          controller: _phoneController,
                                          style: getFieldStyle(context),
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: asProvider
                                                .getString('Enter your phone'),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return asProvider.getString(
                                                  'Enter your phone number');
                                            }
                                            return null;
                                          },
                                        ),
                                        CountryDropdown(
                                          selectedValue:
                                              pProvider.selectedCountry?.name ??
                                                  pProvider
                                                      .profileInfo
                                                      ?.userDetails
                                                      .userCountry
                                                      ?.name,
                                          onChanged: (country) {
                                            pProvider
                                                .setSelectedCountry(country);
                                          },
                                        ),
                                        StateDropdown(
                                          selectedValue:
                                              pProvider.selectedState?.name ??
                                                  pProvider
                                                      .profileInfo
                                                      ?.userDetails
                                                      .userState
                                                      ?.name,
                                          countryId:
                                              pProvider.selectedCountry?.id ??
                                                  pProvider
                                                      .profileInfo
                                                      ?.userDetails
                                                      .userCountry
                                                      ?.id,
                                          onChanged: (state) {
                                            pProvider.setSelectedState(state);
                                          },
                                        ),
                                        CityDropdown(
                                          selectedValue:
                                              pProvider.selectedCity?.name ??
                                                  pProvider
                                                      .profileInfo
                                                      ?.userDetails
                                                      .userCity
                                                      ?.name,
                                          stateId:
                                              pProvider.selectedState?.id ??
                                                  pProvider
                                                      .profileInfo
                                                      ?.userDetails
                                                      .userState
                                                      ?.id,
                                          onChanged: (city) {
                                            pProvider.setSelectedCity(city);
                                          },
                                        ),
                                        FieldTitle(
                                            asProvider.getString('Zipcode')),
                                        TextFormField(
                                          style: getFieldStyle(context),
                                          controller: _zipcodeController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: asProvider.getString(
                                                'Enter your zipcode'),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return asProvider.getString(
                                                  'Enter your zipcode');
                                            }
                                            if (value.trim().length <= 3) {
                                              return asProvider.getString(
                                                  'Enter a valid zip code');
                                            }
                                            return null;
                                          },
                                        ),
                                        FieldTitle(
                                            asProvider.getString('Address')),
                                        TextFormField(
                                          style: getFieldStyle(context),
                                          controller: _addressController,
                                          textInputAction: TextInputAction.done,
                                          minLines: 3,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            hintText: asProvider.getString(
                                                'Enter your address'),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return asProvider.getString(
                                                  'Enter your address');
                                            }
                                            if (value.trim().length <= 2) {
                                              return asProvider.getString(
                                                  'Enter a valid address');
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(25),
                                        CustomCommonButton(
                                            btText: asProvider
                                                .getString('Save changes'),
                                            isLoading:
                                                pProvider.loadingProfileUpdate,
                                            onPressed: () {
                                              tryUpdateProfile(context);
                                              FocusScope.of(context).unfocus();
                                            })
                                      ]),
                                );
                              }),
                            ),
                          ),
                          EmptySpaceHelper.emptyHight(55),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  TextStyle getFieldStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(color: cc.greyHint);
  }
}
