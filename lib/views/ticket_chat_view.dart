import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/ticket_chat_service.dart';
import 'package:safecart/widgets/common/boxed_back_button.dart';

import '../helpers/common_helper.dart';
import '../services/rtl_service.dart';
import '../utils/custom_preloader.dart';
import '../utils/responsive.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/image_view.dart';

class TicketChatView extends StatefulWidget {
  final String title;
  final id;
  const TicketChatView(this.title, this.id, {super.key});

  @override
  State<TicketChatView> createState() => _TicketChatViewState();
}

class _TicketChatViewState extends State<TicketChatView> {
  @override
  void initState() {
    _controller = TextEditingController();
    textFieldKey = const Key('key');
    super.initState();
  }

  late Key textFieldKey;

  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> imageSelector(
    BuildContext context,
  ) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'zip', 'png', 'jpeg'],
      );
      Provider.of<TicketChatService>(context, listen: false)
          .setPickedImage(File(file!.files.single.path as String));
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    return Consumer<TicketChatService>(builder: (context, tcProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          tcProvider.clearAllMessages();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            foregroundColor: cc.blackColor,
            backgroundColor: cc.pureWhite,
            centerTitle: true,
            title: RichText(
              softWrap: true,
              text: TextSpan(
                  text: '#${widget.id}',
                  style: TextStyle(
                      color: cc.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                  children: [
                    TextSpan(
                        text: ' ${widget.title}',
                        style: TextStyle(color: cc.blackColor)),
                  ]),
            ),
            leading: GestureDetector(
              onTap: () {
                tcProvider.clearAllMessages();
                Navigator.of(context).pop();
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxedBackButton(
                      () {
                        tcProvider.clearAllMessages();
                        Navigator.pop(context);
                      },
                    )
                  ]),
            ),
          ),
          body: WillPopScope(
            onWillPop: () async {
              tcProvider.clearAllMessages();
              Navigator.of(context).pop();
              return true;
            },
            child: Consumer<TicketChatService>(
                builder: (context, tcProvider, child) {
              return Column(
                children: [
                  Expanded(
                    child: messageListView(tcProvider),
                  ),
                  SizedBox(
                    height: screenHeight / 7,
                    // margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        maxLines: 4,
                        controller: _controller,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: AppLocalizations.of(context)!.write_message,
                          hintStyle:
                              TextStyle(color: cc.greyHint, fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: cc.greyBorder2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cc.greyBorder2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cc.greyBorder2),
                          ),
                        ),
                        onChanged: (value) {
                          tcProvider.setMessage(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.file,
                          style: TextStyle(
                              color: cc.greyHint, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            imageSelector(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: cc.greyBorder2)),
                            child: Text(
                              AppLocalizations.of(context)!.choose_file,
                              style: TextStyle(color: cc.greyHint),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: screenWidth / 3,
                          child: Text(
                            tcProvider.pickedImage == null
                                ? AppLocalizations.of(context)!.no_file_chosen
                                : tcProvider.pickedImage!.path.split('/').last,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: Checkbox(

                              // splashRadius: 30,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              side: BorderSide(
                                width: 1,
                                color: cc.greyBorder,
                              ),
                              activeColor: cc.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: BorderSide(
                                    width: 1,
                                    color: cc.greyBorder,
                                  )),
                              value: tcProvider.notifyViaMail,
                              onChanged: (value) {
                                tcProvider.toggleNotifyViaMail(value);
                              }),
                        ),
                        const SizedBox(width: 5),
                        RichText(
                          softWrap: true,
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.notify_via_mail,
                            style: TextStyle(color: cc.greyHint, fontSize: 13
                                // fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: [
                          CustomCommonButton(
                            btText: AppLocalizations.of(context)!.send,
                            isLoading: tcProvider.isLoading,
                            onPressed: tcProvider.message == '' &&
                                    tcProvider.pickedImage == null
                                ? null
                                : () async {
                                    tcProvider.setIsLoading(true);
                                    FocusScope.of(context).unfocus();
                                    await tcProvider
                                        .sendMessage(context,
                                            tcProvider.ticketDetails!.id)
                                        .then((value) {
                                      if (value != null) {
                                        snackBar(context, value,
                                            backgroundColor: cc.red);
                                        return;
                                      }
                                      _controller.clear();
                                    });
                                  },
                          ),
                          // if (tcProvider.isLoading)
                          //   SizedBox(
                          //       height: 50,
                          //       width: double.infinity,
                          //       child: CustomPreloader(
                          //         whiteColor: true,
                          //       ))
                        ],
                      ),
                    ),
                  ),
                  const SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: SizedBox(height: 25)),
                ],
              );
            }),
          ),
        ),
      );
    });
  }

  Widget messageListView(TicketChatService tcProvider) {
    if (tcProvider.ticketDetails == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 56,
            child: Center(
              child: CustomPreloader(),
            ),
          ),
        ],
      );
    } else if (tcProvider.noMessage) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no_Message_has_been_found,
          style: TextStyle(color: cc.greyHint),
        ),
      );
    } else {
      return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          reverse: true,
          itemCount: tcProvider.messagesList.length,
          itemBuilder: ((context, index) {
            final element = tcProvider.messagesList[index];
            final usersMessage = element.type != 'admin';
            return SizedBox(
              width: screenWidth / 1.7,
              child: Column(
                crossAxisAlignment: usersMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: usersMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                          // width: screenWidth / 1.7,
                          constraints:
                              BoxConstraints(maxWidth: screenWidth / 1.7),
                          // alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Provider.of<RTLService>(context,
                                          listen: false)
                                      .langRtl
                                  ? (usersMessage
                                      ? Radius.zero
                                      : const Radius.circular(12))
                                  : (usersMessage
                                      ? const Radius.circular(12)
                                      : Radius.zero),
                              bottomRight: Provider.of<RTLService>(context,
                                          listen: false)
                                      .langRtl
                                  ? (usersMessage
                                      ? const Radius.circular(12)
                                      : Radius.zero)
                                  : (usersMessage
                                      ? Radius.zero
                                      : const Radius.circular(12)),
                            ),
                            color: usersMessage
                                ? cc.primaryColor
                                : const Color(0xffEFEFEF),
                          ),
                          child: Text(
                            tcProvider.messagesList[index].message,
                            style: usersMessage
                                ? TextStyle(color: cc.pureWhite)
                                : null,
                          )),
                      // ),
                    ],
                  ),
                  if (tcProvider.messagesList[index].attachment != null)
                    const SizedBox(height: 5),
                  if (tcProvider.messagesList[index].attachment != null)
                    showFile(
                        context,
                        tcProvider.messagesList[index].attachment,
                        tcProvider.messagesList[index].id,
                        usersMessage
                            ? (Provider.of<RTLService>(context, listen: false)
                                    .langRtl
                                ? Alignment.centerLeft
                                : Alignment.centerRight)
                            : (Provider.of<RTLService>(context, listen: false)
                                    .langRtl
                                ? Alignment.centerRight
                                : Alignment.centerLeft))
                ],
              ),
            );
          }));
    }
  }

  Widget showFile(
      BuildContext context, String? url, int id, AlignmentGeometry alignment) {
    screenSizeAndPlatform(context);
    if (url != null &&
        (!url.contains('.png') &&
            !url.contains('.jpg') &&
            !url.contains('.jpeg'))) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 50,
        child: SvgPicture.asset('assets/images/icons/zip_icon.svg'),
      );
    }
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) => ImageView(url, id: id),
        //   ),
        // );
      },
      child: url != null
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ImageView(
                      url,
                    ),
                  ),
                );
              },
              child: Container(
                height: 200,
                // width: screenWidth / 1.5,
                alignment: alignment,
                constraints: BoxConstraints(
                  maxWidth: screenWidth / 1.5,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(
                  url,
                  alignment: alignment,
                  loadingBuilder: (context, child, loding) {
                    if (loding == null) {
                      return child;
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              alignment: alignment,
                              image: const AssetImage(
                                'assets/images/app_icon.png',
                              ),
                              opacity: .4)),
                    );
                  },
                  // imageUrl: url,
                  errorBuilder: (context, str, some) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              alignment: alignment,
                              image: const AssetImage(
                                  'assets/images/app_icon.png'),
                              opacity: .4)),
                    );
                  },
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
