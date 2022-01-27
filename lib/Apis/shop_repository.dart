import 'package:denta_needs/Responses/Wholesaler/shop_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

class ShopRepository {
  Future<ShopResponse> getShops({name = "", page = 1}) async {
    final response = await http.get(Uri.parse(
        "${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}"));
    return shopResponseFromJson(response.body);
  }

  Future<String> getProductsCount({id}) async {
    final response = await http
        .get(Uri.parse("${AppConfig.BASE_URL}/shop/products/count/$id"));
    return response.body;
  }
 
 }
