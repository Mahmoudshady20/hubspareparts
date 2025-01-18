import 'dart:convert';

TicketChatModel ticketListModelFromJson(String str) =>
    TicketChatModel.fromJson(json.decode(str));

class TicketChatModel {
  TicketChatModel({
    required this.ticketDetails,
    required this.allMessages,
  });

  TicketDetails ticketDetails;
  List<AllMessage> allMessages;

  factory TicketChatModel.fromJson(Map<String, dynamic> json) =>
      TicketChatModel(
        ticketDetails: TicketDetails.fromJson(json["ticket_details"]),
        allMessages: List<AllMessage>.from(
            json["all_messages"].map((x) => AllMessage.fromJson(x))),
      );
}

class AllMessage {
  AllMessage({
    required this.id,
    required this.message,
    required this.notify,
    this.attachment,
    required this.type,
    required this.supportTicketId,
  });

  dynamic id;
  String message;
  String notify;
  String? attachment;
  String type;
  dynamic supportTicketId;

  factory AllMessage.fromJson(Map<String, dynamic> json) => AllMessage(
        id: json["id"],
        message: json["message"],
        notify: json["notify"],
        attachment: json["attachment"],
        type: json["type"],
        supportTicketId: json["support_ticket_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "notify": notify,
        "attachment": attachment,
        "type": type,
        "support_ticket_id": supportTicketId,
      };
}

class TicketDetails {
  TicketDetails({
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
  });

  dynamic id;
  String title;
  dynamic via;
  dynamic operatingSystem;
  String userAgent;
  String description;
  String subject;
  String status;
  String priority;
  dynamic departments;
  dynamic userId;
  dynamic adminId;

  factory TicketDetails.fromJson(Map<String, dynamic> json) => TicketDetails(
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
      );
}
