// To parse this JSON data, do
//
//     final cartAddResponse = cartAddResponseFromJson(jsonString);

import 'dart:convert';

CartAddResponse cartAddResponseFromJson(String str) =>
    CartAddResponse.fromJson(json.decode(str));

String cartAddResponseToJson(CartAddResponse data) =>
    json.encode(data.toJson());

class CartAddResponse {
  CartAddResponse({this.result, this.message, this.cartId});

  bool result;
  String message;
  int cartId;

  factory CartAddResponse.fromJson(Map<String, dynamic> json) =>
      CartAddResponse(
        result: json["result"],
        message: json["message"],
        cartId: json["cart_id"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}
