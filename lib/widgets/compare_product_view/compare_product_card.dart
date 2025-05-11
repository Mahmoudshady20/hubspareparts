// import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/utils/responsive.dart';

import '../../helpers/empty_space_helper.dart';

class CompareProductCard extends StatelessWidget {
  const CompareProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    double salePrice = 98;
    double? originalPrice = 122;
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: (screenWidth - 40) / 2,
        height: double.infinity,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                // topLeft: Radius.circular(8),
                // bottomRight: Radius.circular(8),
              ),
              child: SizedBox(
                  height: screenHeight / 7,
                  // width: scre,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.pexels.com/photos/6393017/pexels-photo-6393017.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/app_icon.png'),
                                  opacity: .5)),
                        ),
                      ],
                    ),
                    errorWidget: (context, url, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/app_icon.png'),
                                  opacity: .5)),
                        ),
                      ],
                    ),
                  )),
            ),
            EmptySpaceHelper.emptyHight(10),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Women’s Top",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$30.99",
                    style: TextStyle(
                      fontSize: 16,
                      color: cc.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 17,
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                        itemBuilder: (context, _) => SvgPicture.asset(
                          'assets/icons/star.svg',
                          color: cc.orangeRating,
                        ),
                        onRatingUpdate: (rating) {
                          // Provider.of<ReviewService>(context, listen: false)
                          //     .setRating(rating.toString());
                        },
                      ),
                      EmptySpaceHelper.emptywidth(10),
                      const Text("( 9 )"),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Text("Model: S-002"),
                  // const SizedBox(height: 8),
                  // const Text(
                  //   "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart.",
                  //   style: TextStyle(fontSize: 14),
                  // ),
                  const SizedBox(height: 8),
                  Text("Stock out", style: TextStyle(color: Colors.red[900])),
                  const SizedBox(height: 8),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Cotton, White" ", H-32”, W-20”"),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ElevatedButton(
                  //   child: const Text(
                  //     "Add to Cart",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   onPressed: () {},
                  //   // color: Colors.red[900],
                  // ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      child: const Text("Remove"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container(
//         padding: const EdgeInsets.all(8.0),
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(15),
//                 topRight: Radius.circular(15),
//                 // topLeft: Radius.circular(8),
//                 // bottomRight: Radius.circular(8),
//               ),
//               child: SizedBox(
//                   height: screenHeight / 5,
//                   // width: scre,
//                   child: CachedNetworkImage(
//                     imageUrl:
//                         'https://images.pexels.com/photos/6393017/pexels-photo-6393017.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                   image: AssetImage(
//                                       'assets/images/app_icon.png'),
//                                   opacity: .5)),
//                         ),
//                       ],
//                     ),
//                     errorWidget: (context, url, error) => Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                   image: AssetImage(
//                                       'assets/images/app_icon.png'),
//                                   opacity: .5)),
//                         ),
//                       ],
//                     ),
//                   )),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Women’s Top",
//                     style: TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "\$30.99",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: cc.secondaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       RatingBar.builder(
//                         ignoreGestures: true,
//                         itemSize: 17,
//                         initialRating: 3,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemPadding:
//                             const EdgeInsets.symmetric(horizontal: 1),
//                         itemBuilder: (context, _) => SvgPicture.asset(
//                           'assets/icons/star.svg',
//                           color: cc.orangeRating,
//                         ),
//                         onRatingUpdate: (rating) {
//                           print(rating);
//                           // Provider.of<ReviewService>(context, listen: false)
//                           //     .setRating(rating.toString());
//                         },
//                       ),
//                       EmptySpaceHelper.emptywidth(10),
//                       const Text("( 9 )"),
//                     ],
//                   ),

//                   const SizedBox(height: 8),
//                   const Text("Model: S-002"),
//                   // const SizedBox(height: 8),
//                   // const Text(
//                   //   "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart.",
//                   //   style: TextStyle(fontSize: 14),
//                   // ),
//                   const SizedBox(height: 8),
//                   Text("Stock out",
//                       style: TextStyle(color: Colors.red[900])),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Text("Cotton, White" ", H-32”, W-20”"),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         child: const Text(
//                           "Add to Cart",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onPressed: () {},
//                         // color: Colors.red[900],
//                       ),
//                       const SizedBox(width: 8),
//                       OutlinedButton(
//                         child: const Text("Remove"),
//                         onPressed: () {},
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

