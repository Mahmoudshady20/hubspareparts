import 'package:flutter/material.dart';
import 'package:safecart/utils/responsive.dart';

class CustomRowButton extends StatelessWidget {
  String bt1text;
  String bt2text;
  void Function() bt1func;
  void Function() bt2func;
  final width;
  CustomRowButton({
    required this.bt1func,
    required this.bt2text,
    required this.bt1text,
    required this.bt2func,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width ?? screenWidth / 2.3,
          height: 46,
          child: OutlinedButton(
            onPressed: bt1func,
            child: Text(bt1text),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: width ?? screenWidth / 2.3,
          height: 46,
          child: ElevatedButton(
            onPressed: bt2func,
            child: Text(bt2text),
          ),
        ),
      ],
    );
  }
}
