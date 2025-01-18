import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/home_campaign_products_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/product_slider.dart';
import 'package:safecart/widgets/skelletons/homepage_title_skeleton.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../skelletons/product_card_skeleton.dart';

class HomeCampaignProducts extends StatelessWidget {
  const HomeCampaignProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCampaignProductsService>(
        builder: (context, hcpProvider, child) {
      return FutureBuilder(
          future: !hcpProvider.homeCampaignProductsLoading &&
                  hcpProvider.homeCampaignProductsList == null &&
                  hcpProvider.campaignInfo == null
              ? hcpProvider.fetchHomeCampaignProducts(context)
              : null,
          builder: (context, snapshot) {
            return !hcpProvider.homeCampaignProductsLoading
                ? hcpProvider.homeCampaignProductsList != null &&
                        hcpProvider.campaignInfo != null &&
                        hcpProvider.homeCampaignProductsList!.isNotEmpty
                    ? SizedBox(
                        // height: 305,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  // const SizedBox(width: 18),
                                  SizedBox(
                                    width: (screenWidth - 40) / 2,
                                    child: Text(
                                      hcpProvider.campaignInfo!.title ??
                                          asProvider
                                              .getString('Campaign Products'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  const Spacer(),
                                  FittedBox(
                                      child: SlideCountdownSeparated(
                                    showZeroValue: true,
                                    separator: '',
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 1,
                                          color: cc.greyBorder,
                                        )),
                                    duration: hcpProvider
                                                    .campaignInfo!.endDate !=
                                                null &&
                                            hcpProvider.campaignInfo!.endDate!
                                                .isAfter(DateTime.now())
                                        ? hcpProvider.campaignInfo!.endDate!
                                            .difference(DateTime.now())
                                        : const Duration(seconds: 1),
                                    style: TextStyle(
                                        color: cc.blackColor.withOpacity(.6),
                                        fontWeight: FontWeight.bold),
                                  )),
                                ],
                              ),
                            ),
                            EmptySpaceHelper.emptyHight(15),
                            ProductSlider(hcpProvider.homeCampaignProductsList)
                          ],
                        ),
                      )
                    : const SizedBox()
                : Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: HomePageTitleSkeleton(),
                      ),
                      EmptySpaceHelper.emptyHight(10),
                      SizedBox(
                        height: 260,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return ProductCardSkeleton();
                            },
                            separatorBuilder: (context, index) =>
                                EmptySpaceHelper.emptywidth(20),
                            itemCount: 5),
                      ),
                    ],
                  );
          });
    });
  }
}
