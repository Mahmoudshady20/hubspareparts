import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/sign_in_service.dart';
import 'package:safecart/utils/country_dropdown.dart';
import 'package:safecart/utils/state_dropdown.dart';

import '../../services/auth_service/sign_up_service.dart';
import '../../utils/custom_preloader.dart';
import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/auth_service/social_signin_signup_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';
import '../widgets/common/horizontal_or_divider.dart';
import '../widgets/common/web_view.dart';

class SignUpView extends StatelessWidget {
  static const routeName = 'sign_up_view';
  SignUpView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();

  trySignUp(BuildContext context) {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    final suProvider = Provider.of<SignUpService>(context, listen: false);
    if (suProvider.selectedCountry == null) {
      showToast(
          AppLocalizations.of(context)!.you_have_to_select_a_country, cc.red);
      return;
    }
    if (suProvider.selectedState == null) {
      showToast(
          AppLocalizations.of(context)!.you_have_to_select_a_state, cc.red);
      return;
    }
    if (suProvider.acceptTPP != true) {
      showToast(
          AppLocalizations.of(context)!
              .you_have_to_agree_our_terms_and_conditions,
          cc.red);
      return;
    }
    suProvider.signUp(
      context,
      _nameController.text,
      _emailController.text,
      _userNameController.text,
      _newPassController.text,
      _phoneController.text,
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
                expandedHeight: screenHeight / 3.3,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: screenHeight / 3.7,
                    width: double.infinity,
                    // padding: EdgeInsets.only(top: screenHeight / 7),
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.welcome,
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
                            // AuthAppBar(),
                            Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FieldTitle(
                                            AppLocalizations.of(context)!.name),
                                        TextFormField(
                                          controller: _nameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .enter_your_name,
                                              prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                      'assets/icons/profile_prefix.svg'))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.length < 3) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .enter_a_valid_name;
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(AppLocalizations.of(context)!
                                            .username),
                                        TextFormField(
                                          controller: _userNameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .enter_your_username,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  'assets/icons/profile_prefix.svg'),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.length < 3) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .enter_a_valid_username;
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(AppLocalizations.of(context)!
                                            .email),
                                        TextFormField(
                                          controller: _emailController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .enter_your_email,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  'assets/icons/email_prefix.svg'),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (!EmailValidator.validate(
                                                value ?? '')) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .enter_a_valid_email_address;
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        // FieldTitle(
                                        //     asProvider.getString('Country')),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return CountryDropdown(
                                            selectedValue: suProvider
                                                .selectedCountry?.name,
                                            onChanged: (country) {
                                              suProvider
                                                  .setSelectedCountry(country);
                                            },
                                          );
                                        }),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return StateDropdown(
                                            selectedValue:
                                                suProvider.selectedState?.name,
                                            countryId:
                                                suProvider.selectedCountry?.id,
                                            onChanged: (state) {
                                              suProvider
                                                  .setSelectedState(state);
                                            },
                                          );
                                        }),
                                        // EmptySpaceHelper.emptyHight(10),
                                        // Consumer<SignUpService>(builder:
                                        //     (context, suProvider, child) {
                                        //   return suProvider
                                        //               .selectedCountryName ==
                                        //           null
                                        //       ? const SizedBox()
                                        //       : FieldTitle(asProvider
                                        //           .getString('State'));
                                        // }),
                                        // Consumer<SignUpService>(builder:
                                        //     (context, suProvider, child) {
                                        //   return suProvider
                                        //               .selectedCountryName ==
                                        //           null
                                        //       ? const SizedBox()
                                        //       : Consumer<CountryStateService>(
                                        //           builder: (context, cProvider,
                                        //               child) {
                                        //             return cProvider.states ==
                                        //                     null
                                        //                 ? SizedBox(
                                        //                     height: 55,
                                        //                     child: FittedBox(
                                        //                         child:
                                        //                             CustomPreloader()))
                                        //                 : CustomDropdown(
                                        //                     asProvider.getString(
                                        //                         'Select your State'),
                                        //                     value: suProvider
                                        //                         .selectedStateName,
                                        //                     cProvider.states!
                                        //                         .map((e) =>
                                        //                             e!.name)
                                        //                         .toList(),
                                        //                     (value) {
                                        //                       suProvider
                                        //                           .setSelectedStateName(
                                        //                               value);
                                        //                     },
                                        //                   );
                                        //           },
                                        //         );
                                        // }),
                                        // Consumer<SignUpService>(builder:
                                        //     (context, suProvider, child) {
                                        //   return suProvider
                                        //               .selectedCountryName ==
                                        //           null
                                        //       ? const SizedBox()
                                        //       : EmptySpaceHelper.emptyHight(10);
                                        // }),
                                        FieldTitle(AppLocalizations.of(context)!
                                            .phone),
                                        TextFormField(
                                          controller: _phoneController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .enter_your_phone_number,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  'assets/icons/phone_prefix.svg'),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .enter_your_phone_number;
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(AppLocalizations.of(context)!
                                            .password),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return TextFormField(
                                            controller: _newPassController,
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText:
                                                suProvider.obscurePasswordOne,
                                            decoration: InputDecoration(
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .enter_your_Password,
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SvgPicture.asset(
                                                    'assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  suProvider
                                                      .setObscurePasswordOne(
                                                          null);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${suProvider.obscurePasswordOne ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty ||
                                                  value.length < 6) {
                                                return AppLocalizations.of(
                                                        context)!
                                                    .password_must_be_more_then_character;
                                              }
                                              return null;
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(AppLocalizations.of(context)!
                                            .confirm_new_password),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return TextFormField(
                                            obscureText:
                                                suProvider.obscurePasswordTwo,
                                            decoration: InputDecoration(
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .re_enter_your_Password,
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SvgPicture.asset(
                                                    'assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  suProvider
                                                      .setObscurePasswordTwo(
                                                          null);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${suProvider.obscurePasswordTwo ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_newPassController.text !=
                                                  value) {
                                                return AppLocalizations.of(
                                                        context)!
                                                    .password_didn_match;
                                              }
                                              return null;
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(15),
                                        Row(
                                          children: [
                                            Consumer<SignUpService>(builder:
                                                (context, suProvider, child) {
                                              return Transform.scale(
                                                scale: 1.3,
                                                child: Checkbox(
                                                  value: suProvider.acceptTPP,
                                                  onChanged: (value) {
                                                    suProvider
                                                        .setAcceptTPP(value);
                                                  },
                                                ),
                                              );
                                            }),
                                            SizedBox(
                                              width: screenWidth - 150,
                                              child: RichText(
                                                softWrap: true,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                    text:
                                                        '${AppLocalizations.of(context)!.by_creating_an_account_you_agree_to_the} ',
                                                    style: TextStyle(
                                                      color: cc.greyHint,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          WebViewScreen
                                                                              .routeName,
                                                                          arguments: [
                                                                        AppLocalizations.of(context)!
                                                                            .terms_and_Conditions,
                                                                        '$baseApi/terms-and-condition-page'
                                                                      ]);
                                                                },
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .terms_of_service_and_Conditions,
                                                          style: TextStyle(
                                                              color: cc
                                                                  .secondaryColor)),
                                                      TextSpan(
                                                          text:
                                                              ', ${AppLocalizations.of(context)!.and} ',
                                                          style: TextStyle(
                                                              color:
                                                                  cc.greyHint)),
                                                      TextSpan(
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          WebViewScreen
                                                                              .routeName,
                                                                          arguments: [
                                                                        AppLocalizations.of(context)!
                                                                            .privacy_Policy,
                                                                        '$baseApi/privacy-policy-page'
                                                                      ]);
                                                                },
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .privacy_Policy,
                                                          style: TextStyle(
                                                              color: cc
                                                                  .secondaryColor)),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        EmptySpaceHelper.emptyHight(15),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return CustomCommonButton(
                                              btText:
                                                  AppLocalizations.of(context)!
                                                      .sign_up,
                                              isLoading:
                                                  suProvider.loadingSignUp,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                trySignUp(context);
                                                // Navigator.of(context)
                                                //     .push(PageRouteBuilder(
                                                //         pageBuilder: (context,
                                                //             animation,
                                                //             anotherAnimation) {
                                                //   return EnterOtpView(
                                                //     '4444',
                                                //     fromRegister: true,
                                                //   );
                                                // },
                                                //         // transitionDuration:
                                                //         //     const Duration(milliseconds: 300),
                                                //         transitionsBuilder:
                                                //             (context,
                                                //                 animation,
                                                //                 anotherAnimation,
                                                //                 child) {
                                                //   animation = CurvedAnimation(
                                                //       curve: Curves.decelerate,
                                                //       parent: animation);
                                                //   return Align(
                                                //     child: FadeTransition(
                                                //       opacity: animation,
                                                //       // axisAlignment: 0.0,
                                                //       child: child,
                                                //     ),
                                                //   );
                                                // }))
                                                //     .then((value) {
                                                //   if (value == true) {
                                                //     Navigator.pop(context, true);
                                                //   }
                                                // });
                                              });
                                        }),
                                        EmptySpaceHelper.emptyHight(20),
                                        Center(
                                          child: RichText(
                                            softWrap: true,
                                            text: TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .already_have_an_account,
                                                style: TextStyle(
                                                  color: cc.greyHint,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: '   ',
                                                      style: TextStyle(
                                                          color: cc.greyHint)),
                                                  TextSpan(
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              Provider.of<SignInService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setObscurePassword(
                                                                      true);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .sign_In,
                                                      style: TextStyle(
                                                          color: cc
                                                              .secondaryColor)),
                                                ]),
                                          ),
                                        ),
                                        EmptySpaceHelper.emptyHight(20),
                                        const HorizontalOrDivider(),
                                        EmptySpaceHelper.emptyHight(20),
                                        Consumer<SocialSignInSignUpService>(
                                            builder: (context, socialProvider,
                                                child) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 46,
                                            child: OutlinedButton.icon(
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (socialProvider
                                                      .loadingGoogleSignInSignUp) {
                                                    return;
                                                  }
                                                  socialProvider
                                                      .googleSignInSignUp(
                                                          context,
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .sign_up_failed);
                                                },
                                                icon: SvgPicture.asset(
                                                    'assets/icons/google.svg'),
                                                label: socialProvider
                                                        .loadingGoogleSignInSignUp
                                                    ? FittedBox(
                                                        child:
                                                            CustomPreloader(),
                                                      )
                                                    : Text(AppLocalizations.of(
                                                            context)!
                                                        .sign_up_with_Google)),
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        Consumer<SocialSignInSignUpService>(
                                            builder: (context, socialProvider,
                                                child) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 46,
                                            child: OutlinedButton.icon(
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (socialProvider
                                                      .loadingFacebookSignInSignUp) {
                                                    return;
                                                  }
                                                  socialProvider
                                                      .facebookSignInSignUp(
                                                          context,
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .sign_up_failed);
                                                },
                                                icon: SvgPicture.asset(
                                                    'assets/icons/facebook.svg'),
                                                label: socialProvider
                                                        .loadingFacebookSignInSignUp
                                                    ? FittedBox(
                                                        child:
                                                            CustomPreloader(),
                                                      )
                                                    : Text(AppLocalizations.of(
                                                            context)!
                                                        .sign_up_with_Facebook)),
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(30),
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
}
