import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../services/new_ticket_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/custom_dropdown.dart';
import '../widgets/common/field_title.dart';

class NewTicketView extends StatelessWidget {
  static const routeName = 'add new ticket';
  NewTicketView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _subjectFN = FocusNode();

  Future _onSubmit(BuildContext context, NewTicketService ntService) async {
    final validated = _formKey.currentState!.validate();
    if (!validated) {
      snackBar(
          context,
          AppLocalizations.of(context)!
              .please_give_all_the_information_properly,
          backgroundColor: cc.red);
      return;
    }
    await ntService.addNewToken(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<NewTicketService>(builder: (context, ntService, child) {
      return Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
            color: cc.primaryColor,
            alignment: Alignment.topCenter,
            child: const Center(),
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
                    // padding: EdgeInsets.only(top: screenHeight / 7),
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.add_new_ticket,
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color: Colors.white,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FieldTitle(AppLocalizations.of(context)!.title),
                                // const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .enter_a_title,
                                  ),
                                  onChanged: (value) {
                                    ntService.setTitle(value);
                                  },
                                  validator: (name) {
                                    if (name!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enter_a_title;
                                    }
                                    if (name.length <= 2) {
                                      return AppLocalizations.of(context)!
                                          .enter_a_valid_title;
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_subjectFN);
                                  },
                                ),
                                FieldTitle(
                                    AppLocalizations.of(context)!.subject),
                                // const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .enter_a_subject,
                                  ),
                                  focusNode: _subjectFN,
                                  onChanged: (value) {
                                    ntService.setSubject(value);
                                  },
                                  validator: (name) {
                                    if (name!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enter_a_valid_subject;
                                    }
                                    if (name.length <= 5) {
                                      return AppLocalizations.of(context)!
                                          .enter_a_subject_with_more_then_character;
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) async {
                                    ntService.setIsLoading(false);
                                  },
                                ),
                                FieldTitle(
                                    AppLocalizations.of(context)!.priority),
                                // const SizedBox(height: 8),
                                CustomDropdown(
                                  ntService.selectedPriority as String,
                                  ntService.priority,
                                  (newValue) {
                                    ntService.setSelectedPriority(
                                        newValue as String);
                                  },
                                  value: ntService.selectedPriority,
                                ),

                                FieldTitle(
                                    AppLocalizations.of(context)!.department),
                                ntService.allDepartment == null
                                    ? SizedBox(
                                        height: 56, child: CustomPreloader())
                                    : CustomDropdown(
                                        AppLocalizations.of(context)!
                                            .department,
                                        ntService.departmentNames,
                                        (newValue) {
                                          ntService
                                              .setSelectedDepartment(newValue);
                                        },
                                        value:
                                            ntService.selectedDepartment?.name,
                                      ),

                                FieldTitle(
                                    AppLocalizations.of(context)!.description),
                                // const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .describe_your_issue,
                                  ),
                                  onChanged: (value) {
                                    ntService.setDescription(value);
                                  },
                                  validator: (address) {
                                    if (address == null || address.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .you_have_to_give_some_description;
                                    }

                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    _onSubmit(context, ntService);
                                  },
                                ),
                                const SizedBox(height: 40),
                                CustomCommonButton(
                                    btText: AppLocalizations.of(context)!
                                        .add_Ticket,
                                    isLoading: ntService.isLoading,
                                    onPressed: () {
                                      _onSubmit(context, ntService);
                                    }),
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }));
  }
}
