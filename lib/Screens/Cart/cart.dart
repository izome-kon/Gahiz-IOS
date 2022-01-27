import 'package:cool_alert/cool_alert.dart';
import 'package:cupertino_listview/cupertino_listview.dart';
import 'package:denta_needs/Apis/cart_repository.dart';

import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Screens/Cart/image_order_card.dart';

import 'package:denta_needs/Screens/Cart/payment.dart';
import 'package:denta_needs/Screens/Cart/product_cart_card.dart';
import 'package:denta_needs/Screens/Cart/record_card.dart';
import 'package:denta_needs/Screens/Cart/text_order_card.dart';

import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  CartProvider cartProvider;

  int productsCount;

  getData() async {
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
    }
  }

  @override
  void initState() {
    cartProvider = Provider.of<CartProvider>(context, listen: false);

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
            actions: [
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<CartProvider>(
                      builder: (context, value, child) => value.cartList == null
                          ? Container()
                          : value.cartList.isEmpty
                              ? Container()
                              : IconButton(
                                  icon: Icon(
                                    Icons.delete_forever_outlined,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        text: getLang(context,
                                            "Are you sure to delete all products from the cart?"),
                                        confirmBtnText:
                                            getLang(context, 'Delete'),
                                        cancelBtnText:
                                            getLang(context, 'Cancel'),
                                        showCancelBtn: true,
                                        confirmBtnColor: Colors.red,
                                        onConfirmBtnTap: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Navigator.pop(context);
                                          value
                                              .deleteAllFromCart(context)
                                              .then((_) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        });
                                  },
                                ),
                    )
            ],
            iconTheme: IconThemeData(color: primaryColor),
            title: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  getLang(context, 'cart') +
                      " ( ${value.productsList.values.length.toString()} )",
                  style: TextStyle(color: primaryColor, fontSize: 18),
                );
              },
            )),
        body: Consumer<CartProvider>(
          builder: (context, value, child) {
            if (value.cartList != null) {
              if (value.cartList.length == 0) {
                return isLoading == true
                    ? ShimmerHelper().buildListShimmer(item_height: 100.0)
                    : Center(
                        child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Lottie.asset(
                              'assets/lottie/cart_empty.json',
                              repeat: false,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getLang(context, 'Your cart is empty'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: fontColor,
                                  ),
                                ),
                                Text(
                                  getLang(context,
                                      'Get Started by adding you products now'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: fontColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    getLang(context, "Find Products"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: primaryColor,
                                )
                              ],
                            ),
                          )
                        ],
                      ));
              }
            }

            return isLoading == true
                ? ShimmerHelper().buildListShimmer(item_height: 100.0)
                : CupertinoListView.builder(
                    sectionCount: value.cartList.length,
                    itemInSectionCount: (section) =>
                        value.cartList[section].cart_items.length,
                    sectionBuilder: (context, sectionPath, _) => Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              (value.cartList[sectionPath.section].owner_id ==
                                      AppConfig.VOICE_RECORD_ID)
                                  ? Lottie.asset(
                                      'assets/lottie/voice.json',
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                    )
                                  : (value.cartList[sectionPath.section]
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
                                width: (value.cartList[sectionPath.section]
                                            .owner_id ==
                                        AppConfig.PIC_ORDER_ID)
                                    ? 20
                                    : 10,
                              ),
                              Text(
                                value.cartList[sectionPath.section].name +
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
                      if (value.cartList[indexPath.section].owner_id ==
                          AppConfig.VOICE_RECORD_ID) {
                        return RecordCartCard(
                          cartItem: value.cartList[indexPath.section]
                              .cart_items[indexPath.child],
                          row: indexPath.section,
                          col: indexPath.child,
                        );
                      } else if (value.cartList[indexPath.section].owner_id ==
                          AppConfig.PIC_ORDER_ID) {
                        return ImageOrderCard(
                          cartItem: value.cartList[indexPath.section]
                              .cart_items[indexPath.child],
                          row: indexPath.section,
                          col: indexPath.child,
                        );
                      } else if (value.cartList[indexPath.section].owner_id ==
                          AppConfig.TEXT_ORDER_ID) {
                        return TextOrderCard(
                          cartItem: value.cartList[indexPath.section]
                              .cart_items[indexPath.child],
                          row: indexPath.section,
                          col: indexPath.child,
                        );
                      }

                      return ProductCartCard(
                        cartItem: value.cartList[indexPath.section]
                            .cart_items[indexPath.child],
                        row: indexPath.section,
                        col: indexPath.child,
                      );
                    });
          },
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, value, child) {
            if (value.cartList == null) {
              return ShimmerHelper().buildBasicShimmer();
            }
            double total = 0;
            productsCount = 0;
            for (int i = 0; i < value.cartList.length; i++) {
              if (value.cartList[i].owner_id != AppConfig.VOICE_RECORD_ID &&
                  value.cartList[i].owner_id != AppConfig.PIC_ORDER_ID &&
                  value.cartList[i].owner_id != AppConfig.TEXT_ORDER_ID) {
                for (int j = 0; j < value.cartList[i].cart_items.length; j++) {
                  total += value.cartList[i].cart_items[j].quantity *
                      value.cartList[i].cart_items[j].price;
                  productsCount++;
                }
              }
            }
            value.totalPrice = total;
            return value.cartList != null && !isLoading
                ? value.cartList.length == 0 && !isLoading
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3.5,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              getLang(context, 'total') +
                                  " : " +
                                  "${value.totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Spacer(),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        PaymentPage(),
                                  ),
                                );
                                print('updateList.isEmpty');
                              },
                              color: primaryColor,
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Spacer(),
                                    Text(
                                      getLang(context, 'go_to_payment'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                : Container();
          },
        ));
  }
}
