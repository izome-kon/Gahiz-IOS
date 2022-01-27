import 'package:cool_alert/cool_alert.dart';
import 'package:cupertino_listview/cupertino_listview.dart';
import 'package:denta_needs/Apis/address_repositories.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Apis/coupon_repository.dart';
import 'package:denta_needs/Apis/payment_repository.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Address/address_response.dart';
import 'package:denta_needs/Responses/Cart/cart_response.dart';
import 'package:denta_needs/Responses/Cart/cart_summary_response.dart';
import 'package:denta_needs/Screens/Address/view_address.dart';
import 'package:denta_needs/Screens/Cart/image_order_card.dart';
import 'package:denta_needs/Screens/Cart/product_cart_card.dart';
import 'package:denta_needs/Screens/Cart/record_card.dart';
import 'package:denta_needs/Screens/Cart/text_order_card.dart';
import 'package:denta_needs/Screens/MyOrders/OrderDetails.dart';

import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double _hight = 0;
  bool couponApplied;

  List<CartResponse> cartList;
  CartSummaryResponse cartSummary;
  Address address;
  bool enableToEnterCupon;
  TextEditingController textEditingController = TextEditingController();
  CartProvider cartProvider;

  bool isLoading = false;

  getData() async {
    cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.sendUpdateRequest) {
      setState(() {
        isLoading = true;
      });
      print('print = ${cartProvider.productsList}');
      await CartRepository().getCartAddCollectionResponse(
          '', user_id.$, cartProvider.productsList);
      cartProvider
          .setCartList(await CartRepository().getCartResponseList(user_id.$));
      setState(() {
        isLoading = false;
      });
      cartProvider.sendUpdateRequest = false;
    } else
      cartList = await CartRepository().getCartResponseList(user_id.$);
    getSummery();
    setState(() {});
  }

  getSummery() async {
    AddressRepository().getAddressList().then((value) {
      for (Address item in value) {
        if (item.setDefault == 1) {
          address = item;
          break;
        }
      }
    });
    cartSummary = await CartRepository().getCartSummaryResponse(1);

    if (cartSummary.discount != 0) {
      textEditingController.text = getLang(context, "You take") +
          " ${cartSummary.discount.toStringAsFixed(2)} ${cartSummary.currency_symbol}";
    } else {
      textEditingController.text = "";
    }
    setState(() {});
  }

  @override
  void initState() {
    enableToEnterCupon = true;
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          getLang(context, 'payment'),
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          return value.cartList == null
              ? ShimmerHelper().buildListShimmer(item_height: 100.0)
              : Consumer<CartProvider>(
                  builder: (context, value, child) {
                    double hight = 0;
                    for (CartResponse cart in value.cartList) {
                      hight += 80;
                      for (CartItem item in cart.cart_items) {
                        hight += 130;
                      }
                    }
                    return CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          backgroundColor: Colors.white,
                          leading: Container(),
                          bottom: PreferredSize(
                              preferredSize: Size(
                                  MediaQuery.of(context).size.width,
                                  cartSummary != null
                                      ? cartSummary.discount != 0
                                          ? 272
                                          : 242
                                      : 242),
                              child: cartSummary == null
                                  ? ShimmerHelper().buildListShimmer(
                                      item_count: 5, item_height: 20.0)
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(8),
                                                margin: EdgeInsets.only(
                                                    left: 8, top: 8),
                                                child: Text(
                                                  getLang(context, "Clinic"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ViewAddress()))
                                                    .then((_) {
                                                  setState(() {
                                                    cartSummary = null;
                                                  });
                                                  getSummery();
                                                });
                                              },
                                              child: Container(
                                                  height: 45,
                                                  width: 150,
                                                  padding: EdgeInsets.all(8),
                                                  margin: EdgeInsets.only(
                                                      right: 8, top: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: accentColor
                                                              .withOpacity(
                                                                  0.7)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: ListView(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      Icon(
                                                        address == null
                                                            ? Icons
                                                                .not_listed_location_outlined
                                                            : Icons
                                                                .location_on_outlined,
                                                        color: accentColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4),
                                                        child: Text(
                                                          address == null
                                                              ? getLang(context,
                                                                  "Select Clinic Address")
                                                              : address
                                                                  .clinicName,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(8),
                                                margin: EdgeInsets.only(
                                                    left: 8, top: 8),
                                                child: Text(
                                                  getLang(context,
                                                      "Payment method"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Spacer(),
                                            Container(
                                                height: 45,
                                                padding: EdgeInsets.all(8),
                                                width: 150,
                                                margin: EdgeInsets.only(
                                                    right: 8, top: 8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: accentColor
                                                            .withOpacity(0.7)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/cash-on-delivery.png'),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      getLang(context,
                                                          'Cash On Delivery'),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: cartSummary.discount == 0
                                              ? 110
                                              : 140,
                                          padding: EdgeInsets.all(8),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: accentColor
                                                      .withOpacity(0.3)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  color: accentColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getLang(context, 'Delivery'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  cartSummary.shipping_cost
                                                          .toStringAsFixed(2) +
                                                      cartSummary
                                                          .currency_symbol,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: fontColor,
                                                      fontSize: 18),
                                                ),
                                              ]),
                                              Row(children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  color: accentColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getLang(context, 'Sub total'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  (cartSummary.grand_total_value +
                                                              cartSummary
                                                                  .discount)
                                                          .toStringAsFixed(2) +
                                                      cartSummary
                                                          .currency_symbol,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: fontColor,
                                                      fontSize: 18),
                                                ),
                                              ]),
                                              cartSummary.discount == 0
                                                  ? Container()
                                                  : Row(children: [
                                                      Icon(
                                                        Icons.payments_outlined,
                                                        color: accentColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        getLang(context,
                                                            "Discount"),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        cartSummary.discount
                                                                .toStringAsFixed(
                                                                    2) +
                                                            cartSummary
                                                                .currency_symbol,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                            fontSize: 18),
                                                      ),
                                                    ]),
                                              Row(children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  color: accentColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getLang(context, 'total'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  cartSummary.grand_total_value
                                                          .toStringAsFixed(2) +
                                                      cartSummary
                                                          .currency_symbol,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                      fontSize: 18),
                                                ),
                                              ])
                                            ],
                                          ),
                                        ),
                                        cartSummary.discount == 0
                                            ? Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: accentColor
                                                            .withOpacity(0.3)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: TextField(
                                                  enabled:
                                                      cartSummary.discount ==
                                                              0 &&
                                                          enableToEnterCupon,
                                                  controller:
                                                      textEditingController,
                                                  onSubmitted: (s) {
                                                    setState(() {
                                                      enableToEnterCupon =
                                                          false;
                                                    });
                                                    applyCoupon();
                                                  },
                                                  decoration: InputDecoration(
                                                      fillColor: Colors.white
                                                          .withOpacity(0.1),
                                                      filled: true,
                                                      prefixIcon: Icon(
                                                        Icons
                                                            .local_offer_outlined,
                                                        color: accentColor,
                                                      ),
                                                      suffixIcon: IconButton(
                                                        icon: enableToEnterCupon
                                                            ? Icon(Icons.send)
                                                            : CircularProgressIndicator(),
                                                        onPressed: () {
                                                          setState(() {
                                                            enableToEnterCupon =
                                                                false;
                                                          });
                                                          if (cartSummary
                                                                  .discount ==
                                                              0)
                                                            applyCoupon();
                                                          else
                                                            removeCoupon();
                                                        },
                                                      ),
                                                      contentPadding: EdgeInsets
                                                          .only(
                                                              left: 8,
                                                              right: 8),
                                                      hintText: cartSummary
                                                                  .discount ==
                                                              0
                                                          ? getLang(context,
                                                              'Have coupon code? Enter here')
                                                          : getLang(context,
                                                                  'You take') +
                                                              ' ${cartSummary.discount.toStringAsFixed(2)} ${cartSummary.currency_symbol}',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none)),
                                                ))
                                            : Row(
                                                children: [
                                                  Container(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              70,
                                                      margin: EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: accentColor
                                                                  .withOpacity(
                                                                      0.3)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextField(
                                                        enabled: false,
                                                        controller:
                                                            textEditingController,
                                                        decoration:
                                                            InputDecoration(
                                                                fillColor: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.1),
                                                                filled: true,
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .local_offer_outlined,
                                                                  color:
                                                                      accentColor,
                                                                ),
                                                                suffixIcon:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .check_circle_outline,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      enableToEnterCupon =
                                                                          false;
                                                                    });
                                                                    if (cartSummary
                                                                            .discount ==
                                                                        0)
                                                                      applyCoupon();
                                                                    else
                                                                      removeCoupon();
                                                                  },
                                                                ),
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                hintText: cartSummary
                                                                            .discount ==
                                                                        0
                                                                    ? getLang(
                                                                        context,
                                                                        'Have coupon code? Enter here')
                                                                    : getLang(
                                                                            context,
                                                                            'You take') +
                                                                        ' ${cartSummary.discount.toStringAsFixed(2)} ${cartSummary.currency_symbol}',
                                                                border: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none)),
                                                      )),
                                                  IconButton(
                                                    onPressed: () {
                                                      removeCoupon();
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    )),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: hight,
                            child: CupertinoListView.builder(
                                sectionCount: value.cartList.length,
                                itemInSectionCount: (section) =>
                                    value.cartList[section].cart_items.length,
                                sectionBuilder: (context, sectionPath, _) =>
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                      ),
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          (value.cartList[sectionPath.section]
                                                      .owner_id ==
                                                  AppConfig.VOICE_RECORD_ID)
                                              ? Lottie.asset(
                                                  'assets/lottie/voice.json',
                                                  width: 32,
                                                  height: 32,
                                                  fit: BoxFit.cover,
                                                )
                                              : (value
                                                          .cartList[sectionPath
                                                              .section]
                                                          .owner_id ==
                                                      AppConfig.PIC_ORDER_ID)
                                                  ? Lottie.asset(
                                                      'assets/lottie/tack_pic.json',
                                                      repeat: false,
                                                      width: 32,
                                                      height: 32,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Lottie.asset(
                                                      'assets/lottie/cart3.json',
                                                      width: 32,
                                                      height: 32,
                                                      fit: BoxFit.cover,
                                                    ),
                                          SizedBox(
                                            width: (value
                                                        .cartList[
                                                            sectionPath.section]
                                                        .owner_id ==
                                                    AppConfig.PIC_ORDER_ID)
                                                ? 20
                                                : 10,
                                          ),
                                          Text(
                                            value.cartList[sectionPath.section]
                                                    .name +
                                                ' ( ${value.cartList[sectionPath.section].cart_items.length} )',
                                            style: TextStyle(
                                              color: fontColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                childBuilder: (context, indexPath) {
                                  if (value.cartList[indexPath.section]
                                          .owner_id ==
                                      AppConfig.VOICE_RECORD_ID) {
                                    return RecordCartCard(
                                      cartItem: value
                                          .cartList[indexPath.section]
                                          .cart_items[indexPath.child],
                                      row: indexPath.section,
                                      payment: true,
                                      col: indexPath.child,
                                    );
                                  } else if (value.cartList[indexPath.section]
                                          .owner_id ==
                                      AppConfig.PIC_ORDER_ID) {
                                    return ImageOrderCard(
                                      cartItem: value
                                          .cartList[indexPath.section]
                                          .cart_items[indexPath.child],
                                      row: indexPath.section,
                                      payment: true,
                                      col: indexPath.child,
                                    );
                                  } else if (value.cartList[indexPath.section]
                                          .owner_id ==
                                      AppConfig.TEXT_ORDER_ID) {
                                    return TextOrderCard(
                                      cartItem: value
                                          .cartList[indexPath.section]
                                          .cart_items[indexPath.child],
                                      row: indexPath.section,
                                      col: indexPath.child,
                                      payment: true,
                                    );
                                  }

                                  return ProductCartCard(
                                    cartItem: value.cartList[indexPath.section]
                                        .cart_items[indexPath.child],
                                    row: indexPath.section,
                                    payment: true,
                                    col: indexPath.child,
                                  );
                                }),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 70,
                          ),
                        ),
                      ],
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: FlatButton(
        onPressed: submitOrder,
        color: primaryColor,
        child: Container(
            height: 70,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  color: whiteColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  getLang(context, 'confirm_order'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: whiteColor,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  applyCoupon() async {
    await CouponRepository()
        .getCouponApplyResponse(textEditingController.text)
        .then((value) {
      if (value.result) {
        setState(() {
          cartSummary = null;
          getSummery();
        });
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: value.message,
            backgroundColor: Colors.green,
          ),
          displayDuration: Duration(seconds: 1),
        );
      } else {
        setState(() {
          enableToEnterCupon = true;
        });
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: value.message,
          ),
          displayDuration: Duration(seconds: 1),
        );
      }
    });
  }

  removeCoupon() async {
    setState(() {
      cartSummary = null;
    });
    await CouponRepository()
        .getCouponRemoveResponse(user_id.$)
        .then((value) {
      getSummery();
      enableToEnterCupon = true;
      if (value.result) {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: value.message,
            backgroundColor: Colors.green,
          ),
          displayDuration: Duration(seconds: 1),
        );
      } else {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: value.message,
          ),
          displayDuration: Duration(seconds: 1),
        );
      }
    });
  }

  submitOrder() async {
    if (address == null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ViewAddress()))
          .then((_) {
        setState(() {
          cartSummary = null;
        });
        getSummery();
      });
    } else {
      CoolAlert.show(
          context: context,
          barrierDismissible: false,
          lottieAsset: 'assets/lottie/plan.json',
          type: CoolAlertType.loading,
          title: getLang(context, 'Placing order..'));

      await AddressRepository().getAddressUpdateInCartResponse(address.id);
      PaymentRepository()
          .getOrderCreateResponse('cash_on_delivery')
          .then((value) {
        if (value.result) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: value.message,
              backgroundColor: Colors.green,
            ),
            displayDuration: Duration(seconds: 1),
          );
          Provider.of<CartProvider>(context, listen: false)
              .setCartProductsListToEmpty();
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(
                        id: value.order_id,
                      )));
        } else {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: value.message,
            ),
            displayDuration: Duration(seconds: 1),
          );
        }
      });
    }
  }
}
