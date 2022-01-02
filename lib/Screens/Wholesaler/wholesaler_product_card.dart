import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Screens/Product/product_page2.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

class WholesalerProductCard extends StatefulWidget {
  final Product product;

  WholesalerProductCard({this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<WholesalerProductCard> {
  bool showAddToCartIcon = true;

  /// page is loading data
  bool isLoading = false;

  /// delete button is loading
  bool isDeleteLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (context, value, child) => Card(
                child: InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ProductDetails(
                      id: widget.product.id,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    foregroundDecoration: null,
                    decoration: value
                                .productsList[widget.product.id.toString()] ==
                            null
                        ? null
                        : BoxDecoration(
                            border: Border.all(width: 2, color: primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Container(
                            width: 120,
                            height: 120,
                            child: value.productsList[
                                        widget.product.id.toString()] !=
                                    null
                                ? value.productsList[
                                                widget.product.id.toString()] ==
                                            1 &&
                                        showAddToCartIcon
                                    ? Lottie.asset(
                                        'assets/lottie/add_to_cart2.json',
                                        repeat: false, onLoaded: (s) {
                                        Timer(
                                            Duration(
                                                seconds: s.seconds.toInt()),
                                            () {
                                          if (this.mounted)
                                            setState(() {
                                              showAddToCartIcon = false;
                                            });
                                        });
                                      })
                                    : Center(
                                        child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/placeholder.png',
                                        image: AppConfig.BASE_PATH +
                                            widget.product.thumbnail_image,
                                        width: 120,
                                      ))
                                : Center(
                                    child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.png',
                                    image: AppConfig.BASE_PATH +
                                        widget.product.thumbnail_image,
                                    width: 120,
                                  )),
                          ),
                          Spacer(),
                          AutoSizeText(
                            widget.product.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                          Container(
                            height: 40,
                            child: Stack(
                              children: [
                                widget.product.discount == null ||
                                        widget.product.discount == 0
                                    ? Container()
                                    : Align(
                                        child: widget.product.base_price == 0
                                            ? Text(
                                                'Price is determined upon request',
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: fontColor
                                                        .withOpacity(0.5)),
                                              )
                                            : Text(
                                                (widget.product.base_price)
                                                        .toStringAsFixed(2) +
                                                    widget.product
                                                        .currency_symbol,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: fontColor
                                                        .withOpacity(0.5)),
                                              ),
                                        alignment: Alignment.topLeft,
                                      ),
                                Align(
                                  child: widget.product.base_price == 0
                                      ? Text(
                                          'Price is determined upon request',
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  fontColor.withOpacity(0.5)),
                                        )
                                      : Text(
                                          widget.product.discount != null ||
                                                  widget.product.discount != 0
                                              ? (widget.product.base_price -
                                                          widget
                                                              .product.discount)
                                                      .toStringAsFixed(2) +
                                                  widget.product.currency_symbol
                                              : widget.product.base_price
                                                      .toStringAsFixed(2) +
                                                  widget
                                                      .product.currency_symbol,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        ),
                                  alignment: Alignment.bottomCenter,
                                ),
                              ],
                            ),
                          ),
                          isLoading
                              ? Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          10,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      backgroundColor: primaryColor,
                                    ),
                                  ),
                                )
                              : widget.product.current_stock != 0
                                  ? InkWell(
                                      onTap: () {
                                        if (value.productsList[
                                                widget.product.id.toString()] !=
                                            null) {
                                          value.updateCartLocal(
                                              context,
                                              widget.product.id,
                                              (value.productsList[widget
                                                      .product.id
                                                      .toString()] +
                                                  1),
                                              lowerLimit: 1,
                                              upperLimit:
                                                  widget.product.current_stock);
                                        } else {
                                          value.updateCartLocal(
                                              context, widget.product.id, 1,
                                              lowerLimit: 1,
                                              upperLimit:
                                                  widget.product.current_stock);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: primaryColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                10,
                                        height: 40,
                                        child: value.productsList[widget
                                                    .product.id
                                                    .toString()] ==
                                                null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: primaryColor,
                                                  ),
                                                  Text(
                                                    getLang(
                                                        context, 'Add to cart'),
                                                    style: TextStyle(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : value.productsList[widget
                                                        .product.id
                                                        .toString()] ==
                                                    null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: primaryColor,
                                                      ),
                                                      Text(
                                                        getLang(context,
                                                            'Add to cart'),
                                                        style: TextStyle(
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                        icon:
                                                            Icon(Icons.remove),
                                                        onPressed: () {
                                                          if (value.productsList[
                                                                  widget.product
                                                                      .id
                                                                      .toString()] !=
                                                              null) {
                                                            value.updateCartLocal(
                                                                context,
                                                                widget
                                                                    .product.id,
                                                                (value.productsList[widget
                                                                        .product
                                                                        .id
                                                                        .toString()] -
                                                                    1),
                                                                lowerLimit: 1,
                                                                upperLimit: widget
                                                                    .product
                                                                    .current_stock);
                                                          } else {
                                                            value.updateCartLocal(
                                                                context,
                                                                widget
                                                                    .product.id,
                                                                1,
                                                                lowerLimit: 1,
                                                                upperLimit: widget
                                                                    .product
                                                                    .current_stock);
                                                          }
                                                        },
                                                        color: primaryColor,
                                                      ),
                                                      Text(
                                                        value.productsList[
                                                                widget
                                                                    .product.id
                                                                    .toString()]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.add),
                                                        onPressed: () {
                                                          if (value.productsList[
                                                                  widget.product
                                                                      .id
                                                                      .toString()] !=
                                                              null) {
                                                            value.updateCartLocal(
                                                                context,
                                                                widget
                                                                    .product.id,
                                                                (value.productsList[widget
                                                                        .product
                                                                        .id
                                                                        .toString()] +
                                                                    1),
                                                                lowerLimit: 1,
                                                                upperLimit: widget
                                                                    .product
                                                                    .current_stock);
                                                          } else {
                                                            value.updateCartLocal(
                                                                context,
                                                                widget
                                                                    .product.id,
                                                                1,
                                                                lowerLimit: 1,
                                                                upperLimit: widget
                                                                    .product
                                                                    .current_stock);
                                                          }
                                                        },
                                                        color: primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      widget.product.current_stock != 0
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    bottomRight: Radius.circular(3),
                                  )),
                              padding: EdgeInsets.only(left: 2, right: 5),
                              child: Text(
                                getLang(context, 'Out of stock'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.orange.withOpacity(0.2)),
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(
                          '1 ' + widget.product.unit,
                          style:
                              TextStyle(fontSize: 12, color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                  value.productsList[widget.product.id.toString()] == null
                      ? Container()
                      : value.productsList[widget.product.id.toString()] != null
                          ? Container(
                              padding: EdgeInsets.fromLTRB(8, 45, 0, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Consumer<CartProvider>(
                                    builder: (context, value, child) =>
                                        IconButton(
                                            onPressed: () {
                                              value.deleteFromCartLocal(
                                                  context, widget.product.id);
                                            },
                                            padding: EdgeInsets.all(4),
                                            constraints:
                                                BoxConstraints(minWidth: 5),
                                            splashRadius: 25,
                                            icon: isDeleteLoading
                                                ? CircularProgressIndicator(
                                                    color: primaryColor,
                                                    backgroundColor: Colors.red,
                                                  )
                                                : Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  )),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                ],
              ),
            )));
  }
}
