import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/reset_password_service.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';

class NewPasswordView extends StatelessWidget {
  static const routeName = 'new_password_view';
  NewPasswordView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _newPasswordController = TextEditingController();

  tryResetPassword(BuildContext context) {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    Provider.of<ResetPasswordService>(context, listen: false)
        .resetPassword(context, _newPasswordController.text);
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
                        asProvider.getString('Reset your password'),
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
                                        FieldTitle(asProvider
                                            .getString('New password')),
                                        Consumer<ResetPasswordService>(builder:
                                            (context, rpProvider, child) {
                                          return TextFormField(
                                            controller: _newPasswordController,
                                            obscureText:
                                                rpProvider.obscurePasswordOne,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                              hintText: asProvider.getString(
                                                  'Enter new password'),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SvgPicture.asset(
                                                    'assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  rpProvider
                                                      .setObscurePasswordOne(
                                                          null);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${rpProvider.obscurePasswordOne ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty ||
                                                  value.length < 6) {
                                                return asProvider.getString(
                                                    'Password must be at least 6 character');
                                              }
                                              return null;
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(asProvider
                                            .getString('Confirm password')),
                                        Consumer<ResetPasswordService>(builder:
                                            (context, rpProvider, child) {
                                          return TextFormField(
                                            obscureText:
                                                rpProvider.obscurePasswordTwo,
                                            validator: (value) {
                                              if (_newPasswordController.text !=
                                                  value) {
                                                return asProvider.getString(
                                                    "Password didn't match");
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: asProvider.getString(
                                                  'Re-enter new password'),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SvgPicture.asset(
                                                    'assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  rpProvider
                                                      .setObscurePasswordTwo(
                                                          null);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${rpProvider.obscurePasswordTwo ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onFieldSubmitted: (value) {
                                              tryResetPassword(context);
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(30),
                                        Consumer<ResetPasswordService>(builder:
                                            (context, rpProvider, child) {
                                          return CustomCommonButton(
                                              btText: asProvider
                                                  .getString('Reset password'),
                                              isLoading: rpProvider
                                                  .loadingResetPassword,
                                              onPressed: () {
                                                tryResetPassword(context);
                                              });
                                        }),
                                      ]),
                                )),
                          ],
                        ),
                      ),
                    ),
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
