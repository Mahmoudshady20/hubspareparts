import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../utils/responsive.dart';

class CartTileInfo extends StatelessWidget {
  final title;
  final imageUrl;
  final inventorySet;
  const CartTileInfo({this.title, this.imageUrl, this.inventorySet, super.key});

  @override
  Widget build(BuildContext context) {
    String attributes = inventorySet.toString();
    String attributes2 = attributes.replaceAll('{', '');
    final attributes3 = attributes2.replaceAll('}', '');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cc.pureWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: screenHeight / 2.7,
        width: screenWidth - 90,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            EmptySpaceHelper.emptyHight(10),
            Center(
              child: Container(
                height: screenHeight / 4.5,
                width: screenWidth - 90,
                decoration: BoxDecoration(
                  color: cc.lightPrimary10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/app_icon.png'),
                                  opacity: .5)),
                        ),
                      ],
                    ),
                    errorWidget: (context, url, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/app_icon.png'),
                                  opacity: .5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            EmptySpaceHelper.emptyHight(10),
            Text(
              'Apple Orginal Chair Collection',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cc.blackColor,
                  ),
            ),
            EmptySpaceHelper.emptyHight(10),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.attributes}:',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cc.blackColor,
                      ),
                ),
                Text(
                  inventorySet.toString() == '{}'
                      ? ' ${AppLocalizations.of(context)!.none}'
                      : ' ${attributes3.toString().replaceAll('()', '')}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cc.greyParagraph,
                      ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
