import 'package:flutter/material.dart';
import 'package:safecart/utils/custom_preloader.dart';

class CustomCommonButton extends StatelessWidget {
  final void Function()? onPressed;
  final String btText;
  final bool isLoading;
  final double? height;
  final double? width;
  final Color? color;
  const CustomCommonButton(
      {super.key,
      required this.onPressed,
      required this.btText,
      required this.isLoading,
      this.height = 46,
      this.width,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? () {}
            : () {
                onPressed!();
              },
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: isLoading
            ? SizedBox(
                child: FittedBox(
                  child: CustomPreloader(
                    whiteColor: true,
                  ),
                ),
              )
            : FittedBox(
                child: Text(
                  btText,
                  maxLines: 1,
                ),
              ),
      ),
    );
  }
}
