import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/order_details_list_model.dart';

import '../../helpers/common_helper.dart';

class OrderListService with ChangeNotifier {
  OrderListModel? orderListModel;
  bool noOrder = false;
  bool isLoading = false;
  bool loadingNextPage = false;
  bool loadingNextPageFailed = false;

  setLoadingNextPageFailed(value) {
    if (value == loadingNextPageFailed) {
      return;
    }
    loadingNextPageFailed = value;

    notifyListeners();
  }

  setLoadingNextPage(value) {
    if (value == loadingNextPage) {
      return;
    }
    loadingNextPage = value;
    notifyListeners();
  }

  fetchOrderList(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.Request('GET', Uri.parse('$baseApi/user/order-list'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        orderListModel = OrderListModel.fromJson(data);
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

  fetchNextPage(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingNextPage(true);

    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request =
          http.Request('GET', Uri.parse(orderListModel?.nextPageUrl ?? ''));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        final nexOrders =
            List<Datum>.from(data["data"].map((x) => Datum.fromJson(x)));
        for (var element in nexOrders) {
          orderListModel!.data.add(element);
        }
        orderListModel!.nextPageUrl = data["next_page_url"];
        setLoadingNextPage(false);
        return;
      } else {
        setLoadingNextPage(false);
        showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
      }
    } on TimeoutException {
      setLoadingNextPage(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoadingNextPage(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
    }
  }
}
