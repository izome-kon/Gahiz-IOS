import 'package:badges/badges.dart';
import 'package:denta_needs/Apis/productApi.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Responses/Product/flash_deal_response.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Screens/Cart/cart.dart';
import 'package:denta_needs/Screens/Offers/offer_card.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_product_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OfferInfo extends StatefulWidget {
  final FlashDeal flashDeal;
  final currentRemainingTime;

  OfferInfo({this.flashDeal, this.currentRemainingTime});

  @override
  _OfferInfoState createState() => _OfferInfoState();
}

class _OfferInfoState extends State<OfferInfo> {
  ProductMiniResponse products;

  getData() async {
    products = await ProductApi().getFlashDealProducts(id: widget.flashDeal.id);
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
      builder: (context, value, child) => Scaffold(
        floatingActionButton: value.productsList.keys.length == 0
            ? Container()
            : Badge(
                borderRadius: BorderRadius.circular(8),
                badgeContent: Text(
                  value.productsList.keys.length.toString(),
                  style: TextStyle(color: whiteColor),
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
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ))
            ],
            title: Logo(
              LogoType.LIGHT,
              size: 40,
              enableTitle: false,
            )),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: OfferCard(
                button: false,
                flashDeal: widget.flashDeal,
                currentRemainingTime: widget.currentRemainingTime,
              ),
            ),
            products == null
                ? SliverToBoxAdapter(
                    child: ShimmerHelper().buildProductGridShimmer(),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return WholesalerProductCard(
                        product: products.products[index],
                      );
                    }, childCount: products.products.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
