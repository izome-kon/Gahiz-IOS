import 'package:denta_needs/Apis/shop_repository.dart';
import 'package:denta_needs/Common/custom_drawer.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/notification_button.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Screens/Product/wholesaler_card.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_page_card.dart';
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:lottie/lottie.dart';
import 'package:showcaseview/showcaseview.dart';


class Wholesaler extends StatefulWidget {
  @override
  _WholesalerState createState() => _WholesalerState();
}

class _WholesalerState extends State<Wholesaler> {
  String _searchKey = "";

  List<dynamic> _shopList = [];
  int _shopPage = 1;
  int _totalShopData = 0;
  int _loadedProductsCount = -1;
  bool _showShopLoadingContainer = true;
  ScrollController _shopScrollController = ScrollController();

  fetchShopData() async {
    var shopResponse =
        await ShopRepository().getShops(page: _shopPage, name: _searchKey);
    _shopList.addAll(shopResponse.shops);
    _totalShopData = shopResponse.meta.total;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  presentation() async {
    await showSuppliersSteps.load();
    if (showSuppliersSteps.$) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context).startShowCase([Main.presintKeyCart]));
    }
 
  }

  @override
  void initState() {
    presentation();
    fetchShopData();
    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        _showShopLoadingContainer = true;
        setState(() {
          _shopPage++;
        });
        fetchShopData();
      }
    });
    super.initState();
  }

  Container buildShopLoadingContainer() {
    return Container(
      height: _showShopLoadingContainer ? 70 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Align(
        alignment: Alignment.topCenter,
        child: _totalShopData == _shopList.length
            ? Text(getLang(context, 'No More Suppliers'))
            : CircleAvatar(
                backgroundColor: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  buildSearchNotFound() {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Lottie.asset(
          'assets/lottie/search_not_found.json',
          repeat: false,
          width: 300,
          height: 300,
        ),
        Text(
          getLang(context, 'Not Found Supplier by this name') +
              ' \"$_searchKey\"',
          style: TextStyle(
            color: fontColor,
            fontSize: 14,
          ),
        ),
        // Text('You Can Order This Product'),
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
                    getLang(context, 'Contact Us'),
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

  @override
  void dispose() {
    _shopScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [NotificationButton()],
        iconTheme: IconThemeData(color: whiteColor),
        title: Text(
          getLang(context, 'wholesaler'),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: accentColor,
        onRefresh: _onShopListRefresh,
        child: _shopList.length == 0 && _showShopLoadingContainer
            ? ShimmerHelper()
                .buildListShimmer(item_count: 30, item_height: 50.0)
            : CustomScrollView(
                controller: _shopScrollController,
                slivers: [
                  SliverAppBar(
                    leading: Container(),
                    floating: true,
                    backgroundColor: Colors.white,
                    bottom: PreferredSize(
                      preferredSize:
                          Size(MediaQuery.of(context).size.width, 15),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (s) {
                            _searchKey = s;
                            _shopList = [];
                            fetchShopData();
                          },
                          decoration: InputDecoration(
                              fillColor: primaryColor.withOpacity(0.1),
                              filled: true,
                              prefixIcon: Icon(Icons.search),
                              contentPadding:
                                  EdgeInsets.only(left: 8, right: 8),
                              hintText:
                                  getLang(context, 'looking_for_suppliers'),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        height: 50,
                      ),
                    ),
                  ),

                  // WholesalerPageCard(
                  //   shop: _shopList[index - 1],
                  // )
                  _shopList.length == 0
                      ? buildSearchNotFound()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                          return WholesalerPageCard(
                            shop: _shopList[index],
                          );
                        }, childCount: _shopList.length)),

                  _showShopLoadingContainer &&
                          _loadedProductsCount != _totalShopData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                  backgroundColor: accentColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ),
                        )
                      : _loadedProductsCount == _totalShopData
                          ? SliverToBoxAdapter(
                              child: Center(
                                child:
                                    Text(getLang(context, 'No More Products')),
                              ),
                            )
                          : SliverToBoxAdapter(
                              child: Center(
                                child: Container(),
                              ),
                            )
                ],
              ),
      ),
    );
  }

  Future<void> _onShopListRefresh() async {
    _shopList = [];
    _shopPage = 1;
    _totalShopData = 0;
    _showShopLoadingContainer = true;
    await fetchShopData();
  }
}
