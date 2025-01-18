import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/empty_space_helper.dart';

import '../../helpers/common_helper.dart';
import '../../services/product_by_campaigns_service.dart';
import '../../services/rtl_service.dart';
import '../../services/search_product_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/views/product_by_campaign_view.dart';
import 'package:safecart/views/product_by_category_view.dart';
import '../common/custom_common_button.dart';

class SliderOne extends StatelessWidget {
  String title;
  String subTitle;
  String btText;
  String image;
  var capm;
  var cat;
  SliderOne(this.title, this.subTitle, this.btText, this.image,
      {this.capm, this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    final rtl = Provider.of<RTLService>(context, listen: false).langRtl;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.only(left: 20, right: 20),
      // height: 15,
      width: screenWidth / 5,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cc.sliderOneBackground,
      ),
      child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              // height: 150,
              width: double.infinity,
              margin: EdgeInsets.only(
                  right: rtl ? 0 : 3, left: rtl ? 3 : 0, bottom: 2, top: 15),
              child: Image.network(
                image,
                fit: BoxFit.contain,
                alignment: rtl ? Alignment.centerLeft : Alignment.centerRight,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth / 2.5,
                  child: Text(
                    subTitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: cc.primaryColor),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                    width: screenWidth / 2.5,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: rtl ? 0 : 0,
                        right: rtl ? 0 : 0,
                      ),
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: cc.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 2,
                      ),
                    )),
                EmptySpaceHelper.emptyHight(12),
                if (capm != null || cat != null) const SizedBox(height: 10),
                if (capm != null || cat != null)
                  CustomCommonButton(
                    onPressed: () {
                      if (capm != null) {
                        print('camp $capm');

                        Provider.of<ProductByCampaignsService>(context,
                                listen: false)
                            .clearProductByCampaignData();
                        Navigator.of(context).pushNamed(
                            ProductByCampaignView.routeName,
                            arguments: [title, capm.toString()]);
                        // Navigator.of(context).pushNamed(
                        //     ALLCampProductFromLink.routeName,
                        //     arguments: [capm.toString(), title]);
                      }

                      if (cat != null) {
                        print('cat $cat');
                        Provider.of<SearchProductService>(context,
                                listen: false)
                            .setFilterOptions(catVal: cat);
                        Provider.of<SearchProductService>(context,
                                listen: false)
                            .fetchProducts(context);
                        Navigator.of(context).pushNamed(
                            ProductByCategoryView.routeName,
                            arguments: [cat!]);
                      }
                    },
                    btText: btText,
                    isLoading: false,
                    height: 38,
                    width: screenWidth / 4,
                  )
              ],
            ),
          ]),
    );
  }
}
