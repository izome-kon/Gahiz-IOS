import 'package:denta_needs/Apis/wishlist_repository.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/WishList/wishlist_response.dart';
import 'package:denta_needs/Screens/Product/product_page2.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  WishlistResponse wishlistResponse;

  /// get data from api (userWishList)
  getData() async {
    wishlistResponse = await WishListRepository().getUserWishlist();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          getLang(context, 'wish_list'),
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
      ),
      body: wishlistResponse == null
          ? ShimmerHelper().buildListShimmer()
          : RefreshIndicator(
              child: wishlistResponse.wishlist_items.length == 0
                  ? Column(
                      children: [
                        Lottie.asset('assets/lottie/order_empty.json'),
                        Text(
                          getLang(context, 'Not Found Products'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey),
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: wishlistResponse.wishlist_items.length,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: buildWishListItem(index),
                        );
                      },
                    ),
              onRefresh: onRefresh),
    );
  }

  /// build wishList cards
  buildWishListItem(index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: wishlistResponse.wishlist_items[index].product.id,
          );
        }));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
            child: Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(
                    color: primaryColor.withOpacity(0.5), width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              elevation: 0.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16), right: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: AppConfig.BASE_PATH_FOR_NETWORK +
                                  wishlistResponse.wishlist_items[index].product
                                      .thumbnail_image,
                              fit: BoxFit.cover,
                            ))),
                    Container(
                      width: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              wishlistResponse
                                  .wishlist_items[index].product.name,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: fontColor,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                            child: Text(
                              wishlistResponse
                                  .wishlist_items[index].product.base_price,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 12,
            child: IconButton(
              icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
              onPressed: () {
                _onPressRemove(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// on page refresh
  Future<void> onRefresh() async {
    setState(() {});
    getData();
  }

  Future<void> _onPressRemove(index) async {
    var wishlist_id = wishlistResponse.wishlist_items[index].id;
    wishlistResponse.wishlist_items.removeAt(index);
    setState(() {});

    var wishlistDeleteResponse =
        await WishListRepository().delete(wishlist_id: wishlist_id);

    if (wishlistDeleteResponse.result == true) {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: wishlistDeleteResponse.message,
          backgroundColor: Colors.green,
        ),
        displayDuration: Duration(seconds: 1),
      );
    }
  }
}
