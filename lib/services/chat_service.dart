import 'dart:io';

import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {
  List messagesList = [];
  var ticketDetails;
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

  fetchTicket() {}
  sendMessage(id) {}
  fetchMessage() {}
}
