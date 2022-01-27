import 'package:badges/badges.dart';
import 'package:denta_needs/Apis/categoryApi.dart';
import 'package:denta_needs/Apis/productApi.dart';

import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Screens/Cart/cart.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_product_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  CategoryPage({this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Widget> categoriesWidgets = [];
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

  // getData() async {
  //   productsList =
  //       await ProductApi().getCategoryProducts(id: widget.category.id);
  //   _categoriesList =
  //       await CategoryApi().getCategories(parentId: widget.category.id);

  //   _shopScrollController.addListener(() {
  //     if (_shopScrollController.position.pixels ==
  //         _shopScrollController.position.maxScrollExtent) {
  //       _showShopLoadingContainer = true;
  //       setState(() {
  //         _shopPage++;
  //       });
  //       fetchProductsData();
  //     }
  //   });
  //   setState(() {});
  // }

  // fetchProductsData() async {
  //   if (selectedCategoriesList.length != 0) {
  //     var shopResponse = await ProductApi().getCategoryProducts(
  //       id: selectedCategoriesList.length == 1
  //           ? selectedCategoriesList[0]
  //           : widget.category.id,
  //       page: _shopPage,
  //     );
  //     _loadedProductsCount = _loadedProductsCount == -1
  //         ? shopResponse.products.length
  //         : _loadedProductsCount + shopResponse.products.length;
  //     productsList.products.addAll(shopResponse.products);
  //     _totalShopData = productsList.meta.total;
  //   } else {
  //     print('else');
  //     var shopResponse = await ProductApi()
  //         .getCategoryProducts(id: widget.category.id, page: _shopPage);
  //     _loadedProductsCount = _loadedProductsCount == -1
  //         ? shopResponse.products.length + 10
  //         : _loadedProductsCount + shopResponse.products.length;
  //     print(shopResponse.products.length);
  //     print(_shopPage);
  //     productsList.products.addAll(shopResponse.products);
  //     _totalShopData = productsList.meta.total;
  //   }
  //   print(_totalShopData);
  //   print(_loadedProductsCount);
  //   setState(() {});
  // }
  getData() async {
    productsList =
        await ProductApi().getCategoryProducts(id: widget.category.id);
    _categoriesList =
        await CategoryApi().getCategories(parentId: widget.category.id);
        
    setState(() {});
  }

  /// Fetch Products
  fetchProductsData() async {
    if (selectedCategoriesList.length != 0) {
      var shopResponse = await ProductApi().getCategoryProducts(
        id: selectedCategoriesList.length == 1
            ? selectedCategoriesList[0]
            : widget.category.id,
        page: _shopPage,
      );
      _loadedProductsCount = _loadedProductsCount == -1
          ? shopResponse.products.length
          : _loadedProductsCount + shopResponse.products.length;
      productsList.products.addAll(shopResponse.products);
      _totalShopData = shopResponse.meta.total;
    } else {
      var shopResponse = await ProductApi()
          .getCategoryProducts(id: widget.category.id, page: _shopPage);
      _loadedProductsCount = _loadedProductsCount == -1
          ? shopResponse.products.length + 10
          : _loadedProductsCount + shopResponse.products.length;
      productsList.products.addAll(shopResponse.products);
      _totalShopData = shopResponse.meta.total;
    }
    setState(() {});
  }

  @override
  void initState() {
    /// Add listener to check if user scroll to bottom of list view will load new page
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: value.productsList.values.length == 0
              ? Container()
              : Badge(
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Text(
                        value.productsList.values.length.toString(),
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
            backgroundColor: whiteColor,
            centerTitle: true,
            iconTheme: IconThemeData(color: primaryColor),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SearchPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ))
            ],
            title: Logo(
              LogoType.DARK,
              size: 30,
              enableTitle: false,
            ),
          ),
          body: CustomScrollView(
            controller: _shopScrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                floating: true,
                leading: Container(),
                bottom: PreferredSize(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(18),
                    title: Text(
                      widget.category.name,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: productsList == null
                        ? ShimmerHelper()
                            .buildBasicShimmer(height: 10, width: 30)
                        : Text(
                            getLang(context, 'Products Count') +
                                ': ${productsList.meta.total}',
                            style: TextStyle(fontSize: 12),
                          ),
                    leading: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: AppConfig.BASE_PATH_FOR_NETWORK +
                          widget.category.icon,
                      width: 70,
                    ),
                    shape: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.5, color: Colors.black12)),
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 53),
                ),
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
                                    label: Text(getLang(context, 'ALL')),
                                  )
                                : _categoriesList == null
                                    ? buildCategoriesShimmerList(context)
                                    : FilterChip(
                                        onSelected: (s) {
                                          setState(() {
                                            _categoriesList
                                                .categories[index - 1]
                                                .selected = s;
                                            if (selectedCategoriesList.length ==
                                                1) {
                                              if (selectedCategoriesList
                                                  .contains(_categoriesList
                                                      .categories[index - 1]
                                                      .id)) {
                                                selectedCategoriesList.clear();
                                              } else {
                                                selectedCategoriesList.clear();
                                                selectedCategoriesList.add(
                                                    _categoriesList
                                                        .categories[index - 1]
                                                        .id);
                                              }
                                            } else
                                              selectedCategoriesList.add(
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
                                        selected: selectedCategoriesList
                                            .contains(_categoriesList
                                                .categories[index - 1].id),
                                        tooltip: _categoriesList
                                            .categories[index - 1].name,
                                        backgroundColor:
                                            Colors.black12.withOpacity(0.04),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        padding:
                                            EdgeInsets.fromLTRB(8, 4, 8, 4),
                                        pressElevation: 2,
                                        labelStyle: TextStyle(
                                            color: selectedCategoriesList
                                                    .contains(_categoriesList
                                                        .categories[index - 1]
                                                        .id)
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
              productsList == null || productsList.products.length == 0
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
            ],
          ),

          //    buildSubCategories()
        );
      },
    );
  }

  subCategoryTile({Category subCategory}) {
    return ListTile(
      contentPadding: EdgeInsets.all(2),
      title: Text(
        subCategory.name,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      leading: Container(
        width: 1,
      ),
      onTap: () {},
      trailing: Icon(
        Icons.arrow_right,
        size: 30,
      ),
      shape: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.black12)),
    );
  }

  buildCategoriesShimmerList(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: ShimmerHelper().buildListShimmer(item_count: 1, item_height: 15.0),
    );
  }
}
