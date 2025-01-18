import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/product_details_service.dart';
import '../common/image_view.dart';
import 'product_details_indicator.dart';

class ProductDetailsImages extends StatelessWidget {
  const ProductDetailsImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return SizedBox(
        height: 300,
        // margin: EdgeInsets.only(top: topPadding),
        // padding: const EdgeInsets.symmetric(vertical: 20),
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
                      // color: Colors.red,
                      imageUrl: pdProvider.additionalInfoImage ?? '',
                      placeholder: (context, url) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/app_icon.png'),
                                      opacity: .5)),
                            ),
                          ],
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/app_icon.png'),
                                      opacity: .5)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )
            : Stack(
                children: [
                  Swiper(
                    itemCount: pdProvider.productDetails!.galleryImages != null
                        ? pdProvider.productDetails!.galleryImages!.length
                        : 1,
                    viewportFraction: 1,
                    scale: 1,
                    autoplay:
                        (pdProvider.productDetails?.galleryImages?.length ??
                                1) >
                            1,
                    onIndexChanged: (value) => pdProvider.changeIndex(value),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ImageView(
                                pdProvider.productDetails?.galleryImages != null
                                    ? pdProvider
                                        .productDetails!.galleryImages![index]
                                    : pdProvider.productDetails!.image ?? '',
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 300,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              // color: Colors.red,
                              imageUrl:
                                  pdProvider.productDetails?.galleryImages !=
                                          null
                                      ? pdProvider
                                          .productDetails!.galleryImages![index]
                                      : pdProvider.productDetails!.image ?? '',
                              placeholder: (context, url) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/loading_image.png'),
                                              opacity: .5)),
                                    ),
                                  ],
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/loading_image.png'),
                                              opacity: .5)),
                                    ),
                                  ],
                                );
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
                        children: [
                          ...(pdProvider.productDetails!.galleryImages != null
                                  ? pdProvider.productDetails!.galleryImages!
                                  : [])
                              .map((e) => ProductDetailsIndicator(e ==
                                  (pdProvider.productDetails!.galleryImages !=
                                              null &&
                                          pdProvider.productDetails!
                                              .galleryImages!.isNotEmpty
                                      ? pdProvider
                                              .productDetails!.galleryImages![
                                          pdProvider.currentIndex]
                                      : 1))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
