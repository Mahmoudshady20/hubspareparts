import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/settings_services.dart';

import '../../helpers/common_helper.dart';
import '../../services/product_by_campaigns_service.dart';
import '../../services/rtl_service.dart';
import '../../services/search_product_service.dart';
import '../../utils/responsive.dart';
import '../../views/product_by_campaign_view.dart';
import '../../views/product_by_category_view.dart';
import '../common/custom_common_button.dart';

class SliderTwo extends StatelessWidget {
  String title;
  String subTitle;
  String btText;
  String image;
  int index;
  var capm;
  var cat;
  SliderTwo(this.title, this.subTitle, this.btText, this.image, this.index,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      width: screenWidth / 1.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colors1[index % colors1.length],
        // image: DecorationImage(
        //   alignment: Alignment.centerRight,
        //   image: const AssetImage(
        //     'assets/images/slider_two_element.png',
        //   ),
        //   fit: BoxFit.fitHeight,
        // )
      ),
      child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Align(
              alignment: settingsProvider.myLocal == Locale('ar')
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: SizedBox(
                height: 180,
                width: screenWidth / 2.5,
                // margin: EdgeInsets.only(
                //     right: rtl ? 0 : 3, left: rtl ? 3 : 0, bottom: 2, top: 25),
                child: Image.network(
                  image,
                  fit: BoxFit.contain,
                  alignment: settingsProvider.myLocal == Locale('en')
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth / 2,
                  child: Text(
                    subTitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: cc.primaryColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: screenWidth / 2.5,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: rtl ? 0 : 0,
                        right: rtl ? 0 : 0,
                      ),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: cc.blackColor,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 2,
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
          ]),
    );
  }
}
