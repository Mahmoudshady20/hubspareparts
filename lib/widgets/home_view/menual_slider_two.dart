import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/home_view/slider_three.dart';

import '../../helpers/empty_space_helper.dart';
import '../../services/slider_service.dart';
import '../skelletons/slider_two_skeleton.dart';

class ManualSliderTwo extends StatelessWidget {
  const ManualSliderTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderService>(builder: (context, sProvider, child) {
      return SizedBox(
        child: FutureBuilder(
          future:
              sProvider.sliderThreeList == null && !sProvider.sliderThreeLoading
                  ? sProvider.fetchSliderThree(context)
                  : null,
          builder: (context, snapshot) {
            return !sProvider.sliderThreeLoading &&
                    sProvider.sliderThreeList != null
                ? sProvider.sliderThreeList!.isNotEmpty
                    ? SizedBox(
                        height: 180,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemBuilder: (context, index) {
                              final element = sProvider.sliderThreeList![index];
                              return SliderThree(
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
                            itemCount: sProvider.sliderThreeList!.length),
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
