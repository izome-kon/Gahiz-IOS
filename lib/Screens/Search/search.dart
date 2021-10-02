import 'package:denta_needs/Apis/productApi.dart';
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
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProductMiniResponse _searchedProducts;
  String _searchText = '';

  getData() async {
    _searchedProducts =
        await ProductApi().getFilteredProducts(name: _searchText);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  // entire logic is inside this listener for ListView

  @override
  Widget build(BuildContext context) {
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
                  preferredSize: Size(MediaQuery.of(context).size.width, 40),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  buildSearchNotFound() {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Lottie.asset('assets/lottie/search_not_found.json', repeat: false),
        Text(
          getLang(context, 'Not Found')+' \"$_searchText\"',
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
}
