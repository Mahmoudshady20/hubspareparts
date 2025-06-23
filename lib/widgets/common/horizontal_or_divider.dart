import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:safecart/helpers/common_helper.dart';

class HorizontalOrDivider extends StatelessWidget {
  const HorizontalOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              height: 50,
              color: cc.greyBorder,
              thickness: .6,
            ),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.or,
          style: TextStyle(color: cc.greytitle, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              height: 50,
              color: cc.greyBorder,
              thickness: 1,
            ),
          ),
        )
      ],
    );
  }
}
