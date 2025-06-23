import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/field_title.dart';

import '../../services/location/country_dropdown_service.dart';
import '../helpers/empty_space_helper.dart';
import 'custom_preloader.dart';

class CountryDropdown extends StatelessWidget {
  final String? hintText;
  final String? textFieldHint;
  final selectedValue;
  final onChanged;
  final iconColor;
  TextStyle? textStyle;
  CountryDropdown(
      {this.hintText,
      this.selectedValue,
      this.onChanged,
      this.textFieldHint,
      this.iconColor,
      this.textStyle,
      super.key});

  final ScrollController controller = ScrollController();
  Timer? scheduleTimeout;
  @override
  Widget build(BuildContext context) {
    textStyle ??= Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: cc.blackColor.withOpacity(.60),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitle(AppLocalizations.of(context)!.country),
        InkWell(
          onTap: () {
            Provider.of<CountryDropdownService>(context, listen: false)
                .resetList();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: cc.pureWhite,
                  ),
                  constraints: BoxConstraints(
                      maxHeight: screenHeight / 2 +
                          (MediaQuery.of(context).viewInsets.bottom / 2)),
                  child: Consumer<CountryDropdownService>(
                      builder: (context, cProvider, child) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: textFieldHint ??
                                      AppLocalizations.of(context)!
                                          .search_country,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: SvgPicture.asset(
                                      "assets/icons/only_search.svg",
                                      color: cc.blackColor.withOpacity(.60),
                                    ),
                                  )),
                              onChanged: (value) async {
                                scheduleTimeout?.cancel();
                                scheduleTimeout =
                                    Timer(const Duration(seconds: 1), () {
                                  cProvider.setCountrySearchValue(value);
                                  cProvider.getCountries();
                                });
                              }),
                        ),
                        Expanded(
                          child: ListView.separated(
                              controller: controller,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, bottom: 20),
                              itemBuilder: (context, index) {
                                if (cProvider.countryLoading ||
                                    (cProvider.countryDropdownList.length ==
                                            index &&
                                        cProvider.nextPage != null)) {
                                  return SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: Center(child: CustomPreloader()));
                                }
                                if (cProvider.countryDropdownList.isEmpty) {
                                  return SizedBox(
                                    width: screenWidth - 60,
                                    height: 64,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .no_result_found,
                                        style: textStyle,
                                      ),
                                    ),
                                  );
                                }
                                if (cProvider.countryDropdownList.length ==
                                    index) {
                                  return SizedBox(
                                    width: screenWidth - 60,
                                    height: 64,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .no_result_found,
                                        style: textStyle,
                                      ),
                                    ),
                                  );
                                }
                                final element =
                                    cProvider.countryDropdownList[index];
                                return InkWell(
                                  onTap: () {
                                    if (onChanged == null ||
                                        element == selectedValue) {
                                      return;
                                    }
                                    onChanged(element);
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 14),
                                    child: Text(
                                      element?.name ?? '',
                                      style: textStyle,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 8,
                                    child: Center(child: Divider()),
                                  ),
                              itemCount: cProvider.countryLoading == true ||
                                      cProvider.countryDropdownList.isEmpty
                                  ? 1
                                  : cProvider.countryDropdownList.length +
                                      (cProvider.nextPage != null &&
                                              !cProvider.nexLoadingFailed
                                          ? 1
                                          : 0)),
                        )
                      ],
                    );
                  }),
                );
              },
            );
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: cc.blackColor.withOpacity(.20), width: 1),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    "assets/icons/location.svg",
                    height: 24,
                  ),
                ),
                Text(
                  selectedValue ?? AppLocalizations.of(context)!.select_country,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: cc.blackColor.withOpacity(.40),
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: cc.blackColor.withOpacity(.60),
                  ),
                ),
              ],
            ),
          ),
        ),
        EmptySpaceHelper.emptyHight(10),
      ],
    );
  }
}
