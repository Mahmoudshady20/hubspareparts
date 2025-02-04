import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/ticket_list_service.dart';

import '../helpers/common_helper.dart';

class NewTicketService with ChangeNotifier {
  String? title;
  String? subject;
  String? selectedPriority = 'Low';
  String? description;
  List? allDepartment;
  bool isLoading = false;
  Datum? selectedDepartment;
  List<String> departmentNames = [];
  List<String> priority = [
    'Low',
    'Normal',
    'High',
    'Urgent',
  ];
  var header = {
    //if header type is application/json then the data should be in jsonEncode method
    "Accept": "application/json",
    // "Authorization": "Bearer $globalUserToken",
  };

  setTitle(value) {
    title = value;
    notifyListeners();
  }

  setSelectedPriority(value) {
    selectedPriority = value;
    notifyListeners();
  }

  setSelectedDepartment(value) {
    selectedDepartment =
        allDepartment!.firstWhere((element) => element.name == value);
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

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  clearAllData() {
    title = '';
    subject = '';
    allDepartment = [];
    notifyListeners();
  }

  addNewToken(
    BuildContext context,
  ) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    print('fetching departments');
    setIsLoading(true);
    try {
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/ticket/create'));
      request.fields.addAll({
        'title': title!,
        'subject': subject!,
        'priority': selectedPriority!,
        'description': description!,
        'departments': selectedDepartment!.id.toString()
      });
      print({
        'title': title!,
        'subject': subject!,
        'priority': selectedPriority!,
        'description': description!,
        'departments': selectedDepartment.toString()
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);

        await Provider.of<TicketListService>(context, listen: false)
            .fetchAllTickets(context);
        setIsLoading(false);
        Navigator.of(context).pop();
        return;
      } else {
        setIsLoading(false);
        showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      setIsLoading(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setIsLoading(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
      print(err);
    }
  }

  Future fetchDepartments(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      allDepartment = [];
      notifyListeners();
      return;
    }
    print('fetching departments');

    try {
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.MultipartRequest(
          'GET', Uri.parse('$baseApi/user/get-department'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);

        allDepartment = DeparmentModel.fromJson(data).data;

        List<String> nameData = [];
        for (var element in allDepartment!) {
          nameData.add(element.name);
        }
        departmentNames = nameData;
        print(departmentNames);
        selectedDepartment = allDepartment![0];
        notifyListeners();
        return;
      } else {
        allDepartment = [];
        notifyListeners();
        showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      allDepartment = [];
      notifyListeners();
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      allDepartment = [];
      notifyListeners();
      showToast(err.toString(), cc.red);
      print(err);
    }
  }
}

DeparmentModel deparmentModelFromJson(String str) =>
    DeparmentModel.fromJson(json.decode(str));

String deparmentModelToJson(DeparmentModel data) => json.encode(data.toJson());

class DeparmentModel {
  DeparmentModel({
    required this.data,
  });

  List<Datum> data;

  factory DeparmentModel.fromJson(Map<String, dynamic> json) => DeparmentModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.status,
  });

  int id;
  String name;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };
}
