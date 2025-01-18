// To parse this JSON data, do
//
//     final ticketListModel = ticketListModelFromJson(jsonString);

import 'dart:convert';

TicketListModel ticketListModelFromJson(String str) =>
    TicketListModel.fromJson(json.decode(str));

class TicketListModel {
  TicketListModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  dynamic currentPage;
  List<Datum> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  dynamic links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory TicketListModel.fromJson(Map<String, dynamic> json) =>
      TicketListModel(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List.from(json["links"].map((x) => x)),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    this.via,
    this.operatingSystem,
    required this.userAgent,
    required this.description,
    required this.subject,
    required this.status,
    required this.priority,
    required this.departments,
    required this.userId,
    this.adminId,
    required this.createdAt,
    required this.updatedAt,
  });

  dynamic id;
  String title;
  dynamic via;
  dynamic operatingSystem;
  dynamic userAgent;
  dynamic description;
  dynamic subject;
  dynamic status;
  dynamic priority;
  dynamic departments;
  dynamic userId;
  dynamic adminId;
  dynamic createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        via: json["via"],
        operatingSystem: json["operating_system"],
        userAgent: json["user_agent"],
        description: json["description"],
        subject: json["subject"],
        status: json["status"],
        priority: json["priority"],
        departments: json["departments"],
        userId: json["user_id"],
        adminId: json["admin_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
