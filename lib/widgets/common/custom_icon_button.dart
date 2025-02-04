import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class CustomIconButton extends StatefulWidget {
  final Widget icon;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final Color? color;
  const CustomIconButton(this.icon,
      {required this.onPressed,
      this.height,
      this.width,
      this.color,
      super.key});

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool pressed = false;
  pressedAction() {
    setState(() {
      pressed = true;
    });
  }

  releasedAction() {
    setState(() {
      pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        onTapDown: (details) => pressedAction(),
        onTapUp: (details) => releasedAction(),
        onTapCancel: () => releasedAction(),
        child: Container(
          height: widget.height ?? 40,
          width: widget.width ?? 40,
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            // borderRadius: const BorderRadius.only(
            //     bottomLeft: Radius.circular(12), topRight: Radius.circular(12)),
            borderRadius: BorderRadius.circular(8),
            color: pressed ? cc.blackColor : widget.color ?? cc.primaryColor,
            // gradient: pressed
            //     ? null
            //     : LinearGradient(
            //         colors: [
            //           cc.primaryColor,
            //           cc.secondGradient,
            //         ],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       )
          ),
          child: Center(child: widget.icon),
        ));
  }
}
