import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/WishList/wishlist_check_response.dart';
import 'package:denta_needs/Responses/WishList/wishlist_delete_response.dart';
import 'package:denta_needs/Responses/WishList/wishlist_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;

class WishListRepository {
  Future<WishlistResponse> getUserWishlist() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/wishlists/user_id"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    return wishlistResponseFromJson(response.body);
  }

  Future<WishlistDeleteResponse> delete({
    int wishlist_id = 0,
  }) async {
    final response = await http.delete(
      Uri.parse("${AppConfig.BASE_URL}/wishlists/wishlist_id"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<WishListChekResponse> isProductInUserWishList({product_id = 0}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wishlists-check-product?product_id=${product_id}&user_id=${user_id.$}"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> add({product_id = 0}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wishlists-add-product?product_id=${product_id}&user_id=${user_id.$}"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    print(response.body);
    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> remove({product_id = 0}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wishlists-remove-product?product_id=${product_id}&user_id=${user_id.$}"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    return wishListChekResponseFromJson(response.body);
  }
}
