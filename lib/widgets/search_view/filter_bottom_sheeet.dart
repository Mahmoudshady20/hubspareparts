import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/services/search_product_service.dart';
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
  const FilterBottomSheet(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rtl = Provider.of<RTLService>(context, listen: false);

    MoneyFormatter startRange = MoneyFormatter(
        amount: Provider.of<SearchFilterDataService>(context, listen: false)
            .minPrice);
    MoneyFormatter endRange = MoneyFormatter(
        amount: Provider.of<SearchFilterDataService>(context, listen: false)
            .maxPrice);
    final filterOption =
        Provider.of<SearchFilterDataService>(context, listen: false);
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

        if (filterOption.filterOprions?.allCategory != null &&
            filterOption.filterOprions!.allCategory!.isNotEmpty)
          FilterRtlPadding(
            child: Text(
              AppLocalizations.of(context)!.categories,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (filterOption.filterOprions?.allCategory != null &&
            filterOption.filterOprions!.allCategory!.isNotEmpty)
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
                  itemCount: foProvider.filterOprions!.allCategory!.length,
                  itemBuilder: ((context, index) {
                    final category =
                        foProvider.filterOprions!.allCategory![index];
                    // print(e.title);
                    final isSelected =
                        category.name.toString() == foProvider.selectedCategory;
                    return GestureDetector(
                        onTap: () {
                          foProvider.setSelectedCategory(category.name);
                          // if (isSelected) {
                          //   catData.setSelectedCategory('');
                          //   catData.setSelectedSubCategory('');
                          //   return;
                          // }
                          // catData.setSelectedCategory(e.id.toString());
                        },
                        child: filterOptions(category.name, isSelected));
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
                            asProvider.getString('No sub-category available'),
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
                            asProvider.getString('No sub-category available'),
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
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          filterOption.setSelectedColor(filterOption
                              .filterOprions!.allColors![index].name);
                        },
                        child: filterColorOption(
                          filterOption
                              .filterOprions!.allColors![index].colorCode!,
                          spProvider.selectedColor ==
                              filterOption
                                  .filterOprions!.allColors![index].name,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        EmptySpaceHelper.emptywidth(5),
                    itemCount: filterOption.filterOprions!.allColors!.length),
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
        if (filterOption.filterOprions?.allBrands?.isNotEmpty ?? false)
          FilterRtlPadding(
            child: Text(
              AppLocalizations.of(context)!.brands,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (filterOption.filterOprions?.allBrands?.isNotEmpty ?? false)
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
                              .filterOprions!.allBrands![index].name);
                          print(
                            spProvider.selectedBrand ==
                                filterOption
                                    .filterOprions!.allBrands![index].name,
                          );
                        },
                        child: filterOptions(
                          filterOption.filterOprions!.allBrands![index].name,
                          filterOption.selectedBrand ==
                              filterOption
                                  .filterOprions!.allBrands![index].name,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        EmptySpaceHelper.emptywidth(5),
                    itemCount: filterOption.filterOprions!.allBrands!.length),
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
                FieldTitle(AppLocalizations.of(context)!.filter_Price),
                Consumer<SearchFilterDataService>(
                    builder: (context, sfdProvider, child) {
                  return Text(
                    rtl.curRtl
                        ? '${MoneyFormatter(amount: sfdProvider.selectedMinPrice ?? sfdProvider.minPrice).output.withoutFractionDigits}${rtl.currency}-${MoneyFormatter(amount: sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice).output.withoutFractionDigits}${rtl.currency}'
                        : '${rtl.currency}${MoneyFormatter(amount: sfdProvider.selectedMinPrice ?? sfdProvider.minPrice).output.withoutFractionDigits}-${rtl.currency}${MoneyFormatter(amount: sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice).output.withoutFractionDigits}',
                  );
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
                    sfdProvider.selectedMinPrice ?? sfdProvider.minPrice,
                    sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice),
                max:
                    Provider.of<SearchFilterDataService>(context, listen: false)
                        .maxPrice,
                min:
                    Provider.of<SearchFilterDataService>(context, listen: false)
                        .minPrice,
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
            child: FieldTitle(AppLocalizations.of(context)!.average_Rating)),
        const SizedBox(height: 10),
        // for (var i = 0; i < 5; i++)
        //   FilterRtlPadding(
        //       child: RatingOptions(i, i == fProvider.selectedRating,
        //           fProvider.ratingOptions[i], () {
        //     fProvider.setSelectedRating(i);
        //   })),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Consumer<SearchFilterDataService>(
                builder: (context, sfProvider, child) {
              return RatingBar.builder(
                itemSize: 24,
                initialRating: sfProvider.selectedRating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                unratedColor: cc.lightPrimary,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                itemBuilder: (context, _) => SvgPicture.asset(
                  'assets/icons/star.svg',
                  color: cc.orangeRating,
                ),
                onRatingUpdate: (rating) {
                  sfProvider.setSelectedRating(rating.toInt());
                  print(rating);
                },
              );
            }),
            const Spacer(),
            Consumer<SearchFilterDataService>(
              builder: (context, sfProvider, child) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      sfProvider.setSelectedRating(0);
                    },
                    child: Icon(
                      Icons.refresh_rounded,
                      color: cc.primaryColor,
                    ),
                  ),
                );
              },
            )
          ]),
        ),

        EmptySpaceHelper.emptyHight(20),

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
                  Provider.of<SearchProductService>(context, listen: false)
                      .setFilterOptions(
                    catVal: filterOption.selectedCategory,
                    subCatVal: filterOption.selectedSubCategory,
                    childCatVal: filterOption.selectedChildCats,
                    colorVal: filterOption.selectedColor,
                    sizeVal: filterOption.selectedSize,
                    brandVal: filterOption.selectedBrand,
                    minPrice: filterOption.selectedMinPrice.toString(),
                    maxPrice: filterOption.selectedMaxPrice.toString(),
                    rating: filterOption.selectedRating,
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
