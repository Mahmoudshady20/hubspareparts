import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/ticket_chat_service.dart';
import 'package:safecart/services/ticket_list_service.dart';

import '../../helpers/common_helper.dart';
import '../../services/rtl_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/views/ticket_chat_view.dart';

class TicketTile extends StatelessWidget {
  final String title;
  final int ticketId;
  String priority;
  String status;
  TicketTile(
    this.title,
    this.ticketId,
    this.priority,
    this.status, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    // const ticketItem = 'open';
    // // final ticketItem = Provider.of<AllAllTicketlProvider>(context, listen: false)
    // //     .ticketsList
    // //     .firstWhere((element) => element.id == ticketId);
    return GestureDetector(
      onTap: (() {
        Provider.of<TicketChatService>(context, listen: false)
            .fetchSingleTickets(context, ticketId)
            .then((value) {
          if (value != null) {
            snackBar(context, value);
          }
        }).onError((error, stackTrace) {
          snackBar(context, 'Could not load any messages');
        });
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) => TicketChatView(title, ticketId),
        ));
      }),
      child: Container(
        // height: screenHight / 10,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cc.greyBorder2),
        ),
        child: Column(
          children: [
            SizedBox(
                // height: 60,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Text(
                  '#$ticketId',
                  style: TextStyle(color: cc.primaryColor, fontSize: 13),
                ),
                const SizedBox(width: 10),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                      color: cc.blackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
                //   ],
                ,
                const Spacer(),
              ],
            )),
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (screenWidth - 40) / 3.7,
                  child: Consumer<TicketListService>(
                      builder: (context, tlProvider, child) {
                    return SizedBox(
                      height: 30,
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(asProvider.getString('Priority') + ':'),
                            const SizedBox(width: 5),
                            Consumer<TicketListService>(
                                builder: (context, tlProviderm, child) {
                              return PopupMenuButton(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: rtlProvider.langRtl ? 0 : 7,
                                        right: rtlProvider.langRtl ? 7 : 0,
                                        top: 3,
                                        bottom: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      // color: tlProvider.priorityColor[priority],
                                      color: tlProvider.priorityColor[
                                              priority.toLowerCase()] ??
                                          tlProvider.priorityColor.values.first,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          priority.toString().capitalize(),
                                          style: TextStyle(
                                              color: cc.pureWhite,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: cc.pureWhite,
                                        )
                                      ],
                                    ),
                                  ),
                                  onSelected: (value) {
                                    if (value != priority.capitalize()) {
                                      print(value);
                                      tlProvider.priorityChange(
                                          context, ticketId, value.toString());
                                    }
                                  },
                                  itemBuilder: (context) =>
                                      tlProvider.priorityList
                                          .map((e) => PopupMenuItem(
                                                value: e,
                                                child: Text(e.capitalize()),
                                              ))
                                          .toList());
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  height: 30,
                  width: (screenWidth - 40) / 3.7,
                  child: Consumer<TicketListService>(
                      builder: (context, tlProvider, child) {
                    return FittedBox(
                      child: Row(
                        children: [
                          Text(asProvider.getString('Status') + ':'),
                          const SizedBox(width: 5),
                          PopupMenuButton(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: rtlProvider.langRtl ? 0 : 7,
                                  right: rtlProvider.langRtl ? 7 : 0,
                                  top: 3,
                                  bottom: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: status == 'open' ? cc.green : cc.red,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    status.capitalize(),
                                    style: TextStyle(
                                        color: cc.pureWhite,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: cc.pureWhite,
                                  )
                                ],
                              ),
                            ),
                            onSelected: (value) {
                              print(value.toString() + status);
                              if (value != status) {
                                tlProvider.statusChange(
                                    context, ticketId, value.toString());
                              }
                            },
                            itemBuilder: (context) => ['open', 'close']
                                .map(
                                  (e) => PopupMenuItem(
                                    value: e,
                                    child: Text(
                                        (asProvider.getString(e) as String)
                                            .capitalize()),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const Spacer(),
                SizedBox(
                    height: 25,
                    child: FittedBox(
                      child: GestureDetector(
                        onTap: (() {
                          Provider.of<TicketChatService>(context, listen: false)
                              .fetchSingleTickets(context, ticketId)
                              .then((value) {
                            if (value != null) {
                              snackBar(context, value);
                            }
                          }).onError((error, stackTrace) {
                            snackBar(context, 'Could not load any messages');
                          });
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                TicketChatView(title, ticketId),
                          ));
                        }),
                        child: Container(
                          height: 30,
                          width: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cc.primaryColor,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/chat_view.svg',
                            height: 20,
                            width: 30,
                          ),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
