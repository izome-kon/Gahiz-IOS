import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Helper/PositionInCart.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WholesalerCard extends StatefulWidget {
  final productId,
      name,
      price,
      discountedPrice,
      upperLimit,
      currencySymbol,
      logo,
      productName;

  WholesalerCard(
      {this.name,
      this.price,
      this.upperLimit,
      this.productName,
      this.productId,
      this.discountedPrice,
      this.currencySymbol,
      this.logo});

  @override
  _WholesalerCardState createState() => _WholesalerCardState();
}

class _WholesalerCardState extends State<WholesalerCard> {
  PositionInCart positionInCart;
  int i, j;

  bool isLoading = false;

  @override
  void initState() {
    // positionInCart = Provider.of<CartProvider>(context, listen: false)
    //     .getPosition(widget.productId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
              ),
              height: 174,
              foregroundDecoration: value.productsList[widget.productId.toString()] != null
                  // positionInCart != null
                  ? RotatedCornerDecoration(
                      color: Colors.green,
                      geometry: const BadgeGeometry(
                          width: 70,
                          height: 70,
                          alignment: BadgeAlignment.topLeft),
                      textSpan: const TextSpan(
                        text: 'in cart',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 1,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.bold,
                          shadows: [BoxShadow(color: Colors.white)],
                        ),
                      ),
                    )
                  : null,
              child:
                  // Align(
                  //   child: Text(
                  //     (widget.product.base_price).toStringAsFixed(2) +
                  //         widget.product.currency_symbol,
                  //     overflow: TextOverflow.clip,
                  //     style: TextStyle(
                  //         decoration: TextDecoration.lineThrough,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.bold,
                  //         color: fontColor.withOpacity(0.5)),
                  //   ),
                  //   alignment: Alignment.topLeft,
                  // ),
                  Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Center(
                              child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: AppConfig.BASE_PATH + widget.logo,
                            width: 120,
                          )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            widget.price != widget.discountedPrice
                                ? Text(
                                    '${widget.price.toStringAsFixed(2)} ${widget.currencySymbol}',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: fontColor.withOpacity(0.5),
                                        fontSize: 12),
                                  )
                                : Container(),
                            Text(
                              '${widget.discountedPrice.toStringAsFixed(2)} ${widget.currencySymbol}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: primaryColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        value.productsList[widget.productId.toString()] != null
                            // positionInCart != null
                            ? InkWell(
                                splashColor: redColor,
                                onTap: () {
                                  // value.removeFromCart(context,
                                  //     positionInCart:
                                  //         value.getPosition(widget.productId));

                                  value.updateCartLocal(context,widget.productId,
                                      value.productsList[widget.productId.toString()] - 1,
                                      lowerLimit: 1,
                                      upperLimit: widget.upperLimit);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(color: redColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.remove,
                                      color: redColor,
                                    )),
                              )
                            : Container(),
                        Spacer(),
                        value.productsList[widget.productId.toString()] != null
                            // positionInCart != null
                            ? Card(
                                elevation: 2,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                  child: Text(
                                    value.productsList[widget.productId.toString()]
                                        .toString(),
                                    // value.cartList[positionInCart.x]
                                    //     .cart_items[positionInCart.y].quantity
                                    //     .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: accentColor),
                                  ),
                                ),
                              )
                            : Container(),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            // setState(() {
                            //   isLoading = true;
                            // });
                            if (value.productsList[widget.productId.toString()] != null) {
                              value.updateCartLocal(context,widget.productId,
                                  (value.productsList[widget.productId.toString()] + 1),
                                  lowerLimit: 1, upperLimit: widget.upperLimit);
                            } else {
                              value.updateCartLocal(context,widget.productId, 1,
                                  lowerLimit: 1, upperLimit: widget.upperLimit);
                            }

                            // value
                            //     .addToCart(context,
                            //         productId: widget.productId,
                            //         positionInCart: positionInCart)
                            //     .then((value) => {
                            //           setState(() {
                            //             isLoading = false;
                            //             positionInCart = value;
                            //             print(
                            //                 'positionInCart.y ${positionInCart.y}');
                            //           }),
                            //         });
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            width:
                                ((MediaQuery.of(context).size.width / 2) - 60),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: primaryColor,
                                ),
                                value.productsList[widget.productId.toString()] == null
                                    ? Text(
                                        getLang(context, 'Add to cart'),
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ),
            value.productsList[widget.productId.toString()] != null
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: IconButton(
                            onPressed: () {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.warning,
                                  text: "Are you sure to delete from the cart?",
                                  confirmBtnText: 'Delete',
                                  cancelBtnText: 'Cancel',
                                  showCancelBtn: true,
                                  confirmBtnColor: Colors.red,

                                  onConfirmBtnTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Navigator.pop(context);
                                    value
                                        .deleteFromCart(
                                            context, widget.productId)
                                        .then((_) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      value.getData();
                                    });
                                    positionInCart = null;
                                    // CartProvider.updateList.remove(widget.);
                                    print('deleted+${widget.productId}');
                                  });
                            },
                            constraints: BoxConstraints(minWidth: 5),
                            splashRadius: 25,
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  )
                : Container(),
            widget.upperLimit == 0
                ? Container(
                    color: Colors.black12,
                    width: MediaQuery.of(context).size.width,
                    height: 174,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            )),
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Text(
                          getLang(context, 'Out of stock'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  removeProduct(value) {
    int cartItemId;
    for (i = 0; i < value.cartList.length; i++) {
      bool found = false;
      for (j = 0; j < value.cartList[i].cart_items.length; j++) {
        if (widget.productId == value.cartList[i].cart_items[j].product_id) {
          cartItemId = value.cartList[i].cart_items[j].id;
          found = true;
          print('f: $i  --- $j');
          break;
        }
      }
      if (found) break;
    }

    print('te:::' + value.cartList.length.toString());

    CartRepository().getCartDeleteResponse(cartItemId).then((v) {
      print('CartList');

      value.searchInProductsIdsListForDelete(
        cartItemId,
      );
      if (value.cartList[i].cart_items.length != 1)
        value.cartList[i].cart_items.removeAt(j);
      else
        value.cartList.removeAt(i);
      value.setCartList(value.cartList);
      value.productsCount--;
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: "${v.message}",
          backgroundColor: Colors.green,
        ),
        displayDuration: Duration(seconds: 1),
      );
      Navigator.pop(context);
    });
  }
}
