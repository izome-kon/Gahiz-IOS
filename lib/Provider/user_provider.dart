import 'package:denta_needs/Apis/notification_repositories.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/Notifications/NotificationResponse.dart'
    as noti;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserProvider extends ChangeNotifier {
  LatLng address;
  String addressString;
  String addressArea;
  String addressCity;

  List<noti.Notification> unReadNotifications;

  updateUserLocation({address, addressString, addressArea, addressCity}) {
    this.address = address;
    this.addressString = addressString;
    this.addressArea = addressArea;
    this.addressCity = addressCity;
    notifyListeners();
  }

  loadUnRead() async {
    unReadNotifications = await NotificationRepository()
        .getUnReadNotifications(userID: user_id.$);

    notifyListeners();
  }
}
