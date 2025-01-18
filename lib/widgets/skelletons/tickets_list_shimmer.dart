import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/common_services.dart';
import '../../services/rtl_service.dart';
import 'package:safecart/utils/responsive.dart';

class TicketTileSkeleton extends StatelessWidget {
  const TicketTileSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cc.greyBorder2),
        ),
        child: Column(
          children: [
            SizedBox(
                // height: 60,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Container(
                  height: 20,
                  width: screenWidth / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: cc.greyBorder,
                  ),
                ),
                const SizedBox(width: 10),
                const Spacer(),
              ],
            )),
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (screenWidth - 40) / 3.7,
                  child: Consumer<CommonServices>(
                      builder: (context, tService, child) {
                    return SizedBox(
                      height: 30,
                      child: FittedBox(
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: screenWidth / 7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: cc.greyBorder,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: EdgeInsets.only(
                                  left: rtlProvider.langRtl ? 0 : 7,
                                  right: rtlProvider.langRtl ? 7 : 0,
                                  top: 3,
                                  bottom: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: tService.priorityColor[priority],
                                color: cc.red,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'priority',
                                    style: TextStyle(
                                        color: cc.pureWhite,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: cc.pureWhite,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  height: 30,
                  width: (screenWidth - 40) / 3.7,
                  child: FittedBox(
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: screenWidth / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: cc.greyBorder,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.only(
                              left: rtlProvider.langRtl ? 0 : 7,
                              right: rtlProvider.langRtl ? 7 : 0,
                              top: 3,
                              bottom: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffC66060),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'open'.capitalize(),
                                style: TextStyle(
                                    color: cc.pureWhite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: cc.pureWhite,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 25,
                  width: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff17A2B8),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
