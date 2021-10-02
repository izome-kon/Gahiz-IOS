import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/Order/order_mini_response.dart';
import 'package:denta_needs/Screens/MyOrders/OrderDetails.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum OrderCardType { NOW, OLD, CONFIRM }

class OrderCard extends StatefulWidget {
  final OrderCardType type;
  final Order order;

  OrderCard({this.type = OrderCardType.NOW, this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(
                        id: widget.order.id,
                      )));
        },
        child: Row(
          children: [
            Container(
                width: 100,
                height: 100,
                child: widget.type == OrderCardType.CONFIRM ||
                        widget.type == OrderCardType.OLD
                    ? Stack(
                        children: [
                          Positioned(
                            height: 100,
                            width: 100,
                            bottom: 25,
                            child: Lottie.asset(
                                widget.type == OrderCardType.NOW
                                    ? 'assets/lottie/order_review.json'
                                    : widget.type == OrderCardType.CONFIRM
                                        ? 'assets/lottie/order_confirmed.json'
                                        : 'assets/lottie/order_delivered.json',
                                fit: BoxFit.cover,
                                width: 700,
                                repeat: false,
                                height: 700),
                          )
                        ],
                      )
                    : Stack(
                        children: [
                          Lottie.asset(
                              widget.type == OrderCardType.NOW
                                  ? 'assets/lottie/order_review.json'
                                  : widget.type == OrderCardType.CONFIRM
                                      ? 'assets/lottie/order_confirmed.json'
                                      : 'assets/lottie/order_delivered.json',
                              fit: BoxFit.cover,
                              width: 700,
                              height: 700)
                        ],
                      )),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${widget.order.code}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, 'order_time'),
                        style: TextStyle(
                            fontSize: 14, color: fontColor.withOpacity(0.7)),
                      ),
                      Spacer(),
                      Text(
                        "${widget.order.date}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: fontColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, 'Payment status'),
                        style: TextStyle(
                            fontSize: 14, color: fontColor.withOpacity(0.7)),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        decoration: BoxDecoration(
                          color: widget.order.payment_status == 'paid'
                              ? accentColor
                              : Color.fromRGBO(239, 72, 106, 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Text(
                          "${widget.order.payment_status_string}",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, 'Order status'),
                        style: TextStyle(
                            fontSize: 14, color: fontColor.withOpacity(0.7)),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Text(
                          widget.order.delivery_status == 'pending'
                              ? '${widget.order.delivery_status}'
                              : '${widget.order.delivery_status_string}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            getLang(context, 'total'),
                            style: TextStyle(fontSize: 16, color: primaryColor),
                          ),
                          Spacer(),
                          Text(
                            "${widget.order.grand_total}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
