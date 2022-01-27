import 'package:badges/badges.dart';
import 'package:denta_needs/Apis/productApi.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Screens/Cart/cart.dart';
import 'package:denta_needs/Screens/OrderFeatchers/record_order.dart';
import 'package:denta_needs/Screens/OrderFeatchers/tack_photo.dart';
import 'package:denta_needs/Screens/OrderFeatchers/take_by_text.dart';
import 'package:denta_needs/Screens/Product/product_card.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  /// searched products from api
  ProductMiniResponse _searchedProducts;

  /// Search Text from user
  String _searchText = '';

  bool toolTipShow = false;

  var showBlurMenu = false;

  /// Get data from api
  getData() async {
    if (_searchText == '') {
      _searchedProducts = await ProductApi().getBestSellingProducts();
    } else {
      _searchedProducts =
          await ProductApi().getFilteredProducts(name: _searchText);
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: whiteColor,
              centerTitle: true,
              iconTheme: IconThemeData(color: primaryColor),
              actions: [
                IconButton(
                    icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ))
              ],
              title: Logo(
                LogoType.DARK,
                size: 40,
                enableTitle: false,
              )),
          body: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  leading: Container(),
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                      preferredSize:
                          Size(MediaQuery.of(context).size.width, 40),
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              autofocus: _searchText == '',
                              onChanged: (s) {
                                _searchText = s;
                                getData();
                              },
                              decoration: InputDecoration(
                                  fillColor: primaryColor.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.only(left: 8, right: 8),
                                  hintText:
                                      getLang(context, 'search_about_proudct'),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(Icons.widgets_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(getLang(context, 'products')),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
                _searchedProducts == null
                    ? SliverToBoxAdapter(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: ShimmerHelper()
                              .buildProductGridShimmer(item_count: 15),
                        ),
                      )
                    : _searchedProducts.products.length == 0
                        ? buildSearchNotFound()
                        : SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return ProductCard(
                                product: _searchedProducts.products[index],
                              );
                            }, childCount: _searchedProducts.products.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3,
                            ),
                          ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Cart',
            backgroundColor: primaryColor,
            onPressed: onCartPress,
            child: showBlurMenu
                ? Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  )
                : Lottie.asset(
                    'assets/lottie/cart.json',
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }

  /// Build searched product not found
  buildSearchNotFound() {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Lottie.asset('assets/lottie/search_not_found.json',
            width: 250, repeat: false),
        Text(
          getLang(context, 'Not Found') + ' \"$_searchText\"',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(getLang(context, "You Can Order This Product")),
        SizedBox(
          height: 15,
        ),
        FlatButton(
          onPressed: onPressRecordOrder,
          color: primaryColor,
          child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 200,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mic_none_rounded,
                    color: whiteColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    getLang(context, 'Record Order'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 15,
        ),
        FlatButton(
          onPressed: onPressTackPic,
          color: primaryColor,
          child: SimpleTooltip(
            animationDuration: Duration(milliseconds: 200),
            show: toolTipShow,
            borderWidth: 0,
            ballonPadding: EdgeInsets.zero,
            tooltipDirection: TooltipDirection.up,
            content: Container(
              height: 100,
              child: Column(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TackPhotoScreen(
                                      imageSource: ImageSource.gallery,
                                    )));
                      },
                      color: primaryColor,
                      child: Text(
                        getLang(context, 'From gallery'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TackPhotoScreen(
                                      imageSource: ImageSource.camera,
                                    )));
                      },
                      color: primaryColor,
                      child: Text(
                        getLang(context, 'Open Camera'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 200,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_search_outlined,
                      color: whiteColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      getLang(context, 'pic Order'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: whiteColor,
                      ),
                    ),
                  ],
                )),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        FlatButton(
          onPressed: onPressTackText,
          color: primaryColor,
          child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 200,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: whiteColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    getLang(context, 'write Order'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 15,
        ),
        FlatButton(
          onPressed: () {
            Freshchat.showConversations();
          },
          color: primaryColor,
          child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 200,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contact_support_outlined,
                    color: whiteColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    getLang(context, "Contact Us"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                ],
              )),
        )
      ],
    ));
  }

  void onPressRecordOrder() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RecordOrderScreen()));
  }

  void onPressTackPic() {
    setState(() {
      toolTipShow = !toolTipShow;
    });
  }

  void onPressTackText() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => TackTextScreen()));
  }

  void onCartPress() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CartPage(),
      ),
    );
  }
}
