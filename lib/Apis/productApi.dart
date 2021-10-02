import 'dart:convert';

import 'package:denta_needs/Responses/Product/flash_deal_response.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Responses/Product/product_details_response.dart';
import 'package:denta_needs/Responses/Variant/variant_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  Future<ProductMiniResponse> getFeaturedProducts() async {
    final response = await http.get("${AppConfig.BASE_URL}/products/featured");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/products/best-seller");

    return productMiniResponseFromJson(response.body);
  }

  Future<FlashDealResponse> getFlashDeals() async {
    final response = await http.get("${AppConfig.BASE_URL}/flash-deals");

    return FlashDealResponse.fromJson(jsonDecode(response.body));
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/products/todays-deal");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts({int id = 0}) async {
    final response = await http
        .get("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {int id = 0, name = "", page = 1}) async {
    final response = await http.get("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=${page}&name=${name}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {int id = 0, name = "", page = 1}) async {
    var url = "${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}";

    final response = await http.get(url);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProductsByCategories(
      {int id = 0, name = "", List<int> categories, page = 1}) async {
    var url = "${AppConfig.BASE_URL}/categories/shop/products/" +
        id.toString() +
        "?page=${page}&name=${name}";
    print(jsonEncode(categories));
    Map<String, dynamic> data = {};
    for (int i = 0; i < categories.length; i++) {
      data.addAll({"categories[$i]": categories[i].toString()});
    }
    final response = await http.post(url, body: data);
    print(data);
    print(url);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {int id = 0, name = "", page = 1}) async {
    final response = await http.get("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    var url = "${AppConfig.BASE_URL}/products/search" +
        "?page=${page}&name=${name}&sort_key=${sort_key}&brands=${brands}&categories=${categories}&min=${min}&max=${max}";

    //print("url:" + url);
    final response = await http.get(url);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails({int id = 0}) async {
    final response =
        await http.get("${AppConfig.BASE_URL}/products/" + id.toString());
    print("${AppConfig.BASE_URL}/products/" + id.toString());
    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getRelatedProducts({int id = 0}) async {
    final response = await http
        .get("${AppConfig.BASE_URL}/products/related/" + id.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int id = 0}) async {
    final response = await http
        .get("${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    var url =
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=${color}&variants=${variants}";

    final response = await http.get(url);

    /*print("url:${url}");
    print("body -------");
    print(response.body);
    print("body end -------");*/
    return variantResponseFromJson(response.body);
  }
}
