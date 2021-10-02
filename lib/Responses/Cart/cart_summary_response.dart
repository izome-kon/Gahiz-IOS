// To parse this JSON data, do
//
//     final cartSummaryResponse = cartSummaryResponseFromJson(jsonString);

import 'dart:convert';

CartSummaryResponse cartSummaryResponseFromJson(String str) => CartSummaryResponse.fromJson(json.decode(str));

String cartSummaryResponseToJson(CartSummaryResponse data) => json.encode(data.toJson());

class CartSummaryResponse {
  CartSummaryResponse({
    this.sub_total,
    this.tax,
    this.shipping_cost,
    this.discount,
    this.grand_total,
    this.grand_total_value,
    this.coupon_code,
    this.coupon_applied,
    this.currency_symbol
  });

  double sub_total;
  double tax;
  double shipping_cost;
  double discount;
  double grand_total;
  double grand_total_value;
  String coupon_code;
  bool coupon_applied;
  String currency_symbol;

  factory CartSummaryResponse.fromJson(Map<String, dynamic> json) => CartSummaryResponse(
    sub_total: json["sub_total"].toDouble(),
    tax: json["tax"].toDouble(),
    currency_symbol: json["currency_symbol"],
    shipping_cost: json["shipping_cost"].toDouble(),
    discount: json["discount"].toDouble(),
    grand_total: json["grand_total"].toDouble(),
    grand_total_value: json["grand_total_value"].toDouble(),
    coupon_code: json["coupon_code"],
    coupon_applied: json["coupon_applied"],
  );

  Map<String, dynamic> toJson() => {
    "sub_total": sub_total,
    "tax": tax,
    "shipping_cost": shipping_cost,
    "discount": discount,
    "grand_total": grand_total,
    "grand_total_value": grand_total_value,
    "coupon_code": coupon_code,
    "coupon_applied": coupon_applied,
  };
}