import 'package:denta_needs/Responses/Notifications/NotificationResponse.dart'
as not;
import 'package:denta_needs/Screens/MyOrders/OrderDetails.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class NotificationCard extends StatefulWidget {
  final not.Notification notification;

  NotificationCard({this.notification});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.notification.data.orderId != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) =>
              OrderDetailsPage(id: widget.notification.data.orderId,)));
        }
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          width: MediaQuery
              .of(context)
              .size
              .width,
          margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: widget.notification.readAt == null
                      ? accentColor.withOpacity(0.7)
                      : Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${widget.notification.data.title}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ],
              ),
              Divider(),
              Flexible(
                child: Text(
                  '${widget.notification.data.body}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fontColor.withOpacity(0.7),
                      fontSize: 13),
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  Icon(
                    Icons.schedule,
                    color: accentColor,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Jiffy(widget.notification.createdAt).fromNow(),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
