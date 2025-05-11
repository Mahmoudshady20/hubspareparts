import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/helpers/common_helper.dart';

import '../models/ticket_chat_model.dart';

class TicketChatService with ChangeNotifier {
  List<AllMessage> messagesList = [];
  TicketDetails? ticketDetails;
  bool isLoading = false;
  String message = '';
  File? pickedImage;
  bool notifyViaMail = false;
  bool noMessage = false;
  bool msgSendingLoading = false;

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setMsgSendingLoading() {
    msgSendingLoading = true;
    notifyListeners();
  }

  setMessage(value) {
    message = value;
    notifyListeners();
  }

  clearAllMessages() {
    messagesList = [];
    pickedImage = null;
    notifyViaMail = false;
    noMessage = false;
    ticketDetails = null;
    notifyListeners();
  }

  setPickedImage(value) {
    pickedImage = value;
    notifyListeners();
  }

  toggleNotifyViaMail(value) {
    notifyViaMail = !notifyViaMail;
    notifyListeners();
  }

  Future fetchSingleTickets(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/user/ticket/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        messagesList =
            TicketChatModel.fromJson(data).allMessages.reversed.toList();
        ticketDetails = TicketChatModel.fromJson(data).ticketDetails;
        noMessage = TicketChatModel.fromJson(data).allMessages.isEmpty;

        setIsLoading(false);
        notifyListeners();
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    }
    // catch (err) {
    //   showToast(asProvider.getString('Something went wrong'), cc.red);
    //   print(err);
    // }
  }

  Future sendMessage(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/ticket/chat/send/$id'));
      request.fields.addAll({
        'user_type': 'customer',
        'message': message,
        'send_notify_mail': notifyViaMail.toString()
      });
      if (pickedImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('file', pickedImage!.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // await fetchOnlyMessages(context, id);
        messagesList.insert(0, AllMessage.fromJson(jsonDecode(data)));
        showToast(AppLocalizations.of(context)!.message_sent, cc.green);
        message = '';
        pickedImage = null;
        notifyViaMail = false;
        setIsLoading(false);
        notifyListeners();
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }

  Future fetchOnlyMessages(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.MultipartRequest(
          'GET', Uri.parse('$baseApi/user/ticket/chat/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(await response.stream.bytesToString());
        List<AllMessage> data = [];
        responseData.forEach((element) {
          data.add(AllMessage.fromJson(element));
        });
        messagesList = data.reversed.toList();
        setIsLoading(false);
        // setNoProduct(resultMeta!.total == 0);
        noMessage = messagesList.isEmpty;
        notifyListeners();
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }
}

// To parse this JSON data, do
//
//     final onlyMessagesModel = onlyMessagesModelFromJson(jsonString);

List<OnlyMessagesModel> onlyMessagesModelFromJson(String str) =>
    List<OnlyMessagesModel>.from(
        json.decode(str).map((x) => OnlyMessagesModel.fromJson(x)));

String onlyMessagesModelToJson(List<OnlyMessagesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OnlyMessagesModel {
  OnlyMessagesModel({
    required this.id,
    required this.message,
    this.notify,
    this.attachment,
    this.type,
    required this.supportTicketId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String message;
  Notify? notify;
  String? attachment;
  Type? type;
  int supportTicketId;
  DateTime createdAt;
  DateTime updatedAt;

  factory OnlyMessagesModel.fromJson(Map<String, dynamic> json) =>
      OnlyMessagesModel(
        id: json["id"],
        message: json["message"],
        notify: notifyValues.map[json["notify"]],
        attachment: json["attachment"],
        type: typeValues.map[json["type"]],
        supportTicketId: json["support_ticket_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "notify": notifyValues.reverse![notify],
        "attachment": attachment,
        "type": typeValues.reverse![type],
        "support_ticket_id": supportTicketId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum Notify { ON, OFF }

final notifyValues = EnumValues({"off": Notify.OFF, "on": Notify.ON});

enum Type { MOBILE, ADMIN }

final typeValues = EnumValues({"admin": Type.ADMIN, "mobile": Type.MOBILE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
