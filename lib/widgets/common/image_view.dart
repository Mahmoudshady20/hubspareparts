import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/widgets/common/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/common_helper.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  const ImageView(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar().appBarTitled(context, '', () {
          Navigator.of(context).pop();
        }),
        body: Center(
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            loadingBuilder:
                (BuildContext context, ImageChunkEvent? loadingProgress) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60, child: CustomPreloader()),
                ],
              );
            },
            errorBuilder: (context, exception, stackTrace) {
              return Text(AppLocalizations.of(context)!.connection_failed);
            },
            imageProvider: imageUrl.contains('http')
                ? NetworkImage(imageUrl) as ImageProvider<Object>?
                : FileImage(File(imageUrl)),
          ),
        ));
  }
}
