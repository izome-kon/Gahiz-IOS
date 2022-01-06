import 'dart:convert';

import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/Cart/cart_process_response.dart';
import 'package:denta_needs/Responses/Order/order_create_response.dart';
import 'package:denta_needs/Responses/Order/order_detail_response.dart';
import 'package:denta_needs/Responses/Order/order_item_response.dart';
import 'package:denta_needs/Responses/Order/order_mini_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OrderRepository {
  Future<OrderMiniResponse> getOrderList(
      {@required int user_id = 0,
      page = 1,
      payment_status = "",
      delivery_status = ""}) async {
    var url = Uri.parse("${AppConfig.BASE_URL}/purchase-history/" +
        user_id.toString() +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}");

    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderMiniResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({@required int id = 0}) async {
    var url = Uri.parse(
        "${AppConfig.BASE_URL}/purchase-history-details/" + id.toString());

    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderDetailResponseFromJson(response.body);
  }

  Future<OrderItemResponse> getOrderItems({@required int id = 0}) async {
    var url = Uri.parse(
        "${AppConfig.BASE_URL}/purchase-history-items/" + id.toString());

    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderItemlResponseFromJson(response.body);
  }

  Future<OrderCreateResponse> confirmOrder({
    @required int orderId,
    @required String status,
  }) async {
    print("${AppConfig.BASE_URL}/order/confirm");
    var post_body = jsonEncode({
      "order_id": orderId,
      "status": status,
    });
    print(access_token.$);
    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/order/confirm"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    print(response.body.toString());
    return orderCreateResponseFromJson(response.body);
  }
}
