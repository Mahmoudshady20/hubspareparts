import 'package:flutter/material.dart';

class ImageLoadingFailed extends StatelessWidget {
  final double size;
  const ImageLoadingFailed({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loading_image.png'),
                  opacity: .5)),
        ),
      ],
    );
  }
}
