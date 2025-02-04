import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';

class ShippingAddressTileSkeleton extends StatelessWidget {
  const ShippingAddressTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cc.whiteGrey,
            border: Border.all(color: cc.lightPrimary10, width: .5)),
        child: Stack(children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(AppLocalizations.of(context)!.title),
            ),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(AppLocalizations.of(context)!.address),
            ),
            trailing: GestureDetector(
                child: SvgPicture.asset(
              'assets/icons/trash.svg',
              height: 22,
              width: 22,
              color: cc.red,
            )),
          ),
        ]),
      ),
    );
  }
}
