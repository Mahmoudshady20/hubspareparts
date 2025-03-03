import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/home_view/categories.dart';

import '../../helpers/common_helper.dart';
import '../../services/rtl_service.dart';

class HomeAppDrawer extends StatelessWidget {
  const HomeAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cc.pureWhite,
      child: Column(
        children: [
          Spacer(),
          Categories(),
        ],
      ),
    );
  }

  Widget profileItem(
    BuildContext context,
    String itemText,
    String iconPath, {
    void Function()? onTap,
    bool icon = true,
    double imageSize = 35,
    double imageSize2 = 35,
    double textSize = 16,
    bool divider = true,
  }) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            child: ListTile(
              onTap: onTap,
              visualDensity: const VisualDensity(vertical: -3),
              dense: false,
              leading: icon
                  ? SvgPicture.asset(
                      iconPath,
                      height: imageSize,
                    )
                  : Image.asset(
                      iconPath,
                      height: imageSize,
                    ),
              title: Text(
                itemText,
                style: TextStyle(
                  fontSize: textSize,
                  color: cc.blackColor,
                ),
              ),
              trailing: Container(
                margin: Provider.of<RTLService>(context, listen: false).langRtl
                    ? const EdgeInsets.only(left: 25)
                    : null,
                child: Transform(
                  transform:
                      Provider.of<RTLService>(context, listen: false).langRtl
                          ? Matrix4.rotationY(pi)
                          : Matrix4.rotationY(0),
                  child: SvgPicture.asset(
                    'assets/icons/arrow_boxed_right.svg',
                  ),
                ),
              ),
            ),
          ),
          if (divider) const Divider()
        ],
      ),
    );
  }
}
