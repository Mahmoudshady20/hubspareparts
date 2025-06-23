import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/change_password_service.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';

class ChangePasswordView extends StatelessWidget {
  static const routeName = 'change_name_view';
  ChangePasswordView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  tryChangePassword(BuildContext context) {
    FocusScope.of(context).unfocus();
    bool valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    Provider.of<ChangePasswordService>(context, listen: false)
        .changePassword(context, _currentPassword.text, _newPassword.text);
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
          alignment: Alignment.topCenter,
          child: const Center(),
        ),
        CustomScrollView(slivers: [
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
                // padding: EdgeInsets.only(top: screenHeight / 7),
                color: cc.primaryColor,
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.change_Password,
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
                // EmptySpaceHelper.emptyHight(50),
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 20),
                //       child: BoxedBackButton(() {
                //         Navigator.of(context).pop();
                //       }),
                //     ),
                //   ],
                // ),
                // EmptySpaceHelper.emptyHight(screenHeight / 6),
                Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldTitle(AppLocalizations.of(context)!.current_password),
                          TextFormField(
                            controller: _currentPassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.enter_your_Password),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return AppLocalizations.of(context)!.please_provide_current_password;
                              }
                              return null;
                            },
                          ),
                          FieldTitle(AppLocalizations.of(context)!.new_password),
                          TextFormField(
                            controller: _newPassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText:
                                AppLocalizations.of(context)!.enter_new_password),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return AppLocalizations.of(context)!.password_must_be_more_then_character;
                              }
                              return null;
                            },
                          ),
                          FieldTitle(
                              AppLocalizations.of(context)!.confirm_new_password),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.re_enter_new_password),
                            validator: (value) {
                              if (_newPassword.text != value) {
                                return AppLocalizations.of(context)!.password_didn_match;
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) =>
                                tryChangePassword(context),
                          ),
                          EmptySpaceHelper.emptyHight(30),
                          Consumer<ChangePasswordService>(
                              builder: (context, cpProvider, child) {
                            return CustomCommonButton(
                              btText: AppLocalizations.of(context)!.change_Password,
                              isLoading: cpProvider.loadingChangePassword,
                              onPressed: () {
                                tryChangePassword(context);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ],
    ));
  }
}
