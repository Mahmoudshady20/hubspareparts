import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/product_details_service.dart';
import '../common/image_view.dart';
import 'product_details_indicator.dart';

class ProductDetailsImages extends StatelessWidget {
  const ProductDetailsImages({super.key});

  List<String> getAllImages(ProductDetailsService provider) {
    List<String> images = provider.productDetails?.galleryImages ?? [];

    // Ensure the main image is added only once
    if (provider.productDetails?.image != null &&
        !images.contains(provider.productDetails!.image)) {
      images.add(provider.productDetails!.image!);
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      List<String> allImages =
          getAllImages(pdProvider); // Use the function here

      return SizedBox(
        height: 300,
        child: pdProvider.additionalInfoImage != null
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ImageView(
                        pdProvider.additionalInfoImage!,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 300,
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: pdProvider.additionalInfoImage ?? '',
                      placeholder: (context, url) {
                        return _buildPlaceholder();
                      },
                      errorWidget: (context, url, error) {
                        return _buildPlaceholder();
                      },
                    ),
                  ),
                ),
              )
            : Stack(
                children: [
                  Swiper(
                    itemCount: allImages.length, // Now it has a fixed count
                    viewportFraction: 1,
                    scale: 1,
                    autoplay: allImages.length > 1,
                    onIndexChanged: (value) => pdProvider.changeIndex(value),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ImageView(
                                allImages[index],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 300,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: allImages[index],
                              placeholder: (context, url) {
                                return _buildLargePlaceholder();
                              },
                              errorWidget: (context, url, error) {
                                return _buildLargePlaceholder();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: FittedBox(
                      child: Row(
                        children: allImages
                            .map((e) => ProductDetailsIndicator(
                                e == allImages[pdProvider.currentIndex]))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/app_icon.png'),
                  opacity: .5)),
        ),
      ],
    );
  }

  Widget _buildLargePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loading_imaage.png'),
                  opacity: .5)),
        ),
      ],
    );
  }
}
