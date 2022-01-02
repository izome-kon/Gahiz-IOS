import 'package:denta_needs/Apis/notification_repositories.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/Notifications/NotificationResponse.dart';
import 'package:denta_needs/Screens/Cart/product_cart_card.dart';
import 'package:denta_needs/Screens/Notification/notification_card.dart';

import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationResponse notificationResponse;

  getData() async {
    notificationResponse =
        await NotificationRepository().getNotifications(userID: user_id.$);

    NotificationRepository().setAsRead(userID: user_id.$);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  buildIsEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Lottie.asset('assets/lottie/notification_empty.json')),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          getLang(context, "You Dont Have Notifications"),
          style: TextStyle(fontSize: 16, color: fontColor),
        ),
      ],
    );
  }

  buildNotificationList() {
    return ListView.builder(
      itemBuilder: (context, index) => NotificationCard(
        notification: notificationResponse.notifications[index],
      ),
      itemCount: notificationResponse.notifications.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          getLang(context, 'notification'),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        color: accentColor,
        child: notificationResponse != null
            ? notificationResponse.notifications.length == 0
                ? buildIsEmpty()
                : buildNotificationList()
            : ShimmerHelper().buildListShimmer(),
        onRefresh: () async {
          notificationResponse = null;
          setState(() {});
          getData();
        },
      ),
    );
  }
}
