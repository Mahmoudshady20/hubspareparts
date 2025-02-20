import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../services/product_details_service.dart';
import '../../services/rtl_service.dart';

class ProductAttribute extends StatelessWidget {
  const ProductAttribute({super.key});

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: pdProvider.inventoryKeys
                  .map((e) => Container(
                        alignment: rtlProvider.langRtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // if (e != "Color")
                              Text(e.replaceFirst('_', ' '),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: generateDynamicAttribute(
                                              context,
                                              pdProvider,
                                              e,
                                              pdProvider.allAttributes[e])))),
                            ],
                          ),
                        ),
                      ))
                  .toList()),
        ),
      );
    });
  }

  List<Widget> generateDynamicAttribute(BuildContext context,
      ProductDetailsService pdService, fieldName, mapData) {
    RegExp hex = RegExp(
        r'^#([\da-f]{3}){1,2}$|^#([\da-f]{4}){1,2}$|(rgb|hsl)a?\((\s*-?\d+%?\s*,){2}(\s*-?\d+%?\s*,?\s*\)?)(,\s*(0?\.\d+)?|1)?\)');
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    List<Widget> list = [];
    String value = '';
    final keys = mapData.keys;
    for (var element in keys) {
      // hex.hasMatch(element);
      dynamic colorCode;
      for (var e in pdService.productDetails!.color!) {
        if (e.name == element) {
          colorCode = e.colorCode;
        }
      }
      list.add(
        GestureDetector(
          onTap: () {
            if (pdService.selectedAttributes.contains(element)) {
              return;
            }
            if (!pdService.isInSet(fieldName, element, mapData[element])) {
              pdService.clearSelection();
            }
            pdService.setProductInventorySet(mapData[element]);
            value = element;
            manageInventorySet(pdService, element);
            pdService.addSelectedAttribute(element);
            pdService.addAdditionalPrice(context);
          },
          child: colorCode != null
              ? colorBox(
                  context,
                  pdService,
                  fieldName,
                  colorCode,
                  mapData,
                  element,
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: pdService.isASelected(element)
                      ? Curves.easeIn
                      : Curves.easeOut,
                  height: 38,
                  margin: EdgeInsets.only(
                      top: 3,
                      right: rtlProvider.langRtl ? 0 : 15,
                      left: rtlProvider.langRtl ? 15 : 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: pdService.isASelected(element)
                          ? cc.primaryColor
                          : cc.pureWhite,
                      border: Border.all(
                          color: !pdService.isInSet(
                                  fieldName, element, mapData[element])
                              ? cc.greyBorder
                              : pdService.isASelected(element)
                                  ? cc.primaryColor
                                  : cc.greyHint,
                          width: 1)),
                  child: Text(
                    element.toString().capitalize(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: !pdService.isInSet(
                                  fieldName, element, mapData[element])
                              ? cc.greyBorder
                              : pdService.isASelected(element)
                                  ? cc.pureWhite
                                  : cc.blackColor,
                        ),
                  ),
                ),
        ),
      );
    }
    return list;
  }

  manageInventorySet(
    ProductDetailsService pdService,
    selectedValue,
  ) {
    final selectedInventorySetIndex = pdService.selectedInventorySetIndex;
    final allAttributes = pdService.allAttributes;
    setProductInventorySet(List<String>? value) {
      // print(
      //     selectedInventorySetIndex.toString() + 'inven........................');
      // print(value.toString() + 'val........................');

      if (selectedInventorySetIndex != value) {
        // if (value!.length == 1) {
        //   selectedInventorySetIndex = value;selectedValue
        // print(selectedInventorySetIndex);
        for (var element in pdService.inventoryKeys) {
          if (selectedValue != null) {
            selectedValue = pdService.deselect(
                    value, allAttributes[element]![selectedValue])
                ? selectedValue
                : null;
          }
        }
      }
      if (selectedInventorySetIndex.isEmpty) {
        pdService.selectedInventorySetIndex = value ?? [];

        return;
      }
      if (selectedInventorySetIndex.isNotEmpty &&
          selectedInventorySetIndex.length > value!.length) {
        pdService.selectedInventorySetIndex = value;
        return;
      }
    }
  }

  Widget colorBox(BuildContext context, ProductDetailsService pdService,
      fieldName, value, mapData, element) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final color = value.replaceAll('#', '0xff');
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve:
              pdService.isASelected(element) ? Curves.easeIn : Curves.easeOut,
          height: 38,
          width: 38,
          margin: EdgeInsets.only(
              top: 7,
              right: rtlProvider.langRtl ? 4 : 17,
              left: rtlProvider.langRtl ? 17 : 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(int.parse(color)),
          ),
          child: pdService.isASelected(element)
              ? const Icon(
                  Icons.done,
                  color: Colors.white,
                )
              : null,
        ),
        if (!pdService.isInSet(fieldName, element, mapData[element]))
          Container(
            height: 38,
            width: 38,
            margin: EdgeInsets.only(
                top: 7,
                right: rtlProvider.langRtl ? 4 : 17,
                left: rtlProvider.langRtl ? 17 : 4),
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: Colors.white60,

              // child: const Text('element.color!.capitalize()'),
            ),
            child: Text(
              element,
              style: const TextStyle(color: Colors.transparent),
            ),
          )
      ],
    );
  }
}
