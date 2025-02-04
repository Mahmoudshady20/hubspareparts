import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/field_title.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../common/image_view.dart';

class SellerInfo extends StatelessWidget {
  const SellerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final pdProvider =
        Provider.of<ProductDetailsService>(context, listen: false);
    print(pdProvider.productDetails!.vendor?.image);
    return pdProvider.vendor == null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              'No information available',
              style: TextStyle(
                  color: cc.greyHint,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis),
            ),
          )
        : Consumer<ProductDetailsService>(
            builder: (context, pdProvider, child) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: GestureDetector(
                    onTap: () {
                      if (pdProvider.productDetails!.vendor?.image == null) {
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ImageView(
                            pdProvider.productDetails!.vendor?.image,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        // color: Colors.red,
                        imageUrl: pdProvider.productDetails!.vendor?.image ??
                            imageLoadingAppIcon,
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
                  title: Text(
                    pdProvider.productDetails!.vendor?.ownerName ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Row(
                  //   children: [
                  //     RatingBar.builder(
                  //       ignoreGestures: true,
                  //       itemSize: 17,
                  //       initialRating: 4.5,
                  //       minRating: 1,
                  //       direction: Axis.horizontal,
                  //       allowHalfRating: true,
                  //       itemCount: 5,
                  //       itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                  //       itemBuilder: (context, _) => SvgPicture.asset(
                  //         'assets/icons/star.svg',
                  //         color: cc.orangeRating,
                  //       ),
                  //       onRatingUpdate: (rating) {
                  //         print(rating);
                  //         // Provider.of<ReviewService>(context, listen: false)
                  //         //     .setRating(rating.toString());
                  //       },
                  //     ),
                  //     EmptySpaceHelper.emptywidth(10),
                  //     const Text('(197)')
                  //   ],
                  // ),
                ),
                EmptySpaceHelper.emptyHight(10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: cc.greyBorder)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          infoColumn(
                              context,
                              AppLocalizations.of(context)!.from,
                              pdProvider.productDetails!.vendor?.vendorAddress!
                                  .country.name),
                          infoColumn(
                              context,
                              AppLocalizations.of(context)!.about_Since,
                              pdProvider.productDetails!.vendor?.createdAt?.year
                                  .toString())
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     infoColumn(
                      //         context, asProvider.getString('About Since'), '2020'),
                      //     infoColumn(context,
                      //         asProvider.getString('Satisfied Client'), '820')
                      //   ],
                      // ),
                      EmptySpaceHelper.emptyHight(10),
                      ExpandableText(
                        pdProvider.productDetails!.vendor?.description ?? '',
                        expandText: AppLocalizations.of(context)!.show_more,
                        collapseText: AppLocalizations.of(context)!.show_less,
                        linkColor: cc.primaryColor,
                        maxLines: 3,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: cc.greyParagraph,
                                ),
                      )
                    ],
                  ),
                ),
                EmptySpaceHelper.emptyHight(10),
              ],
            );
          });
  }

  Widget infoColumn(BuildContext context, title, value) {
    return SizedBox(
      width: (screenWidth - 65) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldTitle(title),
          Text(
            value ?? '',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
