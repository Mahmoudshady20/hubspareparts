import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/rtl_service.dart';

import '../../helpers/common_helper.dart';

class BoxedBackButton extends StatelessWidget {
  final void Function()? onTap;
  final margin;
  const BoxedBackButton(this.onTap, {super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    final rtl = Provider.of<RTLService>(context, listen: false).langRtl;
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: cc.greyFive,
              width: 1.5,
            ),
            color: cc.pureWhite,
          ),
          child: SvgPicture.asset(
              'assets/icons/${rtl ? 'arrow_right' : 'arrow_left'}.svg'),
        ));
  }
}
