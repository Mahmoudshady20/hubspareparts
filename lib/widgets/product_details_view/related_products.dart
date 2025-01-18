import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/common/product_slider.dart';

import '../../services/product_details_service.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return pdProvider.relatedProduct.isEmpty
          ? const SizedBox()
          : ProductSlider(
              pdProvider.relatedProduct,
              shouldPop: true,
            );
    });
  }
}
