import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/submit_review_service.dart';
import '../../utils/responsive.dart';
import '../common/custom_common_button.dart';

class WriteReview extends StatelessWidget {
  final id;
  const WriteReview(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: cc.whiteGrey),
      child:
          Consumer<SubmitReviewService>(builder: (context, srProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.your_rating,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: cc.greyParagraph)),
            const SizedBox(height: 10),
            RatingBar.builder(
              // ignoreGestures: true,
              itemSize: 17,
              initialRating: srProvider.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 3,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1),
              itemBuilder: (context, _) => SvgPicture.asset(
                'assets/icons/star.svg',
                color: cc.orangeRating,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                srProvider.setRating(rating);
              },
            ),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.your_review,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: cc.greyParagraph)),
            const SizedBox(height: 10),
            SizedBox(
              height: screenHeight / 7,
              child: TextFormField(
                maxLines: 4,
                initialValue: srProvider.reviewText,
                decoration: InputDecoration(
                  isDense: true,
                  hintText:AppLocalizations.of(context)!.write_your_feedback,
                ),
                onChanged: (value) => srProvider.setReviewText(value),
              ),
            ),
            const SizedBox(height: 30),
            CustomCommonButton(
              btText: AppLocalizations.of(context)!.submit,
              isLoading: srProvider.loadingSubmitReview,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (srProvider.reviewText.trim().isEmpty) {
                  showToast(AppLocalizations.of(context)!.write_your_feedback,
                      cc.red);
                  return;
                }
                srProvider.submitReview(context, id);
              },
              width: double.infinity,
            ),
            EmptySpaceHelper.emptyHight(10),
          ],
        );
      }),
    ));
  }
}
