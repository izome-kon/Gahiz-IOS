import 'dart:developer';

import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Cart/cart_add_response.dart';
import 'package:denta_needs/Responses/Cart/cart_delete_response.dart';
import 'package:denta_needs/Responses/Cart/cart_process_response.dart';
import 'package:denta_needs/Responses/Cart/cart_response.dart';
import 'package:denta_needs/Responses/Cart/cart_summary_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';

class CartRepository {
  Future<List<CartResponse>> getCartResponseList(
    @required int user_id,
  ) async {
    final response = await http.post(
      "${AppConfig.BASE_URL}/carts/$user_id",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.value}"
      },
    );
    print(response.body);
    return cartResponseFromJson(response.body);
  }

  Future<CartDeleteResponse> getCartDeleteResponse(
    @required int cart_id,
  ) async {
    final response = await http.delete(
      "${AppConfig.BASE_URL}/carts/$cart_id",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.value}"
      },
    );

    return cartDeleteResponseFromJson(response.body);
  }

  Future<CartDeleteResponse> getCartDeleteAllResponse(cart_id) async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/carts/deleteAll/$cart_id",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.value}"
      },
    );

    return cartDeleteResponseFromJson(response.body);
  }

  Future<CartProcessResponse> getCartProcessResponse(
      @required String cart_ids, @required String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});
    try {
      final response = await http.post("${AppConfig.BASE_URL}/carts/process",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${access_token.value}"
          },
          body: post_body);
      return cartProcessResponseFromJson(response.body);
    } catch (e) {}
    return CartProcessResponse(result: false, message: 'Something Error!');
  }

  Future<CartAddResponse> getCartAddResponse(
      @required int id,
      @required String variant,
      @required int user_id,
      @required int quantity) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "variant": "$variant",
      "user_id": "$user_id",
      "quantity": "$quantity"
    });

    final response = await http.post("${AppConfig.BASE_URL}/carts/add",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);

    print(response.body.toString());
    return cartAddResponseFromJson(response.body);
  }

  Future<void> getCartAddCollectionResponse(
      @required String variant,
      @required int user_id,
      @required Map<String, dynamic> productsList) async {
    print(productsList.keys.length);
    print(jsonEncode(productsList));

    var post_body = jsonEncode({
      "products_ids": jsonEncode(productsList),
      "variant": "$variant",
      "user_id": "$user_id",
      // "qtys": "$productsQtysEdited"
    });

    final response =
        await http.post("${AppConfig.BASE_URL}/carts/add-sum-products",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.value}"
            },
            body: post_body);

    log(response.body);

    // return cartAddResponseFromJson(response.body);
  }

  Future<CartSummaryResponse> getCartSummaryResponse(@required owner_id) async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/cart-summary/${user_id.value}/${owner_id}",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.value}"
      },
    );

    return cartSummaryResponseFromJson(response.body);
  }

  Future<CartAddResponse> getCartAddVoiceRecordResponse({
    @required int user_id,
    @required int owner_user_id,
    @required String image,
    @required String filename,
    @required String description,
    @required String order_type,
  }) async {
    print("${AppConfig.BASE_URL}/carts/addVoiceRecord");
    var post_body = jsonEncode({
      "user_id": "$user_id",
      "image": "$image",
      "description": description,
      "filename": "$filename",
      "owner_user_id": owner_user_id,
      "order_type": order_type
    });

    final response =
        await http.post("${AppConfig.BASE_URL}/carts/addVoiceRecord",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.value}"
            },
            body: post_body);

    print(response.body.toString());
    return cartAddResponseFromJson(response.body);
  }
}
