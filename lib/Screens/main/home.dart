import 'package:denta_needs/Apis/categoryApi.dart';
import 'package:denta_needs/Apis/productApi.dart';
import 'package:denta_needs/Apis/sliderApi.dart';
import 'package:denta_needs/Common/Widgets/category_card.dart';
import 'package:denta_needs/Common/Widgets/order_featcher_button.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Screens/Product/product_card.dart';
import 'package:denta_needs/Common/custom_drawer.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/notification_button.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/settings.dart';
import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Responses/Slider/slider_response.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class Home extends StatefulWidget {
  var drawerKey;
  Home({this.drawerKey});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var carouselImageList = [];
  int _currentSlider = 0;
  var featuredProductResponse;
  List<Widget> categoriesWidgets = [];
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();
  buildHomeFeaturedProducts() {
    return FutureBuilder<SliderResponse>(
        future: SliderApi().getSliders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var featuredProductResponse = snapshot.data;
            carouselImageList = [];
            featuredProductResponse.sliders.forEach((slider) {
              carouselImageList.add(slider.photo);
            });
            return CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 2.67,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.easeInCubic,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlider = index;
                    });
                  }),
              items: featuredProductResponse.sliders.map((i) {
                return Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  'assets/images/placeholder_rectangle.png',
                              image: AppConfig.BASE_PATH_FOR_NETWORK + i.photo,
                              fit: BoxFit.fill,
                            ))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: carouselImageList.map((url) {
                          int index = carouselImageList.indexOf(url);
                          return Container(
                            width: 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentSlider == index
                                  ? primaryColor.withOpacity(0.3)
                                  : Color.fromRGBO(112, 112, 112, .3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return ShimmerHelper().buildBasicShimmer(
                height: 120.0,
                width: (MediaQuery.of(context).size.width - 32) / 3);
          }
        });
  }

  buildBeastSellingProducts() async {
    featuredProductResponse = await ProductApi().getBestSellingProducts();
    if (this.mounted) setState(() {});
  }

  buildHomeFeaturedCategories() {
    CategoryApi().getFeturedCategories().then((snapshot) {
      if (snapshot.success) {
        categoriesWidgets = [];
        //snapshot.hasData
        var featuredProductResponse = snapshot;
        for (int i = 0; i < featuredProductResponse.categories.length;) {
          List<Widget> row = [];
          for (int j = 0; j < 3; j++) {
            if (i == featuredProductResponse.categories.length) break;
            row.add(CategoryCard(
              category: featuredProductResponse.categories[i],
            ));
            i++;
          }
          categoriesWidgets.add(Row(
            children: row,
          ));
        }
      }
      if (this.mounted) setState(() {});
    });
  }

  presentation() async {
    await showHomeSteps.load();
    if (showHomeSteps.$) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([
                _one,
                _two,
                _three,
                _four,
                _five,
                CustomDrawer.presentKey,
              ]));
      showHomeSteps.$ = false;
      showHomeSteps.save();
    }
  }

  @override
  void initState() {
    presentation();
    buildBeastSellingProducts();
    buildHomeFeaturedCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          Showcase(
              key: _four,
              description: 'Click here to open notifications page',
              child: NotificationButton()),
        ],
        leading: Showcase(
            key: _five,
            title: getLang(context, 'Side Menu'),
            description: getLang(context, 'Click here to open side menu'),
            child: Builder(
              builder: (context) => // Ensure Scaffold is in context
                  IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer()),
            )),
        title: Text(
          getLang(context, 'home'),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: accentColor,
        onRefresh: _onShopListRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Container(),
              backgroundColor: Colors.white,
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 14),
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
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                  height: 50,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              buildHomeFeaturedProducts(),
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: 8,
              ),
              Text(
                getLang(context, 'fastest ordering'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: fontColor.withOpacity(0.5)),
              ),
            ])),
            SliverGrid.count(
              crossAxisCount: 3,
              children: [
                Showcase(
                  key: _one,
                  description: getLang(context,
                      'Click here to order your products by voice note'),
                  child: OrderFeacherButton(
                    buttonType: OrderFeacherType.VOICE,
                  ),
                ),
                Showcase(
                    key: _two,
                    description: getLang(context,
                        'Click here to order your products by take some picture'),
                    child: OrderFeacherButton(
                      buttonType: OrderFeacherType.PHOTO,
                      duration: Duration(milliseconds: 500),
                    )),
                Showcase(
                  key: _three,
                  description: 'Click here to type your order',
                  child: OrderFeacherButton(
                    buttonType: OrderFeacherType.TYPING,
                    duration: Duration(milliseconds: 1000),
                  ),
                ),
              ],
            ),
            featuredProductResponse == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ShimmerHelper().buildListShimmer(item_count: 2),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      getLang(context, 'most_popular_items'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fontColor.withOpacity(0.5)),
                    ),
                  ])),
            SliverList(
                delegate: SliverChildListDelegate(
              categoriesWidgets,
            )),
            featuredProductResponse == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ShimmerHelper().buildListShimmer(item_count: 2),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      color: accentColor,
                      child: Consumer<Settings>(
                        builder: (context, value, child) {
                          return InkWell(
                              onTap: () {
                                value.changePageIndex(3);
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      getLang(context, 'show_more'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Text(
                    //   getLang(context, 'best_selling_products'),
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //       color: fontColor.withOpacity(0.5)),
                    // ),
                  ])),
            // featuredProductResponse == null
            //     ? SliverToBoxAdapter(
            //         child: Container(
            //           height: MediaQuery.of(context).size.height,
            //           child: ShimmerHelper()
            //               .buildProductGridShimmer(item_count: 15),
            //         ),
            //       )
            //     : SliverGrid(
            //         delegate: SliverChildBuilderDelegate(
            //             (BuildContext context, int index) {
            //           return ProductCard(
            //             product: featuredProductResponse.products[index],
            //           );
            //         }, childCount: featuredProductResponse.products.length),
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2,
            //           childAspectRatio: 2 / 3,
            //         ),
            //       ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onShopListRefresh() async {
    carouselImageList = [];
    _currentSlider = 0;
    featuredProductResponse = null;
    categoriesWidgets = [];
    setState(() {});
    buildBeastSellingProducts();
    buildHomeFeaturedCategories();
  }
}
