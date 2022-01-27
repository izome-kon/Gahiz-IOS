// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromJson(jsonString);

import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  NotificationResponse({
    this.notifications,
    this.result,
  });

  List<Notification> notifications;
  bool result;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromJson(x))),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
        "result": result,
      };
}

class Notification {
  Notification({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String type;
  String notifiableType;
  int notifiableId;
  Data data;
  DateTime readAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: Data.fromJson(json["data"]),
        readAt:
            json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data.toJson(),
        "read_at": readAt == null ? null : readAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Data {
  Data({
    this.title,
    this.body,
    this.orderId,
    this.type,
  });

  String title;
  String body;
  String type;
  int orderId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        body: json["body"],
        type: json["type"] == null ? null : json["type"],
        orderId: json["order_id"] == null ? null : json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "order_id": orderId,
        "type": type,
      };
}
