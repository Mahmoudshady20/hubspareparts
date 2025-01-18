import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../helpers/common_helper.dart';

class ReviewTile extends StatelessWidget {
  var profileImage;

  var userName;

  var rating;

  String reviewText;

  var createdAt;

  ReviewTile({
    required this.userName,
    required this.reviewText,
    required this.profileImage,
    required this.rating,
    required this.createdAt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        child: ListTile(
          leading: SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                // color: Colors.red,
                imageUrl: profileImage ?? avatarImage,
                placeholder: (context, url) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/app_icon.png'),
                                opacity: .5)),
                      ),
                    ],
                  );
                },
                errorWidget: (context, url, error) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/app_icon.png'),
                                opacity: .5)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName?.toString() ?? 'User',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cc.greyParagraph)),
                const SizedBox(height: 8),
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 12,
                  initialRating: (rating).toDouble(),
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                  itemBuilder: (context, _) => SvgPicture.asset(
                    'assets/icons/star.svg',
                    color: cc.orangeRating,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  reviewText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(timeago.format(createdAt),
                    style: TextStyle(color: cc.greyHint, fontSize: 11)),
                // const Divider(),
              ],
            ),
          ),
        ));
  }
}
