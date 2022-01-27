import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/order_repository.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Order/order_detail_response.dart';
import 'package:denta_needs/Responses/Order/order_item_response.dart';
import 'package:denta_needs/Screens/MyOrders/order_feedback.dart';
import 'package:denta_needs/Screens/MyOrders/persistentHander.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OrderDetailsPage extends StatefulWidget {
  final int id;

  OrderDetailsPage({this.id});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<OrderDetailsPage> {
  OrderDetailResponse orderDetailsPage;
  OrderItemResponse orderItemResponse;
  var _steps = [
    'pending',
    'request_confirm',
    'confirmed',
    'on_the_way',
    'delivered'
  ];

  int _stepIndex = 0;

  bool loadingConfirm = false;

  getData() async {
    orderDetailsPage = await OrderRepository().getOrderDetails(id: widget.id);
    if (orderDetailsPage.detailed_orders.length > 0) {
      var _orderDetails = orderDetailsPage.detailed_orders[0];
      setStepIndex(_orderDetails.delivery_status);
    }
    orderItemResponse = await OrderRepository().getOrderItems(id: widget.id);
    setState(() {});
  }

  setStepIndex(key) {
    print(key);
    _stepIndex = _steps.indexOf(key);
    print(orderDetailsPage.detailed_orders[0].rate);
    if (_stepIndex >= 4 && orderDetailsPage.detailed_orders[0].rate == 0.0)
      showRate();
    setState(() {});
  }

  Card buildOrderedProductItemsCard(OrderItem item) {
    print('img=' + item.thumbnail_image);
    return Card(
      shape: RoundedRectangleBorder(
        side:
            new BorderSide(color: Colors.black87.withOpacity(0.2), width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                item.product_name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87.withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    child: FullScreenWidget(
                        child: Hero(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: AppConfig.BASE_PATH_FOR_NETWORK +
                            item.thumbnail_image,
                        width: 120,
                      ),
                      tag: 'productImage${item.thumbnail_image}',
                    )),
                  ),
                  Spacer(),
                  Text(
                    item.quantity.toString() + " x ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  item.variation != "" && item.variation != null
                      ? Text(
                          item.variation,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          getLang(context, "item"),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  Spacer(),
                  Text(
                    item.price,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// timeline
  buildTimeLineTiles() {
    return SizedBox(
      height: 100,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              isFirst: true,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.redAccent, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.list_alt,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getLang(context, "Order placed"),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: _stepIndex >= 0 ? Colors.green : fontColor,
                padding: const EdgeInsets.all(0),
                iconStyle: _stepIndex >= 0
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              afterLineStyle: _stepIndex >= 2
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: fontColor,
                      thickness: 4,
                    ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.thumb_up_sharp,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getLang(context, "Confirmed"),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: _stepIndex >= 2 ? Colors.green : fontColor,
                padding: const EdgeInsets.all(0),
                iconStyle: _stepIndex >= 2
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              beforeLineStyle: _stepIndex >= 2
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: fontColor,
                      thickness: 4,
                    ),
              afterLineStyle: _stepIndex >= 3
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: fontColor,
                      thickness: 4,
                    ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.amber, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.amber,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getLang(context, "On Delivery"),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: _stepIndex >= 3 ? Colors.green : fontColor,
                padding: const EdgeInsets.all(0),
                iconStyle: _stepIndex >= 3
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              beforeLineStyle: _stepIndex >= 3
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: fontColor,
                      thickness: 4,
                    ),
              afterLineStyle: _stepIndex >= 4
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: fontColor,
                      thickness: 4,
                    ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              isLast: true,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.done_all,
                        color: Colors.purple,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getLang(context, "Delivered"),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: _stepIndex >= 4 ? Colors.green : fontColor,
                padding: const EdgeInsets.all(0),
                iconStyle: _stepIndex >= 4
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              beforeLineStyle: _stepIndex >= 4
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: fontColor,
                      thickness: 4,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  ExpandableNotifier buildOrderDetailsTopCard() {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: ExpandablePanel(
          collapsed: Card(
            shape: RoundedRectangleBorder(
              side: new BorderSide(
                  color: Colors.black87.withOpacity(0.2), width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        getLang(context, "Order Code"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        orderDetailsPage.detailed_orders[0].code,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, "Order Date"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        getLang(context, "Payment Method"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          orderDetailsPage.detailed_orders[0].date,
                          style: TextStyle(
                            color: fontColor.withOpacity(0.7),
                          ),
                        ),
                        Spacer(),
                        Text(
                          orderDetailsPage.detailed_orders[0].payment_type,
                          style: TextStyle(
                            color: fontColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.keyboard_arrow_down_rounded)],
                  )
                ],
              ),
            ),
          ),
          theme: ExpandableThemeData(
            tapBodyToExpand: true,
            useInkWell: true,
            tapBodyToCollapse: true,
            crossFadePoint: 0.1,
          ),
          expanded: Card(
            shape: RoundedRectangleBorder(
              side: new BorderSide(
                  color: Colors.black87.withOpacity(0.2), width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        getLang(context, "Order Code"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        orderDetailsPage.detailed_orders[0].code,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, "Order Date"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        getLang(context, "Payment Method"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          orderDetailsPage.detailed_orders[0].date,
                          style: TextStyle(
                            color: fontColor.withOpacity(0.7),
                          ),
                        ),
                        Spacer(),
                        Text(
                          orderDetailsPage.detailed_orders[0].payment_type,
                          style: TextStyle(
                            color: fontColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, "Payment Status"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        getLang(context, "Delivery Status"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            orderDetailsPage
                                .detailed_orders[0].payment_status_string,
                            style: TextStyle(
                              color: fontColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                        buildPaymentStatusCheckContainer(
                            orderDetailsPage.detailed_orders[0].payment_status),
                        Spacer(),
                        Text(
                          orderDetailsPage
                              .detailed_orders[0].delivery_status_string,
                          style: TextStyle(
                            color: fontColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        getLang(context, "Shipping Address"),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 40),
                          // (total_screen_width - padding)/2
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    getLang(context, "Clinic:"),
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${orderDetailsPage.detailed_orders[0].shipping_address.clinic_name}",
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    getLang(context, "Branch:"),
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${orderDetailsPage.detailed_orders[0].shipping_address.branch_name}",
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    getLang(context, "Address:"),
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${orderDetailsPage.detailed_orders[0].shipping_address.address}",
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    getLang(context, "City:"),
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${orderDetailsPage.detailed_orders[0].shipping_address.city}",
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    getLang(context, "Country:"),
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${orderDetailsPage.detailed_orders[0].shipping_address.country}",
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }

  showRate() {
    showDialog(
        context: context,
        builder: (_) => OrderFeedback(
              id: widget.id,
            ));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_stepIndex != 1) return Future.value(true);
        CoolAlert.show(
          context: context,
          showCancelBtn: true,
          // cancelBtnText: getLang(context, 'cancel'),
          onCancelBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          type: CoolAlertType.warning,
          backgroundColor: whiteColor,
          cancelBtnText: 'Go To Home',
          confirmBtnText: getLang(context, 'Confirm Order'),
          title: getLang(context, "Warning.."),
          text: getLang(context,
              "Your order has not yet been completed. Please review the order and prices and confirm the order by clicking on the Confirm button at the bottom of the screen."),
        );
        return Future.value(false);
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          actions: [],
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            getLang(context, 'Order Details'),
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: primaryColor,
          backgroundColor: Colors.white,
          onRefresh: _onPageRefresh,
          child: Consumer<CartProvider>(
            builder: (context, value, child) {
              return Consumer<UserProvider>(
                builder: (context, value, child) {
                  return CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      _stepIndex == 1
                          ? SliverPersistentHeader(
                              pinned: true,
                              delegate: PersistentHeader(
                                  widget: Container(
                                      color: Colors.amber,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Icon(Icons.warning_amber_rounded),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                              getLang(context,
                                                  'We need to confirm the order and prices and then click on the confirm button below.'),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ))),
                            )
                          : SliverToBoxAdapter(),
                      SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: orderItemResponse != null
                                ? buildTimeLineTiles()
                                : buildTimeLineShimmer()),
                      ),
                      orderDetailsPage == null
                          ? SliverToBoxAdapter(
                              child: ShimmerHelper()
                                  .buildListShimmer(item_height: 100.0),
                            )
                          : SliverToBoxAdapter(
                              child: orderDetailsPage == null
                                  ? ShimmerHelper().buildListShimmer(
                                      item_count: 5, item_height: 20.0)
                                  : Column(
                                      children: [
                                        buildOrderDetailsTopCard(),
                                        Container(
                                          height: 140,
                                          padding: EdgeInsets.all(8),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: accentColor
                                                      .withOpacity(0.3)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  color: accentColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getLang(context, 'Delivery'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${orderDetailsPage.detailed_orders[0].shipping_cost}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: fontColor,
                                                      fontSize: 18),
                                                ),
                                              ]),
                                              Row(children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  color: accentColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getLang(context, "Sub total"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${orderDetailsPage.detailed_orders[0].subtotal}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: fontColor,
                                                      fontSize: 18),
                                                ),
                                              ]),
                                              orderDetailsPage
                                                          .detailed_orders[0]
                                                          .coupon_discount ==
                                                      null
                                                  ? Container()
                                                  : Row(children: [
                                                      Icon(
                                                        Icons.payments_outlined,
                                                        color: accentColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        getLang(context,
                                                            "Discount"),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '${orderDetailsPage.detailed_orders[0].coupon_discount}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                            fontSize: 18),
                                                      ),
                                                    ]),
                                              Row(children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  color: accentColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getLang(context, 'total'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${orderDetailsPage.detailed_orders[0].grand_total}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                      fontSize: 18),
                                                ),
                                              ])
                                            ],
                                          ),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                            ),
                      orderDetailsPage == null
                          ? SliverToBoxAdapter(
                              child: ShimmerHelper()
                                  .buildListShimmer(item_height: 100.0),
                            )
                          : SliverAppBar(
                              leading: Container(),
                              backgroundColor: Colors.white,
                              pinned: true,
                              bottom: PreferredSize(
                                preferredSize:
                                    Size(MediaQuery.of(context).size.width, 0),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Lottie.asset(
                                        'assets/lottie/cart3.json',
                                        width: 30,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        getLang(context, "Products"),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      orderDetailsPage == null
                          ? SliverToBoxAdapter(
                              child: ShimmerHelper()
                                  .buildListShimmer(item_height: 100.0),
                            )
                          : SliverList(
                              delegate: SliverChildListDelegate(
                                  orderItemResponse ==
                                          null
                                      ? [
                                          ShimmerHelper().buildBasicShimmer(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width)
                                        ]
                                      : orderItemResponse.ordered_items
                                          .map((e) =>
                                              buildOrderedProductItemsCard(e))
                                          .toList())),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: _stepIndex == 1
            ? FloatingActionButton(
                backgroundColor: primaryColor,
                tooltip: 'Get Help!',
                child: Icon(
                  Icons.contact_support_outlined,
                  color: whiteColor,
                ),
                onPressed: () {
                  Freshchat.showConversations();
                })
            : null,
        bottomNavigationBar: _stepIndex != 1
            ? FlatButton(
                onPressed: () {
                  Freshchat.showConversations();
                },
                minWidth: MediaQuery.of(context).size.width / 2,
                color: primaryColor,
                child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contact_support_outlined,
                          color: whiteColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          getLang(context, "Contact Us"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    )),
              )
            : FlatButton(
                onPressed: loadingConfirm
                    ? () {}
                    : () {
                        setState(() {
                          loadingConfirm = true;
                        });
                        OrderRepository()
                            .confirmOrder(
                                orderId: widget.id, status: 'confirmed')
                            .then((value) {
                          setState(() {
                            loadingConfirm = false;
                          });
                          if (value.result) {
                            showTopSnackBar(
                              context,
                              CustomSnackBar.success(
                                message: value.message,
                                backgroundColor: Colors.green,
                              ),
                              displayDuration: Duration(seconds: 1),
                            );
                            setState(() {
                              orderDetailsPage = null;
                              orderItemResponse = null;
                              _stepIndex = 0;
                            });
                            getData();
                          } else {
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: value.message,
                              ),
                              displayDuration: Duration(seconds: 1),
                            );
                          }
                        });
                      },
                minWidth: MediaQuery.of(context).size.width / 2,
                color: Colors.green,
                child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    child: loadingConfirm
                        ? CircularProgressIndicator(
                            color: whiteColor,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                getLang(context, "Confirm Order"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          )),
              ),
      ),
    );
  }

  Future<void> _onPageRefresh() async {
    orderDetailsPage = null;
    orderItemResponse = null;
    setState(() {});
    getData();
  }
}
