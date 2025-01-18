import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../services/rtl_service.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 230,
          alignment: Alignment.bottomCenter,
          // padding:
          //     EdgeInsets.only(top: MediaQuery.of(context).padding.top - 20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: cc.primaryColor.withOpacity(.2),

            image: const DecorationImage(
                image: AssetImage('assets/images/NEXELIT.png'),
                // scale: 1.5,
                repeat: ImageRepeat.repeat,
                opacity: 1),
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.grey,
            //       blurRadius: 4,
            //       spreadRadius: 2,
            //       blurStyle: BlurStyle.normal)
            // ]
          ),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: 230 - MediaQuery.of(context).padding.top,
              child: Image.asset(
                'assets/images/dummy_prod_0.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Transform(
                transform:
                    Provider.of<RTLService>(context, listen: false).langRtl
                        ? Matrix4.rotationY(pi)
                        : Matrix4.rotationY(0),
                child: SvgPicture.asset(
                  'assets/icons/back_button.svg',
                  color: cc.blackColor,
                  height: 25,
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}
