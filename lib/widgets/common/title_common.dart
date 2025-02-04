import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/common_helper.dart';

class TitleCommon extends StatelessWidget {
  String title;
  void Function()? onPressed;
  bool seeAll;
  bool padding;
  TitleCommon(this.title, this.onPressed,
      {this.seeAll = true, this.padding = false, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ? const EdgeInsets.symmetric(horizontal: 20) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          if (seeAll)
            TextButton(
              onPressed: onPressed,
              child: Text(AppLocalizations.of(context)!.see_All,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: cc.primaryColor, fontSize: 14)),
            ),
          // const Icon(
          //   Icons.arrow_forward_ios,
          //   size: 18,
          // )
        ],
      ),
    );
  }
}
