import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Cart/coupon_apply_response.dart';
import 'package:denta_needs/Responses/Cart/coupon_remove_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class CouponRepository {
  Future<CouponApplyResponse> getCouponApplyResponse(
      @required String coupon_code) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.value}",
      "coupon_code": "$coupon_code"
    });
    final response = await http.post("${AppConfig.BASE_URL}/coupon-apply",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);

    return couponApplyResponseFromJson(response.body);
  }

  Future<CouponRemoveResponse> getCouponRemoveResponse(int userID) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.value}",
      "owner_id": "$userID"
    });
    final response = await http.post("${AppConfig.BASE_URL}/coupon-remove",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);

    return couponRemoveResponseFromJson(response.body);
  }
}
