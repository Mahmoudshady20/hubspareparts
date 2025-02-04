import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/models/search_filter_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/common_helper.dart';

class SearchFilterDataService with ChangeNotifier {
  SearchFilterDataModel? filterOprions;

  dynamic selectedCategory;
  List selectedCategorySubList = [];
  List selectedSubcategoryChildList = [];
  dynamic selectedSubCategory = '';
  bool lodingCategoryProducts = false;
  dynamic selectedChildCats = '[]';
  double minPrice = 0;
  double maxPrice = 1000;
  double? selectedMinPrice;
  double? selectedMaxPrice;
  int selectedRating = 0;
  String selectedColor = '';
  String selectedSize = '';
  String selectedBrand = '';
  dynamic selectedTags;
  dynamic selectedCategorieId = 1;
  bool loading = false;
  bool noSubcategory = false;

  setSelectedCategory(value) {
    if (selectedCategory == value || (value ?? '').isEmpty) {
      selectedChildCats = '';
      selectedSubCategory = null;
      lodingCategoryProducts = true;
      selectedCategory = '';
      selectedCategorySubList = [];
      notifyListeners();
      return;
    }
    selectedChildCats = '';
    selectedSubCategory = null;
    lodingCategoryProducts = true;
    selectedCategorySubList = filterOprions?.allCategory
            ?.firstWhere((element) => element.name == value)
            .subCategories ??
        [];
    selectedCategory = value;
    notifyListeners();
  }

  setSelectedSubCategory(subCat) {
    if (selectedSubCategory == subCat || (subCat ?? '').isEmpty) {
      selectedChildCats = '';
      selectedSubCategory = '';
      selectedSubcategoryChildList = [];
      notifyListeners();
      return;
    }
    selectedChildCats = '';
    selectedSubcategoryChildList =
        selectedCategorySubList.firstWhere((element) {
              print(element.name == subCat);
              return element.name == subCat;
            }).childCategories ??
            [];
    selectedSubCategory = subCat;
    notifyListeners();
  }

  setSelectedChildCats(childCat) {
    print(childCat);
    if (selectedChildCats == childCat || (childCat ?? '').isEmpty) {
      selectedChildCats = '';
      notifyListeners();
      return;
    } else {
      selectedChildCats = childCat;
    }
    notifyListeners();
  }

  setSelectedColor(value) {
    if (value == selectedColor || (value ?? '').isEmpty) {
      selectedColor = '';
      notifyListeners();
      return;
    }
    selectedColor = value;
    notifyListeners();
  }

  setSelectedSize(value) {
    if (value == selectedSize || (value ?? '').isEmpty) {
      selectedSize = '';
      notifyListeners();
      return;
    }
    selectedSize = value;
    notifyListeners();
  }

  setSelectedBrand(value) {
    if (value == selectedBrand || (value ?? '').isEmpty) {
      selectedBrand = '';
      notifyListeners();
      return;
    }
    print(value);
    selectedBrand = value;
    notifyListeners();
  }

  setSelectedTags(value) {
    if (selectedTags.contains(value)) {
      selectedTags.remove(value);
      notifyListeners();
      return;
    }
    selectedTags.add(value);
    notifyListeners();
  }

  setSelectedRating(value) {
    if (value == selectedRating) {
      return;
    }
    selectedRating = value;
    notifyListeners();
  }

  setRangeValues(RangeValues value) {
    selectedMinPrice = value.start.toDouble();
    selectedMaxPrice = value.end.toDouble();
    notifyListeners();
  }

  setSelectedMinPrice(value) {
    selectedMinPrice = value ?? minPrice;
    notifyListeners();
  }

  setSelectedMaxPrice(value) {
    selectedMaxPrice = value ?? maxPrice;
    notifyListeners();
  }

  resetSelectedSearchFilter() {
    selectedCategory = '';
    selectedCategorySubList = [];
    selectedSubcategoryChildList = [];
    selectedSubCategory = '';
    selectedChildCats = '';
    selectedMinPrice;
    selectedMaxPrice;
    selectedRating = 0;
    selectedColor = '';
    selectedSize = '';
    selectedBrand = '';
    selectedTags;
  }

  setFilterAccordingToSearch(
      {cat, subCat, childCat, size, color, brand, minPrize, maxPrize, rating}) {
    selectedCategory = cat;
    if (cat.isNotEmpty) {
      selectedChildCats = '';
      selectedSubCategory = null;
      lodingCategoryProducts = true;
      selectedCategorySubList = filterOprions?.allCategory
              ?.firstWhere((element) => element.name == cat)
              .subCategories ??
          [];
      selectedCategory = cat;
    }
    selectedSubCategory = subCat;
    if (subCat.isNotEmpty) {
      selectedSubcategoryChildList =
          selectedCategorySubList.firstWhere((element) {
                print(element.name == subCat);
                return element.name == subCat;
              }).childCategories ??
              [];
      selectedSubCategory = subCat;
    }
    selectedChildCats = childCat;
    selectedMinPrice = minPrize;
    selectedMaxPrice = maxPrize;
    selectedRating = rating;
    selectedColor = color;
    selectedSize = size;
    selectedBrand = brand;
    notifyListeners();
  }

