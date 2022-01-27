import 'package:denta_needs/Apis/order_repository.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Order/order_mini_response.dart';
import 'package:denta_needs/Screens/MyOrders/order_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderMiniResponse ordersList;

  getData() async {
    ordersList = await OrderRepository().getOrderList(user_id: user_id.$);

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: primaryColor),
          actions: [
            IconButton(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh,
                  color: primaryColor,
                ))
          ],
          title: Text(
            getLang(context, 'my_orders'),
            style: TextStyle(color: primaryColor, fontSize: 18),
          ),
        ),
        body: ordersList == null
            ? ShimmerHelper().buildListShimmer()
            : RefreshIndicator(
                child: ordersList.orders.length == 0
                    ? Column(
                        children: [
                          Lottie.asset('assets/lottie/order_empty.json'),
                          Text(
                            getLang(context, 'Not Found Orders'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey),
                          )
                        ],
                      )
                    : ListView.separated(
                        itemCount: ordersList.orders.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return OrderCard(
                            order: ordersList.orders[index],
                            type: ordersList.orders[index].delivery_status ==
                                        "confirmed" ||
                                    ordersList.orders[index].delivery_status ==
                                        'picked_up' ||
                                    ordersList.orders[index].delivery_status ==
                                        'on_the_way'
                                ? OrderCardType.CONFIRM
                                : ordersList.orders[index].delivery_status ==
                                            "delivered" ||
                                        ordersList.orders[index]
                                                .delivery_status ==
                                            "cancelled"
                                    ? OrderCardType.OLD
                                    : OrderCardType.NOW,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            thickness: 0,
                          );
                        }),
                onRefresh: onRefresh));
  }

  Future<void> onRefresh() async {
    ordersList = null;
    setState(() {});
    getData();
  }
}
