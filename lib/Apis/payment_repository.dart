import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Order/order_create_response.dart';
import 'package:denta_needs/Responses/Order/payment_type_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class PaymentRepository {
  Future<List<PaymentTypeResponse>> getPaymentResponseList({mode = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/payment-types?mode=${mode}"),
    );
    return paymentTypeResponseFromJson(response.body);
  }

  Future<OrderCreateResponse> getOrderCreateResponse(payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/order/store"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    print(response.body.toString());
    return orderCreateResponseFromJson(response.body);
  }
  Future<OrderCreateResponse> getOrderCreateResponseFromWallet(
      @required int owner_id,
      @required payment_method,
      @required double amount) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
      "amount": "${amount}"
    });

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/payments/pay/wallet"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

  
    return orderCreateResponseFromJson(response.body);
  }

  Future<OrderCreateResponse> getOrderCreateResponseFromCod(
      @required int owner_id, @required payment_method) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}"
    });

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/payments/pay/cod"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

     
    return orderCreateResponseFromJson(response.body);
  }
 }
