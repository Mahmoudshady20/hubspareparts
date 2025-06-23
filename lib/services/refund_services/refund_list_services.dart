import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:safecart/models/refund_model.dart';
import 'package:safecart/helpers/common_helper.dart';

class RefundService with ChangeNotifier {
  RefundModel? refundModel;
  bool isLoading = false;
  bool loadingNextPage = false;
  bool loadingNextPageFailed = false;

  setLoadingNextPage(bool value) {
    if (value == loadingNextPage) return;
    loadingNextPage = value;
    notifyListeners();
  }

  setLoadingNextPageFailed(bool value) {
    if (value == loadingNextPageFailed) return;
    loadingNextPageFailed = value;
    notifyListeners();
  }

  Future<void> fetchRefundList(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) return;

    try {
      var headers = {
        'Authorization': 'Bearer $getToken',
      };
      var request = http.Request('GET', Uri.parse('$baseApi/refund-requests/all'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        refundModel = RefundModel.fromJson(data);
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

  Future<void> fetchNextPage(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) return;
    setLoadingNextPage(true);

    try {
      var nextPageUrl = refundModel?.data?.meta?.pagination?.currentPage !=
          refundModel?.data?.meta?.pagination?.lastPage
          ? '$baseApi/refund-requests/all?page=${(refundModel?.data?.meta?.pagination?.currentPage ?? 1) + 1}'
          : null;

      if (nextPageUrl == null) {
        setLoadingNextPage(false);
        return;
      }

      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.Request('GET', Uri.parse(nextPageUrl));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        final newRefundModel = RefundModel.fromJson(responseData);
        final newData = newRefundModel.data?.data ?? [];

        refundModel?.data?.data?.addAll(newData);
        refundModel?.data?.meta = newRefundModel.data?.meta;

        setLoadingNextPage(false);
        notifyListeners();
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
