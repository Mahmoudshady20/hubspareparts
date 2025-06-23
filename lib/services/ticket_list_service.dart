import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/ticket_list_model.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';

import '../helpers/common_helper.dart';

class TicketListService with ChangeNotifier {
  List<Datum> ticketsList = [];
  bool isLoading = false;
  bool isLoadingNextPage = false;
  bool? lastPage;
  // TicketsModel? ticketsModel;
  bool noProduct = false;
  String? nextPage;
  int pageNo = 1;
  String? title;
  String? subject;

  String priority = 'Low';
  String department = 'Product Delivery';
  int? departmentId;
  String? description;
  Map<String, Color> priorityColor = {
    'low': const Color(0xff6BB17B),
    'medium': const Color(0xff70B9AE),
    'high': const Color(0xffBFB55A),
    'urgent': const Color(0xffC66060),
  };

  List<String> priorityList = [
    'low',
    'medium',
    'high',
    'urgent',
  ];
  List departmentsList = [];

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setLoadingNextPage(value) {
    if (value == nextPage) {
      return;
    }
    isLoadingNextPage = value;
    notifyListeners();
  }

  setPageNo() {
    pageNo++;
    notifyListeners();
  }

  // setSelectedTicket(value) {
  //   selectedTicket = value;
  //   notifyListeners();
  // }

  setPriority(value) {
    priority = value;
    notifyListeners();
  }

  setDepartment(value) {
    department = value;
    notifyListeners();
  }

  setTitle(value) {
    title = value;
    notifyListeners();
  }

  setSubject(value) {
    subject = value;
    notifyListeners();
  }

  setDescription(value) {
    description = value;
    notifyListeners();
  }

  clearTickets() {
    ticketsList = [];
    noProduct = false;
  }

  fetchAllTickets(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.Request('GET', Uri.parse('$baseApi/user/ticket'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        ticketsList = TicketListModel.fromJson(data).data;
        nextPage = data['next_page_url'];
        notifyListeners();
        return;
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }

  fetchNextPageTickets(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      setLoadingNextPage(true);
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.Request('GET', Uri.parse('$nextPage'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        for (var element in TicketListModel.fromJson(data).data) {
          ticketsList.add(element);
        }
        nextPage = data['next_page_url'];
        setLoadingNextPage(false);
        return;
      } else {
        setLoadingNextPage(false);
      }
    } on TimeoutException {
      setLoadingNextPage(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoadingNextPage(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
    }
  }

  Future statusChange(BuildContext context, int id, String status) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/ticket/status-change'));
      request.fields.addAll({
        'status': status,
        'id': id.toString(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        ticketsList.firstWhere((element) => element.id == id).status =
            status.toLowerCase();
        showToast(AppLocalizations.of(context)!.status_Change_successful, cc.green);
        notifyListeners();
        return;
      } else {
        showToast(AppLocalizations.of(context)!.status_Change_failed, cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }

  Future priorityChange(BuildContext context, int id, String value) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/ticket/priority-change'));
      request.fields.addAll({
        'priority': value,
        'id': id.toString(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        ticketsList.firstWhere((element) => element.id == id).priority =
            value.toLowerCase();
        showToast(AppLocalizations.of(context)!.priority_Change_successful, cc.green);
        notifyListeners();
        return;
      } else {
        showToast(AppLocalizations.of(context)!.priority_Change_failed, cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }
}
