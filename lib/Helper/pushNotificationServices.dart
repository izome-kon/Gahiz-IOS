import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Screens/MyOrders/OrderDetails.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class PushNotificationService {
  UserProvider prov;

  /// Init notification services
  Future initialise(context) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    prov = Provider.of<UserProvider>(context, listen: false);

    messaging.getToken().then((value) => print(value));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (await Freshchat.isFreshchatNotification(message.data)) {
        Freshchat.handlePushNotification(message.data);
      } else {
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
        showSimpleNotification(
          InkWell(
            onTap: message.data['item_type'] == 'order'
                ? () {
                    MyApp.navigatorKey.currentState.push(MaterialPageRoute(
                        builder: (_) => OrderDetailsPage(
                              id: int.parse(message.data['item_type_id']),
                            )));
                  }
                : null,
            child: Text(
              '${message.notification.title}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            '${message.notification.body}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          slideDismiss: true,
          duration: Duration(seconds: 3),
          leading: Icon(
            Icons.notifications_active_outlined,
            color: Colors.white,
          ),
          background: accentColor,
        );

        prov.loadUnRead();
        FlutterRingtonePlayer.play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          asAlarm: false, // Android only - all APIs
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(message.data);
      if (await Freshchat.isFreshchatNotification(message.data)) {
        Freshchat.handlePushNotification(message.data);
      }

      if (message.data['item_type'] == 'order') {
        MyApp.navigatorKey.currentState.push(MaterialPageRoute(
            builder: (_) => OrderDetailsPage(
                  id: int.parse(message.data['item_type_id']),
                )));
      }
    });
  }
}
