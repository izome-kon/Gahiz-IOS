import 'package:badges/badges.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Screens/Notification/notification.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationButton extends StatefulWidget {
  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).loadUnRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NotificationPage(),
                ),
              ).then((_) {
                value.loadUnRead();
              });
            },
            icon: value.unReadNotifications != null
                ? value.unReadNotifications.length != 0
                    ? Badge(
                        badgeContent: Text(
                          value.unReadNotifications.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )
                : Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ));
      },
    );
  }
}
