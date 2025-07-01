import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/services/search_product_service.dart';
import 'package:safecart/services/settings_services.dart';
import 'package:safecart/utils/custom_row_button.dart';
import 'package:safecart/utils/responsive.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/common_services.dart';
import '../../services/rtl_service.dart';
import '../common/field_title.dart';
import 'filter_rtl_padding.dart';

class FilterBottomSheet extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const FilterBottomSheet(this.scaffoldKey, {super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Provider.of<RTLService>(context, listen: false);
    final filterOption =
        Provider.of<SearchFilterDataService>(context, listen: false);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        EmptySpaceHelper.emptyHight(MediaQuery.of(context).padding.top + 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.filter,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        if (filterOption.filterCategory?.categories != null &&
            filterOption.filterCategory!.categories!.isNotEmpty)
          FilterRtlPadding(
            child: Text(
              AppLocalizations.of(context)!.categories,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (filterOption.filterCategory?.categories != null &&
            filterOption.filterCategory!.categories!.isNotEmpty)
          Consumer<SearchFilterDataService>(
              builder: (context, foProvider, child) {
            return SizedBox(
              height: 44,
              child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: rtl.langRtl ? 0 : 25.0,
                    right: rtl.langRtl ? 25 : 0,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: foProvider.filterCategory!.categories!.length,
                  itemBuilder: ((context, index) {
                    final category =
                        foProvider.filterCategory!.categories![index];
                    // print(e.title);
                    final isSelected =
                        category.name_en.toString() == foProvider.selectedCategory;
                    return GestureDetector(
                        onTap: () {
                          foProvider.setSelectedCategory(category.name_en);
                          // if (isSelected) {
                          //   catData.setSelectedCategory('');
                          //   catData.setSelectedSubCategory('');
                          //   return;
                          // }
                          // catData.setSelectedCategory(e.id.toString());
                        },
                        child: filterOptions(settingsProvider.myLocal == Locale('ar') ? category.name_ar ?? '' : category.name_en ?? '', isSelected));
                  })),
            );
          }),
        Consumer<SearchFilterDataService>(
            builder: (context, foProvider, child) {
          return foProvider.selectedCategory != null &&
                  foProvider.selectedCategory != ''
              ? FilterRtlPadding(
                  child: Text(
                    AppLocalizations.of(context)!.sub_Category,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: cc.greyParagraph),
                  ),
                )
              : const SizedBox();
        }),
        Consumer<SearchFilterDataService>(
            builder: (context, foProvider, child) {
          return foProvider.selectedCategory != null &&
                  foProvider.selectedCategory != ''
              ? foProvider.selectedCategorySubList.isNotEmpty
                  ? SizedBox(
                      height: 44,
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: rtl.langRtl ? 0 : 25.0,
                            right: rtl.langRtl ? 25 : 0,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: foProvider.selectedCategorySubList.length,
                          itemBuilder: ((context, index) {
                            final subcategory =
                                foProvider.selectedCategorySubList[index];
                            // print(e.title);
                            final isSelected = subcategory.name.toString() ==
                                foProvider.selectedSubCategory;
                            return GestureDetector(
                                onTap: () {
                                  foProvider
                                      .setSelectedSubCategory(subcategory.name);
                                  // if (isSelected) {
                                  //   catData.setSelectedCategory('');
                                  //   catData.setSelectedSubCategory('');
                                  //   return;
                                  // }
                                  // catData.setSelectedCategory(e.id.toString());
                                },
                                child: filterOptions(
                                    subcategory.name, isSelected));
                          })))
                  : FilterRtlPadding(
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!
                                .no_sub_category_available,
                            style: TextStyle(color: cc.greyHint, fontSize: 14),
                          )),
                    )
              : const SizedBox();
        }),
        Consumer<SearchFilterDataService>(
            builder: (context, foProvider, child) {
          return foProvider.selectedSubCategory != null &&
                  foProvider.selectedSubCategory != ''
              ? FilterRtlPadding(
                  child: Text(
                    AppLocalizations.of(context)!.child_Category,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: cc.greyParagraph),
                  ),
                )
              : const SizedBox();
        }),
        Consumer<SearchFilterDataService>(
            builder: (context, foProvider, child) {
          return foProvider.selectedSubCategory != null &&
                  foProvider.selectedSubCategory != ''
              ? foProvider.selectedSubcategoryChildList.isNotEmpty
                  ? SizedBox(
                      height: 44,
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: rtl.langRtl ? 0 : 25.0,
                            right: rtl.langRtl ? 25 : 0,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              foProvider.selectedSubcategoryChildList.length,
                          itemBuilder: ((context, index) {
                            final childCategory =
                                foProvider.selectedSubcategoryChildList[index];
                            // print(e.title);
                            final isSelected = childCategory.name.toString() ==
                                foProvider.selectedChildCats;
                            return GestureDetector(
                                onTap: () {
                                  foProvider
                                      .setSelectedChildCats(childCategory.name);
                                  // if (isSelected) {
                                  //   catData.setSelectedCategory('');
                                  //   catData.setSelectedSubCategory('');
                                  //   return;
                                  // }
                                  // catData.setSelectedCategory(e.id.toString());
                                },
                                child: filterOptions(
                                    childCategory.name, isSelected));
                          })))
                  : FilterRtlPadding(
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!
                                .no_sub_category_available,
                            style: TextStyle(color: cc.greyHint, fontSize: 14),
                          )),
                    )
              : const SizedBox();
        }),
        if (filterOption.filterOprions?.allColors?.isNotEmpty ?? false)
          FilterRtlPadding(
            child: Text(
              AppLocalizations.of(context)!.color,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (filterOption.filterOprions?.allColors?.isNotEmpty ?? false)
          Consumer<SearchFilterDataService>(
              builder: (context, spProvider, child) {
            return FilterRtlPadding(
              child: SizedBox(
                height: 44,
                child: Container(),
              ),
            );
          }),
        if (filterOption.filterOprions?.allSizes?.isNotEmpty ?? false)
          FilterRtlPadding(
            child: Text(
              AppLocalizations.of(context)!.size,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (filterOption.filterOprions?.allSizes?.isNotEmpty ?? false)
          Consumer<SearchFilterDataService>(
              builder: (context, spProvider, child) {
            return FilterRtlPadding(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          filterOption.setSelectedSize(filterOption
                              .filterOprions!.allSizes![index].name);
                        },
                        child: filterOptions(
                          filterOption.filterOprions!.allSizes![index].name!,
                          spProvider.selectedSize ==
                              filterOption.filterOprions!.allSizes![index].name,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        EmptySpaceHelper.emptywidth(5),
                    itemCount: filterOption.filterOprions!.allSizes!.length),
              ),
            );
          }),
        if (filterOption.filterCategory?.brands?.isNotEmpty ?? false)
          FilterRtlPadding(
            child: Text(
              AppLocalizations.of(context)!.brands,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (filterOption.filterCategory?.brands?.isNotEmpty ?? false)
          Consumer<SearchFilterDataService>(
              builder: (context, spProvider, child) {
            return FilterRtlPadding(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          filterOption.setSelectedBrand(filterOption
                              .filterCategory!.brands![index].name);
                        },
                        child: filterOptions(
                          filterOption.filterCategory!.brands![index].name ?? '',
                          filterOption.selectedBrand ==
                              filterOption
                                  .filterCategory!.brands![index].name,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        EmptySpaceHelper.emptywidth(5),
                    itemCount: filterOption.filterCategory!.brands!.length),
              ),
            );
          }),
        Consumer<SearchFilterDataService>(
            builder: (context, sfdProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FieldTitle(AppLocalizations.of(context)!.current_rating),
                Consumer<SearchFilterDataService>(
                    builder: (context, sfdProvider, child) {
                  return Text(
                      '${sfdProvider.selectedMinCurrentRatings?.toInt() ?? sfdProvider.minCurrentRatings.toInt()}-${sfdProvider.selectedMaxCurrentRatings?.toInt() ?? sfdProvider.filterCategory?.currentRating?.max?.toInt()}');
                })
              ],
            ),
          );
        }),
        Consumer<SearchFilterDataService>(
            builder: (context, sfdProvider, child) {
          return Consumer<CommonServices>(builder: (context, srData, child) {
            return SliderTheme(
              data: SliderThemeData(
                rangeThumbShape: const RoundRangeSliderThumbShape(
                    elevation: 1, enabledThumbRadius: 10),
                thumbColor: cc.pureWhite,
                disabledThumbColor: cc.pureWhite,
                activeTrackColor: cc.primaryColor,
                trackHeight: 10,
              ),
              child: RangeSlider(
                values: RangeValues(
                    sfdProvider.selectedMinCurrentRatings ??
                        sfdProvider.filterCategory?.currentRating?.min
                            ?.toDouble() ??
                        0.0,
                    sfdProvider.selectedMaxCurrentRatings ??
                        sfdProvider.filterCategory?.currentRating?.max
                            ?.toDouble() ??
                        1600.0),
                max: sfdProvider.filterCategory?.currentRating?.max
                        ?.toDouble() ??
                    1600.0,
                min: sfdProvider.filterCategory?.currentRating?.min
                        ?.toDouble() ??
                    0.0,
                inactiveColor: cc.lightPrimary10,
                labels: const RangeLabels('44', '55'),
                onChanged: (RangeValues values) {
                  sfdProvider.setRangeValues(values);
                },
              ),
            );
          });
        }),
        FilterRtlPadding(
            child: FieldTitle(AppLocalizations.of(context)!.voltage_rating)),
        const SizedBox(height: 10),
        // for (var i = 0; i < 5; i++)
        //   FilterRtlPadding(
        //       child: RatingOptions(i, i == fProvider.selectedRating,
        //           fProvider.ratingOptions[i], () {
        //     fProvider.setSelectedRating(i);
        //   })),
        FilterRtlPadding(
          child: Consumer<SearchFilterDataService>(
              builder: (context, sfProvider, child) {
            return SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sfProvider.filterCategory!.voltageRating!.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      sfProvider.setSelectedVoltageRating(sfProvider
                          .filterCategory?.voltageRating![index].id as int?);
                    },
                    child: filterOptions(
                        sfProvider.filterCategory?.voltageRating?[index].name ??
                            '',
                        sfProvider.voltageRatingById ==
                            sfProvider
                                .filterCategory?.voltageRating![index].id),
                  );
                }),
                separatorBuilder: (context, index) =>
                    EmptySpaceHelper.emptywidth(5),
              ),
            );
          }),
        ),
        EmptySpaceHelper.emptyHight(20),
        FilterRtlPadding(
            child: FieldTitle(AppLocalizations.of(context)!.control_voltage)),
        const SizedBox(height: 10),
        FilterRtlPadding(
          child: Consumer<SearchFilterDataService>(
              builder: (context, sfProvider, child) {
            return SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sfProvider.filterCategory!.controlVoltage!.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      sfProvider.setControlVoltageById(sfProvider
                          .filterCategory?.controlVoltage![index].id as int?);
                    },
                    child: filterOptions(
                        sfProvider
                                .filterCategory?.controlVoltage?[index].name ??
                            '',
                        sfProvider.controlVoltageById ==
                            sfProvider
                                .filterCategory?.controlVoltage![index].id),
                  );
                }),
                separatorBuilder: (context, index) =>
                    EmptySpaceHelper.emptywidth(5),
              ),
            );
          }),
        ),
        EmptySpaceHelper.emptyHight(20),
        FilterRtlPadding(
            child: FieldTitle(AppLocalizations.of(context)!.power_rating)),
        const SizedBox(height: 10),
        FilterRtlPadding(
          child: Consumer<SearchFilterDataService>(
              builder: (context, sfProvider, child) {
            return SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sfProvider.filterCategory!.powerRating!.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      sfProvider.setPowerRatingById(sfProvider
                          .filterCategory?.powerRating![index].id as int?);
                    },
                    child: filterOptions(
                        sfProvider.filterCategory?.powerRating?[index].name ??
                            '',
                        sfProvider.powerRatingById ==
                            sfProvider.filterCategory?.powerRating![index].id),
                  );
                }),
                separatorBuilder: (context, index) =>
                    EmptySpaceHelper.emptywidth(5),
              ),
            );
          }),
        ),
        const SizedBox(height: 40),
        Consumer<CommonServices>(builder: (context, srData, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: CustomRowButton(
                width: (screenWidth / 1.2) / 2.3,
                bt1text: AppLocalizations.of(context)!.reset_Filter,
                bt2text: AppLocalizations.of(context)!.apply_Filter,
                bt1func: () {
                  scaffoldKey.currentState!.closeEndDrawer();
                  Provider.of<SearchProductService>(context, listen: false)
                      .resetFilterOptions();
                  Provider.of<SearchFilterDataService>(context, listen: false)
                      .resetSelectedSearchFilter();
                  Provider.of<SearchProductService>(context, listen: false)
                      .fetchProducts(context);
                  // filterReset(context, srData);
                },
                bt2func: () {
                  scaffoldKey.currentState!.closeEndDrawer();
                  String? v, c, p;
                  if (filterOption.voltageRatingById == null) {
                    v = '';
                  } else {
                    v = filterOption.voltageRatingById.toString();
                  }
                  if (filterOption.powerRatingById == null) {
                    p = '';
                  } else {
                    p = filterOption.powerRatingById.toString();
                  }
                  if (filterOption.controlVoltageById == null) {
                    c = '';
                  } else {
                    c = filterOption.controlVoltageById.toString();
                  }
                  Provider.of<SearchProductService>(context, listen: false)
                      .setFilterOptions(
                    catVal: filterOption.selectedCategory,
                    subCatVal: filterOption.selectedSubCategory,
                    childCatVal: filterOption.selectedChildCats,
                    colorVal: filterOption.selectedColor,
                    sizeVal: filterOption.selectedSize,
                    brandVal: filterOption.selectedBrand,
                    minPrice: filterOption.selectedMinCurrentRatings,
                    maxPrice: filterOption.selectedMaxCurrentRatings,
                    controlVoltageByIdFun: c,
                    powerRatingByIdFun: p,
                    voltageRatingByIdFun: v,
                    selectedMaxCurrentRatingsFun:
                        filterOption.selectedMaxCurrentRatings,
                    selectedMinCurrentRatingsFun:
                        filterOption.selectedMinCurrentRatings,
                  );
                  Provider.of<SearchProductService>(context, listen: false)
                      .fetchProducts(context);
                  // filterApply(context, srData);
                }),
          );
        }),
        EmptySpaceHelper.emptyHight(30),
      ]),
    );
  }

  Widget filterOptions(
    String text,
    bool isSelected,
  ) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? cc.primaryColor : cc.greyBorder,
            width: 1,
          ),
          color: isSelected ? cc.primaryColor : cc.pureWhite),
      child: FittedBox(
        child:
            //  Row(children: [
            Text(
          text,
          style: TextStyle(color: isSelected ? cc.pureWhite : cc.blackColor),
        ),
        //   const SizedBox(width: 5),
        // ]),
      ),
    );
  }

  Widget filterColorOption(
    String text,
    bool isSelected,
  ) {
    final color = text.replaceAll('#', '0xff');
    return Container(
      height: 20,
      width: 40,
      alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(int.parse(color))),
      child: isSelected
          ? Icon(
              Icons.done,
              color: cc.pureWhite,
              size: 18,
            )
          : null,
    );
  }
}
