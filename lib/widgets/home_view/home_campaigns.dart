import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/feature_products_service.dart';
import 'package:safecart/services/product_by_campaigns_service.dart';
import 'package:safecart/views/home_campaigns_view.dart';
import 'package:safecart/views/product_by_campaign_view.dart';
import 'package:safecart/widgets/home_view/campaign_card.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/home_campaigns_service.dart';
import '../common/title_common.dart';
import '../skelletons/homepage_title_skeleton.dart';
import '../skelletons/product_card_skeleton.dart';

class HomeCampaigns extends StatelessWidget {
  const HomeCampaigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCampaignsService>(
        builder: (context, hcProvider, child) {
      return Column(
        children: [
          Consumer<HomeCampaignsService>(builder: (context, hcProvider, child) {
            return !hcProvider.campaignLoading
                ? hcProvider.campaigns != null &&
                        hcProvider.campaigns!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TitleCommon(
                          asProvider.getString('Campaigns'),
                          () {
                            Navigator.of(context)
                                .pushNamed(HomeCampaignsView.routeName);
                          },
                          seeAll: true,
                        ),
                      )
                    : const SizedBox()
                : const HomePageTitleSkeleton();
          }),
          Consumer<HomeCampaignsService>(builder: (context, hcProvider, child) {
            return !hcProvider.campaignLoading
                ? hcProvider.campaigns != null &&
                        hcProvider.campaigns!.isNotEmpty
                    ? EmptySpaceHelper.emptyHight(10)
                    : const SizedBox()
                : EmptySpaceHelper.emptyHight(10);
          }),
          FutureBuilder(
            future: hcProvider.campaigns == null && !hcProvider.campaignLoading
                ? hcProvider.fetchHomeCampaigns(context)
                : null,
            builder: (context, snapshot) {
              return !hcProvider.campaignLoading && hcProvider.campaigns != null
                  ? hcProvider.campaigns!.isNotEmpty
                      ? SizedBox(
                          height: 195,
                          child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemBuilder: (context, index) {
                                final element = hcProvider.campaigns![index]!;
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<ProductByCampaignsService>(
                                            context,
                                            listen: false)
                                        .clearProductByCampaignData();
                                    Navigator.of(context).pushNamed(
                                        ProductByCampaignView.routeName,
                                        arguments: [element.title, element.id]);
                                  },
                                  child: CampaignCard(
                                      element.title!,
                                      element.subtitle!,
                                      element.image,
                                      element.endDate != null &&
                                              element.endDate!
                                                  .isAfter(DateTime.now())
                                          ? element.endDate!
                                              .difference(DateTime.now())
                                          : const Duration(seconds: 1)),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  EmptySpaceHelper.emptywidth(20),
                              itemCount: hcProvider.campaigns!.length),
                        )
                      : const SizedBox()
                  : SizedBox(
                      height: 195,
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
                          itemCount: 3),
                    );
            },
          ),
          Consumer<FeatureProductsService>(
              builder: (context, hcProvider, child) {
            return !hcProvider.featureProductsLoading
                ? const SizedBox()
                : EmptySpaceHelper.emptyHight(15);
          }),
        ],
      );
    });
  }
}
