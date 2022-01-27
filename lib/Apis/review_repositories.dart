import 'package:denta_needs/Responses/Product/review_response.dart';
import 'package:denta_needs/Responses/Product/review_submit_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReviewRepository {
  Future<ReviewResponse> getReviewResponse(@required int product_id,
      {page = 1}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/reviews/product/${product_id}?page=${page}"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    return reviewResponseFromJson(response.body);
  }

  Future<ReviewSubmitResponse> getReviewSubmitResponse(
    @required int product_id,
    @required int rating,
    @required String comment,
  ) async {
    var post_body = jsonEncode({
      "product_id": "${product_id}",
      "rating": "$rating",
      "comment": "$comment"
    });
    print(post_body.toString());
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/reviews/submit"),
            headers: {
              "Content-Type": "application/json",
            },
            body: post_body);

    return reviewSubmitResponseFromJson(response.body);
  }
}
