import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../services/checkout_service/checkout_service.dart';

class DifferentSLChecker extends StatelessWidget {
  const DifferentSLChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutService>(
      builder: (context, cProvider, child) {
        return Row(
          children: [
            Switch(
              value: cProvider.differentSL,
              onChanged: (_) {
                cProvider.toggleDifferentSL(value: _);
              },
              focusColor: cc.primaryColor,
              activeColor: cc.primaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              AppLocalizations.of(context)!.ship_to_a_different_location,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: cc.greytitle),
            ),
          ],
        );
      },
    );
  }
}
