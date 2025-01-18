// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:safecart/helpers/common_helper.dart';
// import 'package:safecart/models/country_model_ll.dart';
// import 'package:safecart/models/state_model.dart' as state;

// class CountryStateService with ChangeNotifier {
//   List<Country?>? countries;
//   List<String> countryNameList = [];
//   List<String> stateNameList = [];
//   List<state.State?>? states = [];

//   getCountryId(name) {
//     print(name);
//     final value = countries!.firstWhere((element) => element!.name == name);
//     return value?.id;
//   }

//   getStateId(name) {
//     final value = states!.firstWhere((element) => element!.name == name);
//     return value?.id;
//   }

//   fetchAllCountry(BuildContext context) async {
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       countries = [];
//       states = [];

//       return;
//     }
//     try {
//       print('fetching country');
//       var request = http.MultipartRequest('GET', Uri.parse('$baseApi/country'));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final data = CountryModel.fromJson(
//             jsonDecode(await response.stream.bytesToString()));
//         data.countries;
//         countries = data.countries ?? [];
//         for (var element in countries!) {
//           if (countryNameList.contains(element!.name)) {
//             continue;
//           }
//           countryNameList.add(element.name!);
//         }
//         // print(countryNameList);
//         notifyListeners();
//       } else {
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       print(err);
//     }
//   }

//   fetchAllStates(BuildContext context, id) async {
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       return;
//     }

//     states = null;
//     notifyListeners();
//     try {
//       var request =
//           http.MultipartRequest('GET', Uri.parse('$baseApi/state/$id'));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final data = state.StateModel.fromJson(
//             jsonDecode(await response.stream.bytesToString()));
//         states = data.state ?? [];
//         for (var element in states!) {
//           if (stateNameList.contains(element!.name)) {
//             continue;
//           }
//           stateNameList.add(element.name!);
//         }
//         notifyListeners();
//       } else {
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       print(err);
//     }
//   }
// }
