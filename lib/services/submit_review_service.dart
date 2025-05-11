import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/common_helper.dart';

class SubmitReviewService with ChangeNotifier {
  double rating = 5;
  String reviewText = '';
  bool loadingSubmitReview = false;
  bool obscurePassword = true;
  bool rememberPassword = false;

  setLoadingSubmitReview(value) {
    loadingSubmitReview = value;
    notifyListeners();
  }

  setRating(value) {
    if (rating == value) {
      return;
    }
    rating = value;
    notifyListeners();
  }

  setReviewText(value) {
    reviewText = value;
  }

  submitReview(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingSubmitReview(true);
    try {
      var headers = {
        'Authorization': 'Bearer $getToken',
      };
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/product-review'));
      request.fields.addAll({
        'id': id.toString(),
        'rating': rating.toInt().toString(),
        'comment': reviewText,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        await Provider.of<ProductDetailsService>(context, listen: false)
            .fetchProductDetails(id);
        showToast(AppLocalizations.of(context)!.review_submitted, cc.primaryColor);
        setLoadingSubmitReview(false);
        return;
      } else {
        showToast(AppLocalizations.of(context)!.review_submission_failed, cc.red);
        setLoadingSubmitReview(false);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      setLoadingSubmitReview(false);
    } catch (err) {
      showToast(err.toString(), cc.red);
      setLoadingSubmitReview(false);
    }
  }
}
