import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/profile_info_service.dart';
import '../../utils/responsive.dart';
import '../../views/edit_profile_view.dart';

class ProfileInfo extends StatelessWidget {
  bool editing;
  ProfileInfo({this.editing = false, super.key});

  Future<void> imageSelector(
    BuildContext context,
  ) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      if (file?.files.first.path != null) {
        Provider.of<ProfileInfoService>(context, listen: false)
            .setSelectedImage(File(file?.files.first.path ?? ''));
      }
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Consumer<ProfileInfoService>(
            builder: (context, pProvider, child) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.my_points,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: cc.pureWhite,
                          ),
                    ),
                    Text(
                      pProvider.profileInfo!.userDetails.userPoints
                              .toString() ??
                          'shady',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cc.pureWhite,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          EmptySpaceHelper.emptyHight(10),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () {
                  if (!editing) {
                    // final pProvider =
                    //     Provider.of<ProfileInfoService>(context, listen: false);
                    // if (pProvider.profileInfo?.userDetails.userCountry?.name !=
                    //     null) {
                    //   Provider.of<CountryStateService>(context, listen: false)
                    //       .fetchAllStates(
                    //           context,
                    //           Provider.of<CountryStateService>(context,
                    //                   listen: false)
                    //               .getCountryId(pProvider.profileInfo
                    //                   ?.userDetails.userCountry!.name));
                    // }
                    Navigator.of(context).pushNamed(EditProfileView.routeName);
                    return;
                  }
                  imageSelector(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Consumer<ProfileInfoService>(
                      builder: (context, pProvider, child) {
                    return SizedBox(
                      width: screenWidth / 3.6,
                      height: screenWidth / 3.6,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: pProvider.selectedImage != null
                              ? Image.file(
                                  pProvider.selectedImage!,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: pProvider.profileInfo!.userDetails
                                          .profileImageUrl ??
                                      '',
                                  placeholder: (context, url) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cc.secondaryColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        pProvider.profileInfo!.userDetails.name
                                            .substring(0, 2)
                                            .toUpperCase()
                                            .trim(),
                                        style: TextStyle(
                                            color: cc.pureWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 45),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cc.secondaryColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        pProvider.profileInfo!.userDetails.name
                                            .substring(0, 2)
                                            .toUpperCase()
                                            .trim(),
                                        style: TextStyle(
                                            color: cc.pureWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 45),
                                      ),
                                    );
                                  },
                                )),
                    );
                  }),
                ),
              ),
              if (editing)
                GestureDetector(
                  onTap: () {
                    imageSelector(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SvgPicture.asset(
                      'assets/icons/camera.svg',
                      height: 35,
                    ),
                  ),
                ),
            ],
          ),
          Consumer<ProfileInfoService>(builder: (context, pProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EmptySpaceHelper.emptyHight(10),
                Text(
                  pProvider.profileInfo!.userDetails.name.capitalize(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cc.pureWhite,
                      ),
                ),
                EmptySpaceHelper.emptyHight(4),
                Text(
                  pProvider.profileInfo!.userDetails.email,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: cc.pureWhite,
                      ),
                ),
                if (!editing)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(EditProfileView.routeName);
                      return;
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/edit.svg',
                      color: cc.pureWhite,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.edit_profile,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: cc.pureWhite,
                          ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: cc.pureWhite,
                      padding: EdgeInsets.zero,
                      surfaceTintColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      elevation: 0,
                    ),
                  )
              ],
            );
          })
        ],
      ),
    );
  }
}
