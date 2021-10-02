import 'dart:convert';

import 'package:denta_needs/Responses/Notifications/NotificationResponse.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  Future<NotificationResponse> getNotifications({userID}) async {
    print(userID);
    final response = await http.get(
      "${AppConfig.BASE_URL}/notifications/$userID",
    );
print(response.body);
    return notificationResponseFromJson(response.body);
  }

  Future<List<Notification>> getUnReadNotifications({userID}) async {
    print(userID);
    final response = await http.get(
      "${AppConfig.BASE_URL}/notifications/unread/$userID",
    );

    return List<Notification>.from(
        jsonDecode(response.body).map((x) => Notification.fromJson(x)));
  }
  Future<void> setAsRead({userID}) async {
    print(userID);
    final response = await http.get(
      "${AppConfig.BASE_URL}/notifications/markAsRead/$userID",
    );
  }
}
