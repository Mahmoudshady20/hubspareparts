import 'package:flutter/material.dart';
import 'package:safecart/utils/custom_preloader.dart';

class CustomOutlinedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String btText;
  final bool isLoading;
  final double? height;
  final double? width;
  final Color? color;
  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.btText,
    required this.isLoading,
    this.height = 46,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: OutlinedButton(
          onPressed: isLoading
              ? () {}
              : () {
                  onPressed!();
                },
          child: isLoading
              ? SizedBox(
                  child: CustomPreloader(
                    whiteColor: true,
                  ),
                )
              : Text(btText)),
    );
  }
}
