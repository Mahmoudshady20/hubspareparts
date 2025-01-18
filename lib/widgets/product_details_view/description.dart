import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/empty_space_helper.dart';

import '../../services/product_details_service.dart';

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return Container(
        //Dropdown
        margin: const EdgeInsets.only(bottom: 20, top: 8),
        child: Column(
          children: [
            HtmlWidget(pdProvider.productDetails!.description ?? ''),
            EmptySpaceHelper.emptyHight(20),
            // Text(
            //   'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.',
            //   style: Theme.of(context)
            //       .textTheme
            //       .subtitle1!
            //       .copyWith(color: cc.greyParagraph),
            // )
          ],
          // ))),
        ),
      );
    });
  }
}
