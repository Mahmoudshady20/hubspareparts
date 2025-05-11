import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../services/product_by_campaigns_service.dart';
import '../../services/rtl_service.dart';
import '../../services/search_product_service.dart';
import '../../services/settings_services.dart';
import '../../utils/responsive.dart';
import '../../views/product_by_campaign_view.dart';
import '../../views/product_by_category_view.dart';
import '../common/custom_common_button.dart';

class SliderThree extends StatelessWidget {
  String title;
  String subTitle;
  String btText;
  String image;
  int index;
  var capm;
  var cat;
  SliderThree(this.title, this.subTitle, this.btText, this.image, this.index,
      {this.capm, this.cat, super.key});

  List colors1 = [
    const Color(0xffFFECF0),
    const Color(0xffE9F6FF),
    const Color(0xffF2F3F5),
  ];
  List colors2 = [
    const Color(0xffFFE3F0),
    const Color(0xffD6EFFF),
    const Color(0xffF2F3F5),
  ];

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    final rtl = Provider.of<RTLService>(context, listen: false).langRtl;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 20),
      height: 180,
      width: screenWidth / 1.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: colors1[index % colors1.length],
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth / 2,
                    child: Text(
                      subTitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: cc.blackColor,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: screenWidth / 2,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: rtl ? 0 : 0,
                          right: rtl ? 0 : 0,
                        ),
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: cc.blackColor,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          maxLines: 1,
                        ),
                      )),
                  if (capm != null || cat != null) const SizedBox(height: 10),
                  if (capm != null || cat != null)
                    CustomCommonButton(
                      btText: btText,
                      isLoading: false,
                      height: 38,
                      width: screenWidth / 4,
                      onPressed: () {
                        if (capm != null) {
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
                    )
                ],
              ),
            ),
            Align(
              alignment: settingsProvider.myLocal == Locale('ar')
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                height: 180,
                width: screenWidth / 2.5,
                margin: const EdgeInsets.only(top: 0),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(20)),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                    alignment: settingsProvider.myLocal == Locale('ar')
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
