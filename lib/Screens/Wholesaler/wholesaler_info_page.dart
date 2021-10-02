import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:denta_needs/Apis/categoryApi.dart';
import 'package:denta_needs/Apis/productApi.dart';
import 'package:denta_needs/Apis/shop_repository.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/notification_button.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Screens/Cart/cart.dart';
import 'package:denta_needs/Screens/Product/filter_section.dart';
import 'package:denta_needs/Screens/Product/wholesaler_card.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_product_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WholesalerInfoPage extends StatefulWidget {
  final shop;

  WholesalerInfoPage({this.shop});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<WholesalerInfoPage> {
  var productsCount;
  ProductMiniResponse productsList;
  CategoryResponse _categoriesList;
  bool allCategories = true;

  //
  int _shopPage = 1;
  int _totalShopData = 0;
  int _loadedProductsCount = -1;
  bool _showShopLoadingContainer = false;
  ScrollController _shopScrollController = ScrollController();
  List<int> selectedCategoriesList = [];

  getData() async {
    productsCount =
        await ShopRepository().getProductsCount(id: widget.shop.userId);
    productsList = await ProductApi().getShopProducts(id: widget.shop.id);
    _categoriesList =
        await CategoryApi().getShopCategories(shopID: widget.shop.id);
    setState(() {});
  }

  fetchProductsData() async {
    if (selectedCategoriesList.length != 0) {
      print('getShopProductsByCategories');
      var shopResponse = await ProductApi().getShopProductsByCategories(
          id: widget.shop.id,
          page: _shopPage,
          categories: selectedCategoriesList);
      _loadedProductsCount = _loadedProductsCount == -1
          ? shopResponse.products.length
          : _loadedProductsCount + shopResponse.products.length;
      productsList.products.addAll(shopResponse.products);
      _totalShopData = shopResponse.meta.total;
    } else {
      var shopResponse = await ProductApi()
          .getShopProducts(id: widget.shop.id, page: _shopPage);
      _loadedProductsCount = _loadedProductsCount == -1
          ? shopResponse.products.length + 10
          : _loadedProductsCount + shopResponse.products.length;
      productsList.products.addAll(shopResponse.products);
      _totalShopData = shopResponse.meta.total;
    }
    print(_totalShopData);
    print(_loadedProductsCount);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        _showShopLoadingContainer = true;
        setState(() {
          _shopPage++;
        });
        fetchProductsData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return

      Consumer<CartProvider>(
      builder: (context, value, child) => Scaffold(
          floatingActionButton: value.productsList.keys.length == 0
              ? Container()
              : Badge(
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Text(
                        value.productsList.keys.length.toString(),
                        style: TextStyle(color: whiteColor),
                      );
                    },
                  ),
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => CartPage(),
                        ),
                      );
                    },
                    child: Lottie.asset(
                      'assets/lottie/cart.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          appBar: AppBar(
            backgroundColor: primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            actions: [
              NotificationButton(),
            ],
            title: Text(
              widget.shop.name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: accentColor,
            onRefresh: _onShopListRefresh,
            child:
                CustomScrollView(controller: _shopScrollController, slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FullScreenWidget(
                            backgroundIsTransparent: true,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Hero(
                                  tag: "smallImage",
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/placeholder.png',
                                      image: AppConfig.BASE_PATH +
                                          widget.shop.logo,
                                      width: 150,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.shop.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: fontColor),
                          ),
                          productsCount == null
                              ? Container(
                                  width: 150,
                                  child: ShimmerHelper().buildListShimmer(
                                      item_count: 1, item_height: 15.0),
                                )
                              : Text(
                                  getLang(context, 'num of products')+' ' + productsCount,
                                  style: TextStyle(
                                      color: fontColor.withOpacity(0.7),
                                      fontSize: 13),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                floating: true,
                elevation: 0.2,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SearchPage(),
                          ),
                        );
                      },
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            fillColor: primaryColor.withOpacity(0.1),
                            filled: true,
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.only(left: 8, right: 8),
                            hintText: getLang(context, 'search_about_proudct'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    height: 50,
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 14),
                ),
                leading: Container(),
              ),
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return VerticalDivider();
                          },
                          cacheExtent: 100,
                          itemBuilder: (context, index) {
                            return index == 0
                                ? FilterChip(
                                    onSelected: (s) {
                                      setState(() {
                                        allCategories = s;
                                        selectedCategoriesList.clear();
                                        _onShopListRefresh();
                                      });
                                    },
                                    selected:
                                        selectedCategoriesList.length == 0,
                                    selectedColor: accentColor,
                                    elevation: 0,
                                    backgroundColor:
                                        Colors.black12.withOpacity(0.04),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    pressElevation: 2,
                                    avatar: Icon(
                                      Icons.clear_all,
                                      color: fontColor,
                                    ),
                                    labelStyle: TextStyle(
                                        color:
                                            selectedCategoriesList.length == 0
                                                ? whiteColor
                                                : fontColor),
                                    label: Text(getLang(context, "ALL")),
                                  )
                                : _categoriesList == null
                                    ? buildCategoriesShimmerList(context)
                                    : FilterChip(
                                        onSelected: (s) {
                                          setState(() {
                                            _categoriesList
                                                .categories[index - 1]
                                                .selected = s;
                                            if (s)
                                              selectedCategoriesList.add(
                                                  _categoriesList
                                                      .categories[index - 1]
                                                      .id);
                                            else
                                              selectedCategoriesList.remove(
                                                  _categoriesList
                                                      .categories[index - 1]
                                                      .id);
                                            _shopPage = 1;
                                            productsList.products = [];
                                            _totalShopData = 0;
                                            _loadedProductsCount = -1;
                                            _showShopLoadingContainer = false;
                                            fetchProductsData();
                                          });
                                        },
                                        selectedColor: accentColor,
                                        elevation: 0,
                                        selected: _categoriesList
                                            .categories[index - 1].selected,
                                        tooltip: _categoriesList
                                            .categories[index - 1].name,
                                        backgroundColor:
                                            Colors.black12.withOpacity(0.04),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        avatar: FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/images/placeholder.png',
                                          image: AppConfig.BASE_PATH +
                                              _categoriesList
                                                  .categories[index - 1].icon,
                                          width: 150,
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(8, 4, 8, 4),
                                        pressElevation: 2,
                                        labelStyle: TextStyle(
                                            color: _categoriesList
                                                    .categories[index - 1]
                                                    .selected
                                                ? whiteColor
                                                : fontColor),
                                        label: Text(_categoriesList
                                            .categories[index - 1].name),
                                      );
                          },
                          itemCount: _categoriesList == null
                              ? 3
                              : _categoriesList.categories.length + 1,
                          padding: EdgeInsets.all(8),
                          scrollDirection: Axis.horizontal,
                        ),
                      )
                    ],
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 0),
                ),
                leading: Container(),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Divider(
                    color: primaryColor.withOpacity(0.2),
                    thickness: 1,
                    height: 0,
                  ),
                ]),
              ),
              productsList == null
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: ShimmerHelper()
                            .buildProductGridShimmer(item_count: 15),
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return WholesalerProductCard(
                          product: productsList.products[index],
                        );
                      }, childCount: productsList.products.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                      ),
                    ),
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
                            child: Text(getLang(context, 'No More Products')),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Center(
                            child: Container(),
                          ),
                        )
            ]),
          )),
    );
  }

  Future<void> _onShopListRefresh() async {
    productsCount = null;
    productsList.products = [];
    _categoriesList = null;
    allCategories = true;

    //
    _shopPage = 1;
    _totalShopData = 0;
    _loadedProductsCount = -1;
    _showShopLoadingContainer = false;
    setState(() {
      getData();
      fetchProductsData();
    });
  }

  buildCategoriesShimmerList(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: ShimmerHelper().buildListShimmer(item_count: 1, item_height: 15.0),
    );
  }
}
