import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/settings_helper.dart';
import 'package:safecart/services/ticket_list_service.dart';
import 'package:safecart/widgets/language_component.dart';

import '../helpers/common_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';

class SettingsView extends StatefulWidget {
  static const routeName = 'setting_view';
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ScrollController controller = ScrollController();
  late String? languageDropValue;

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    screenSizeAndPlatform(context);
    double cardWidth = screenWidth / 3.3;
    double cardHeight = screenHeight / 4.9;
    getSetting();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
            color: cc.primaryColor,
            alignment: Alignment.topCenter,
            child: const Center(),
          ),
          CustomScrollView(controller: controller, slivers: [
            SliverAppBar(
              elevation: 1,
              leadingWidth: 60,
              toolbarHeight: 60,
              foregroundColor: cc.greyHint,
              backgroundColor: Colors.transparent,
              expandedHeight: screenHeight / 3.7,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: screenHeight / 3.7,
                  width: double.infinity,
                  // padding: EdgeInsets.only(top: screenHeight / 7),
                  color: cc.primaryColor,
                  alignment: Alignment.topCenter,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.language,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: cc.pureWhite, fontSize: 25),
                    ),
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    BoxedBackButton(() {
                      Navigator.of(context).pop();
                    }),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  // constraints:
                  //     BoxConstraints(minHeight: screenHeight / 2.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: LanguageComponent(
                    languageDropValue: languageDropValue,
                    onChanged: (value) {
                      setState(
                        () {
                          languageDropValue = value!;
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }

/*
LanguageComponent(
                languageDropValue: languageDropValue,
                onChanged: (value) {
                  setState(
                    () {
                      languageDropValue = value!;
                    },
                  );
                },
              )
 */
  scrollListener(BuildContext context) async {
    final tProvider = Provider.of<TicketListService>(context, listen: false);
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (tProvider.nextPage == null) {
        showToast(
            AppLocalizations.of(context)!.no_more_ticket_found, cc.blackColor);
        return;
      }
      if (tProvider.nextPage != null && !tProvider.isLoadingNextPage) {
        await tProvider.fetchNextPageTickets(context);
        return;
      }
    }
  }

  void getSetting() {
    if (SharedPrefs.getLan() == 'ar') {
      languageDropValue = 'arabic';
    } else {
      languageDropValue = 'english';
    }
  }
}
