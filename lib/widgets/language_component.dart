import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/services/settings_services.dart';

class LanguageComponent extends StatelessWidget {
  const LanguageComponent({
    super.key,
    required this.languageDropValue,
    required this.onChanged,
  });
  final String? languageDropValue;
  final void Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          AppLocalizations.of(context)!.language,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        EmptySpaceHelper.emptyHight(10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD6D6D6)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) => DropdownButton(
              isExpanded: true,
              dropdownColor: Colors.white,
              underline: Container(
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.only(right: 8, left: 8),
              items: [
                DropdownMenuItem(
                  onTap: () {
                    settingsProvider.enableArabic();
                  },
                  value: 'arabic',
                  child: Text(
                    AppLocalizations.of(context)!.arabic,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  onTap: () {
                    settingsProvider.enableEnglish();
                  },
                  value: 'english',
                  child: Text(AppLocalizations.of(context)!.english,
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                ),
              ],
              value: languageDropValue,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .05,
        )
      ],
    );
  }
}
