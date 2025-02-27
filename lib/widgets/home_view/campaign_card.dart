import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../helpers/common_helper.dart';

class CampaignCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? imgUrl;
  final Duration duration;
  bool margin;
  CampaignCard(this.title, this.subTitle, this.imgUrl, this.duration,
      {this.margin = true, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      width: 178,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: cc.lightPrimary10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
                height: 195,
                width: 178,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imgUrl ?? imageLoadingAppIcon,
                  placeholder: (context, url) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/loading_imaage.png'),
                            opacity: .4)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/loading_imaage.png'),
                            opacity: .4)),
                  ),
                )),
            Container(
              height: 200,
              width: 178,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      cc.pureWhite.withOpacity(.1),
                      cc.blackColor.withOpacity(1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    // stops: [.1, .3, 1],
                    tileMode: TileMode.mirror),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  FittedBox(
                    child: Text(title,
                        style: TextStyle(
                          color: cc.pureWhite,
                          fontSize: screenWidth / 24,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: cc.pureWhite.withOpacity(.8),
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  const Spacer(),
                  Center(
                    child: FittedBox(
                        child: SlideCountdownSeparated(
                      showZeroValue: true,
                      separator: '',
                      decoration: BoxDecoration(
                        color: cc.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      duration: duration,
                    )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
