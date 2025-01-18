import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/common/product_slider.dart';

import '../../services/product_details_service.dart';

class SellersProducts extends StatelessWidget {
  const SellersProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return Provider.of<ProductDetailsService>(context, listen: false)
                      .productDetails!
                      .vendor ==
                  null ||
              pdProvider.vendor!.product == null ||
              pdProvider.vendor!.product!.isEmpty
          ? const SizedBox()
          : ProductSlider(pdProvider.vendor!.product);
    });
  }
}
