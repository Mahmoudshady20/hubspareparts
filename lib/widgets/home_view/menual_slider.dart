import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../helpers/empty_space_helper.dart';
import '../../services/slider_service.dart';
import '../skelletons/slider_two_skeleton.dart';
import 'slider_two.dart';

class ManualSlider extends StatelessWidget {
  const ManualSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderService>(builder: (context, sProvider, child) {
      return SizedBox(
        child: FutureBuilder(
          future: sProvider.sliderTwoList == null && !sProvider.sliderTwoLoading
              ? sProvider.fetchSliderTwo(context)
              : null,
          builder: (context, snapshot) {
            return !sProvider.sliderTwoLoading &&
                    sProvider.sliderTwoList != null
                ? sProvider.sliderTwoList!.isNotEmpty
                    ? SizedBox(
                        height: 180,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemBuilder: (context, index) {
                              final element = sProvider.sliderTwoList![index];
                              return SliderTwo(
                                element.title,
                                element.description,
                                element.buttonText,
                                element.image,
                                index,
                                capm: element.campaign,
                                cat: element.category,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                EmptySpaceHelper.emptywidth(20),
                            itemCount: sProvider.sliderTwoList!.length),
                      )
                    : const SizedBox()
                : SizedBox(
                    height: 180,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemBuilder: (context, index) => SliderTwoSkeleton(),
                        separatorBuilder: (context, index) =>
                            EmptySpaceHelper.emptywidth(20),
                        itemCount: 7),
                  );
          },
        ),
      );
    });
  }

  Future delay() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
