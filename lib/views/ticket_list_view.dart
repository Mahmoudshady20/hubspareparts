import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/new_ticket_service.dart';
import 'package:safecart/services/ticket_list_service.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/views/new_ticket_view.dart';
import 'package:safecart/widgets/common/custom_common_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/ticket_view/ticket_tile.dart';
import '../widgets/skelletons/tickets_list_shimmer.dart';

class TicketListView extends StatelessWidget {
  static const routeName = 'ticket_list_view';
  TicketListView({super.key});
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    screenSizeAndPlatform(context);
    double cardWidth = screenWidth / 3.3;
    double cardHeight = screenHeight / 4.9;
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
                      AppLocalizations.of(context)!.my_Tickets,
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
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        // constraints:
                        //     BoxConstraints(minHeight: screenHeight / 2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: FutureBuilder(
                            future: Provider.of<TicketListService>(context,
                                    listen: false)
                                .fetchAllTickets(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // return LoadingIndicator();
                                // return LoadingSpinner();
                                return Column(
                                  children: [
                                    ...Iterable.generate(2)
                                        .map(
                                          (e) => const TicketTileSkeleton(),
                                        )
                                        .toList(),
                                  ],
                                );
                              }
                              // if (snapshot.hasError) {
                              //   return errorWidget();
                              // }
                              if (snapshot.hasData) {
                                return Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.no_ticket_found),
                                );
                              }

                              return
                                  //  ticketsService.noProduct
                                  //     ? const Center(
                                  //         child: Text('No ticket found.'),
                                  //       )
                                  //     :
                                  ticketsListView(cardWidth, cardHeight);
                            })),
                  ),
                  Consumer<TicketListService>(
                      builder: (context, tlProvider, child) {
                    return SizedBox(
                      height: 50,
                      child: tlProvider.isLoadingNextPage
                          ? Center(child: CustomPreloader())
                          : null,
                    );
                  })
                ],
              ),
            ),
          ]),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomCommonButton(
            onPressed: () {
              Provider.of<NewTicketService>(context, listen: false)
                  .fetchDepartments(context);
              Navigator.pushNamed(context, NewTicketView.routeName);
            },
            btText: AppLocalizations.of(context)!.add_new_ticket,
            isLoading: false),
      ),
    );
  }

  Widget ticketsListView(
    double cardWidth,
    double cardHeight,
  ) {
    int index = 0;
    return Consumer<TicketListService>(builder: (context, tlProvider, child) {
      return tlProvider.ticketsList.isEmpty
          ? SizedBox(
              height: screenHeight / 2.5,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.no_data_has_been_found,
                  style: TextStyle(color: cc.greyHint),
                ),
              ),
            )
          : Column(
              children: [
                ...tlProvider.ticketsList
                    .map(
                      (e) => TicketTile(
                        e.title,
                        e.id,
                        e.priority,
                        e.status,
                      ),
                    )
                    .toList(),
              ],
            );
    });
  }

  scrollListener(BuildContext context) async {
    final tProvider = Provider.of<TicketListService>(context, listen: false);
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (tProvider.nextPage == null) {
        showToast(AppLocalizations.of(context)!.no_more_ticket_found, cc.blackColor);
        return;
      }
      if (tProvider.nextPage != null && !tProvider.isLoadingNextPage) {
        await tProvider.fetchNextPageTickets(context);
        return;
      }
    }
  }
}
