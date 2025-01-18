import 'package:flutter/material.dart';
import 'package:safecart/widgets/common/boxed_back_button.dart';

import '../../helpers/common_helper.dart';

class CustomAppBar {
  PreferredSizeWidget appBarTitled(
      BuildContext context, String? title, Function ontap,
      {bool hasButton = true,
      bool hasElevation = false,
      bool? centerTitle = true,
      bool leading = true,
      textColor,
      color,
      List<Widget>? actions}) {
    return AppBar(
        elevation: hasElevation ? 1 : 0,
        foregroundColor: cc.blackColor,
        backgroundColor: color ?? cc.pureWhite,
        centerTitle: centerTitle,
        title: title == null
            ? null
            : Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: textColor),
              ),
        leading: leading
            ? GestureDetector(
                onTap: () => ontap(),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [BoxedBackButton(null)]),
              )
            : null,
        actions: actions);
  }
}