  Future fetchSearchfilterData(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var request = http.Request('GET', Uri.parse('$baseApi/search-items'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // final pref = await SharedPreferences.getInstance();
        responseString = await response.stream.bytesToString();
        sPref.setString("res_string", responseString);
        final receivePort = ReceivePort();
        debugPrint(responseString.toString());
        // IsolateController.spawn<String>(
        //   isolateTask,
        //   receivePort.sendPort,
        // );
        final isolate =
            await IsolateController.spawn<String, SearchFilterDataModel>(
          isolateTask,
          responseString,
        )
              ..stream.listen((event) {
                debugPrint(event.toString());
                setFilterOptions(event);
              });
        Future.delayed(const Duration(seconds: 10))
            .then((value) => isolate.close);
      } else {
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      print(err);
    }
  }

  String responseString = "";
  setFilterOptions(value) {
    filterOprions = value;
    debugPrint("updating filter options $filterOprions".toString());
  }
}

void isolateTask(payLoad, send) async {
  debugPrint("isolate start");
  try {
    int total = 1;
    for (int i = 1; i < 1236541041; i++) {
      /// Multiplies each index by the multiplier and computes the total
      total += (i * 1254);
    }

    // final pref = await SharedPreferences.getInstance();
    // final responseString = pref.getString("res_string") ?? "";
    debugPrint(total.toString());
    debugPrint(payLoad.toString());

    final data = jsonDecode(payLoad);
    final filterOptions = SearchFilterDataModel.fromJson(data);
    send(filterOptions);
  } catch (err) {
    print(err);
  }
}

typedef IsolateHandler<Payload, Out> = FutureOr<void> Function(
  Payload payload,
  void Function(Out out) send,
);

class IsolateController<Out> {
  IsolateController._({
    required this.stream,
    required this.close,
  });

  static Future<void> _$entryPoint<Payload, Out>(
      _IsolateArgument<Payload, Out> argument) async {
    try {
      await argument();
    } finally {
      // Send a message to the main isolate about the exit.
      argument.sendPort.send(#exit);
    }
  }

  static Future<IsolateController<Out>> spawn<Payload, Out>(
    IsolateHandler<Payload, Out> handler,
    Payload payload,
  ) async {
    // Create a [ReceivePort] to receive messages from the isolate.
    // You can create more than one [ReceivePort] to receive messages from the
    // isolate. E.g. separate ports for output, errors, and control messages.
    final receivePort = ReceivePort();
    final argument = _IsolateArgument<Payload, Out>(
      handler: handler,
      payload: payload,
      // Send the [SendPort] of the [ReceivePort] to the isolate.
      sendPort: receivePort.sendPort,
    );
    final isolate = await Isolate.spawn<_IsolateArgument<Payload, Out>>(
      _$entryPoint<Payload, Out>,
      argument,
      errorsAreFatal: true,
      debugName: 'MyIsolate',
    );

    // The output stream controller of the isolate.
    final outputController = StreamController<Out>.broadcast();

    // The subscription to the receive port.
    late final StreamSubscription<Object?> rcvSubscription;

    void close() {
      // Close the receive port and the output stream controller.
      receivePort.close();
      rcvSubscription.cancel().ignore();
      outputController.close().ignore();
      isolate.kill();
    }

    // Listen to the [ReceivePort] and forward messages to the output stream.
    rcvSubscription = receivePort.listen(
      (message) {
        if (message is Out) {
          // Received a message from the isolate.
          outputController.add(message);
        } else if (message == #exit) {
          // Received a message from the isolate about the exit.
          close();
        }
      },
      onError: outputController.addError,
      cancelOnError: false,
    );

    return IsolateController<Out>._(
      // Pass the stream from [ReceivePort] to the constructor.
      stream: outputController.stream,
      close: close,
    );
  }

  /// The output stream of the isolate.
  final Stream<Out> stream;

  final void Function() close;
}

class _IsolateArgument<Payload, Out> {
  _IsolateArgument({
    required this.handler,
    required this.payload,
    required this.sendPort,
  });

  final IsolateHandler<Payload, Out> handler;

  final Payload payload;

  /// For sending messages from the spawned isolate to the main isolate.
  final SendPort sendPort;

  FutureOr<void> call() => handler(
        payload,
        (Out data) => sendPort.send(data),
      );
}
