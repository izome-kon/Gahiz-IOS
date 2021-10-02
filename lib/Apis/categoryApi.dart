import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;

class CategoryApi {
  Future<CategoryResponse> getCategories({parentId = 0}) async {
    final response =
        await http.get("${AppConfig.BASE_URL}/categories?parent_id=$parentId");
    return categoryResponseFromJson(response.body);
  }
  Future<CategoryResponse> getShopCategories({shopID}) async {
    final response =
    await http.get("${AppConfig.BASE_URL}/categories/shop/$shopID");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/categories/featured");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    final response = await http.get("${AppConfig.BASE_URL}/categories/top");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getAllCategories() async {
    final response = await http.get("${AppConfig.BASE_URL}/categories");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    final response = await http.get("${AppConfig.BASE_URL}/filter/categories");
    return categoryResponseFromJson(response.body);
  }
}
