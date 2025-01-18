import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/widgets/common/image_loading_failed.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String? imagUrl;
  const CategoryCard(this.title, this.imagUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: cc.primaryColor.withOpacity(.1)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imagUrl ?? imageLoadingProductCard,
                placeholder: (context, url) => const ImageLoadingFailed(
                  size: 50,
                ),
                errorWidget: (context, url, error) => const ImageLoadingFailed(
                  size: 50,
                ),
              ),
            ),
          ),
          EmptySpaceHelper.emptyHight(5),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