// Card(
//         elevation: 5,
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         child: Container(
//           width: screenWidth - 50,
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(15),
//                       topRight: Radius.circular(15),
//                       // topLeft: Radius.circular(8),
//                       // bottomRight: Radius.circular(8),
//                     ),
//                     child: SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: CachedNetworkImage(
//                           imageUrl:
//                               'https://images.pexels.com/photos/6393017/pexels-photo-6393017.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: const BoxDecoration(
//                                     image: DecorationImage(
//                                         image: AssetImage(
//                                             'assets/images/app_icon.png'),
//                                         opacity: .5)),
//                               ),
//                             ],
//                           ),
//                           errorWidget: (context, url, error) => Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: const BoxDecoration(
//                                     image: DecorationImage(
//                                         image: AssetImage(
//                                             'assets/images/app_icon.png'),
//                                         opacity: .5)),
//                               ),
//                             ],
//                           ),
//                         )),
//                   ),
//                   EmptySpaceHelper.emptywidth(10),
//                   SizedBox(
//                     width: screenWidth - 190,
//                     child: Column(
//                       children: [
//                         Text(
//                           "Men's slim comfortable high quality fabric long sleeve very warm jumper",
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle2!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         EmptySpaceHelper.emptyHight(8),
//                         SizedBox(
//                           // width: screenWidth - 190,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 rtlProvider.curRtl
//                                     ? '${salePrice.toStringAsFixed(2)}${rtlProvider.currency}'
//                                     : '${rtlProvider.currency}${salePrice.toStringAsFixed(2)}',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall!
//                                     .copyWith(
//                                         color: cc.secondaryColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                               ),
//                               EmptySpaceHelper.emptywidth(5),
//                               if (originalPrice != null)
//                                 Text(
//                                   rtlProvider.curRtl
//                                       ? '${originalPrice.toStringAsFixed(2)}${rtlProvider.currency}'
//                                       : '${rtlProvider.currency}${originalPrice.toStringAsFixed(2)}',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodySmall!
//                                       .copyWith(
//                                         color: cc.greyHint,
//                                         fontSize: 14,
//                                         decoration: TextDecoration.lineThrough,
//                                         decorationColor: cc.cardGreyHint,
//                                         decorationStyle:
//                                             TextDecorationStyle.solid,
//                                       ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         EmptySpaceHelper.emptyHight(8),
//                         Row(
//                           children: [
//                             RatingBar.builder(
//                               ignoreGestures: true,
//                               itemSize: 17,
//                               initialRating: 3,
//                               minRating: 1,
//                               direction: Axis.horizontal,
//                               allowHalfRating: true,
//                               itemCount: 5,
//                               itemPadding:
//                                   const EdgeInsets.symmetric(horizontal: 1),
//                               itemBuilder: (context, _) => SvgPicture.asset(
//                                 'assets/icons/star.svg',
//                                 color: cc.orangeRating,
//                               ),
//                               onRatingUpdate: (rating) {
//                                 print(rating);
//                                 // Provider.of<ReviewService>(context, listen: false)
//                                 //     .setRating(rating.toString());
//                               },
//                             ),
//                             EmptySpaceHelper.emptywidth(10),
//                             const Text("( 9 )"),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               RichText(
//                 text: TextSpan(
//                     text: 'Attributes:',
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle2!
//                         .copyWith(fontWeight: FontWeight.bold),
//                     children: [
//                       TextSpan(
//                         text:
//                             ' Mayo:Lime, Color: Red,Size: Small, Cheese:Mozzarella',
//                         style: Theme.of(context)
//                             .textTheme
//                             .subtitle2!
//                             .copyWith(color: cc.greyParagraph),
//                       ),
//                     ]),
//               ),
//               const Divider(),
//               RichText(
//                   text: TextSpan(
//                     text: 'Summery:',
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle2!
//                         .copyWith(fontWeight: FontWeight.bold),
//                     children: [
//                       TextSpan(
//                         text:
//                             "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,\r\nmolestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum\r\nnumquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium\r\noptio, eaque rerum! Provident similique accusantium nemo autem. Veritatis",
//                         style: Theme.of(context).textTheme.subtitle2!.copyWith(
//                               color: cc.greyParagraph,
//                             ),
//                       ),
//                     ],
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis),
//               const Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   CustomCommonButton(
//                     btText: asProvider.getString('Add to cart'),
//                     onPressed: () {
//                       // Provider.of<CartDataService>(context, listen: false)
//                       //     .addCartItem(
//                       //   context,
//                       //   pdProvider.productDetails!.vendorId,
//                       //   pdProvider.productDetails!.id,
//                       //   pdProvider.productDetails!.name ?? '',
//                       //   pdProvider.productSalePrice,
//                       //   widget.itemCount,
//                       //   pdProvider.additionalInfoImage ??
//                       //       pdProvider.productDetails!.galleryImages?.first ??
//                       //       '',
//                       //   pdProvider.variantId,
//                       //   originalPrice:
//                       //       pdProvider.productDetails?.campaignProduct!.campaignPrice,
//                       //   inventorySet: pdProvider.selectedInventorySet,
//                       //   prodCatData: {
//                       //     "category": pdProvider.productDetails?.category?.id,
//                       //     "subcategory": pdProvider.productDetails?.subCategory?.id,
//                       //     "childcategory": pdProvider.productDetails?.childCategory
//                       //         ?.map((e) => e.id)
//                       //         .toList()
//                       //   },
//                       // );
//                     },
//                     width: screenWidth / 2.5,
//                     isLoading: false,
//                   ),
//                   SizedBox(
//                     height: 44,
//                     width: screenWidth / 2.5,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.resolveWith((states) {
//                           if (states.contains(MaterialState.pressed)) {
//                             return cc.blackColor;
//                           }
//                           return cc.red;
//                         }),
//                       ),
//                       child: Text(asProvider.getString("Remove item")),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       )
