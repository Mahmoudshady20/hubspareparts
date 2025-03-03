// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/feature_products_service.dart';
import 'package:safecart/services/home_campaign_products_service.dart';
import 'package:safecart/utils/custom_refresh_indicator.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/home_view/auto_slider.dart';
import 'package:safecart/widgets/home_view/categories_and_products.dart';
import 'package:safecart/widgets/home_view/feature_products.dart';
import 'package:safecart/widgets/home_view/home_campaign_products.dart';
import 'package:safecart/widgets/home_view/home_campaigns.dart';
import 'package:safecart/widgets/home_view/menual_slider.dart';
import 'package:safecart/widgets/home_view/menual_slider_two.dart';

import '../helpers/empty_space_helper.dart';
import '../services/home_campaigns_service.dart';
import '../services/home_categories_service.dart';
import '../services/slider_service.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight - 130,
      child: CustomRefreshIndicator(
        onRefresh: () async {
          await Provider.of<HomeCategoriesService>(context, listen: false)
              .fetchHomeCategories(context, refreshing: true);
          await Provider.of<SliderService>(context, listen: false)
              .fetchSliderOne(context);
          await Provider.of<FeatureProductsService>(context, listen: false)
              .fetchFeatureProducts(context, refreshing: true);
          await Provider.of<SliderService>(context, listen: false)
              .fetchSliderTwo(context, refreshing: true);
          await Provider.of<HomeCategoriesService>(context, listen: false)
              .fetchHomeCategoryProducts(null, refreshing: true);
          await Provider.of<SliderService>(context, listen: false)
              .fetchSliderThree(context, refreshing: true);
          await Provider.of<HomeCampaignProductsService>(context, listen: false)
              .fetchHomeCampaignProducts(context, refreshing: true);
          await Provider.of<HomeCampaignsService>(context, listen: false)
              .fetchHomeCampaigns(context, refreshing: true);
          return true;
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //const Categories(),
            const AutoSlider(),
            const FeatureProducts(),
            const ManualSlider(),
            const CategoriesAndProducts(),
            const ManualSliderTwo(),
            EmptySpaceHelper.emptyHight(15),
            const HomeCampaignProducts(),
            const HomeCampaigns(),
            EmptySpaceHelper.emptyHight(screenHeight / 13),
          ],
        ),
      ),
    );
  }
}
