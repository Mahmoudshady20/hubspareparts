import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:safecart/services/home_campaigns_service.dart';
import 'package:safecart/widgets/home_view/campaign_card.dart';

import '../helpers/common_helper.dart';
import '../services/product_by_campaigns_service.dart';
import '../widgets/common/custom_app_bar.dart';
import 'product_by_campaign_view.dart';

class HomeCampaignsView extends StatelessWidget {
  static const routeName = 'home_campaigns_view';
  HomeCampaignsView({super.key});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    return Scaffold(
      appBar: CustomAppBar()
          .appBarTitled(context, asProvider.getString('Campaigns'), () {
        Navigator.of(context).pop();
      }),
      body: Column(
        children: [
          Expanded(
            child: Consumer<HomeCampaignsService>(
                builder: (context, hcProvider, child) {
              return SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: const FlutterzillaFixedGridView(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        height: 195),
                    itemCount: hcProvider.campaigns!.length,
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final element = hcProvider.campaigns![index]!;
                      return GestureDetector(
                          onTap: () {
                            Provider.of<ProductByCampaignsService>(context,
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
                                    element.endDate!.isAfter(DateTime.now())
                                ? element.endDate!.difference(DateTime.now())
                                : const Duration(seconds: 1),
                          ));
                    },
                  ));
            }),
          ),
          // if (saProvider.nextLoading)
          //   Padding(
          //     padding: const EdgeInsets.only(bottom: 10),
          //     child: CustomPreloader(),
          //   ),
        ],
      ),
    );
  }

  scrollListener(BuildContext context) async {
    // if (controller.offset >= controller.position.maxScrollExtent &&
    //     !controller.position.outOfRange) {
    //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //   Provider.of<SearchProductService>(context, listen: false)
    //       .setNextLoading(true);
    //   await Future.delayed(const Duration(seconds: 1));
    //   Provider.of<SearchProductService>(context, listen: false)
    //       .setNextLoading(false);
    //   // Provider.of<SearchResultDataService>(context, listen: false)
    //   //     .setIsLoading(true);

    //   // Provider.of<SearchResultDataService>(context, listen: false)
    //   //     .fetchProductsBy(
    //   //         pageNo:
    //   //             Provider.of<SearchResultDataService>(context, listen: false)
    //   //                 .pageNumber
    //   //                 .toString())
    //   //     .then((value) {
    //   //   if (value != null) {
    //   //     snackBar(context, value);
    //   //   }
    //   // });
    //   // Provider.of<SearchResultDataService>(context, listen: false).nextPage();
    //   showToast(asProvider.getString('No more product found'), cc.red);
    // }
  }
}
