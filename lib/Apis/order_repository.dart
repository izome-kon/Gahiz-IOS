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
    var url = "${AppConfig.BASE_URL}/purchase-history/" +
        user_id.toString() +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}";

    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderMiniResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({@required int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-details/" + id.toString();

    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderDetailResponseFromJson(response.body);
  }

  Future<OrderItemResponse> getOrderItems({@required int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-items/" + id.toString();

    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderItemlResponseFromJson(response.body);
  }
}
