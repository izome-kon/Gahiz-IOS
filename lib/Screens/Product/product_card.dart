import 'package:auto_size_text/auto_size_text.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Product/productResponse.dart';
import 'package:denta_needs/Screens/Product/product_page2.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, prov, child) {
        return Stack(
          children: [
            Card(
              child: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => ProductDetails(
                              id: widget.product.id,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (value.productsList[widget.product.id.toString()] !=
                            null) {
                          value.updateCartLocal(
                              context,
                              widget.product.id,
                              (value.productsList[
                                      widget.product.id.toString()] +
                                  1),
                              lowerLimit: 1,
                              upperLimit: widget.product.current_stock);
                        } else {
                          value.updateCartLocal(context, widget.product.id, 1,
                              lowerLimit: 1,
                              upperLimit: widget.product.current_stock);
                        }
                      },
                      child: Container(
                        decoration:
                            value.productsList[widget.product.id.toString()] ==
                                    null
                                ? null
                                : BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: primaryColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                        foregroundDecoration:
                            (widget.product.discount != null && 0 != 0)
                                ? RotatedCornerDecoration(
                                    color: accentColor,
                                    geometry: const BadgeGeometry(
                                        width: 50, height: 50),
                                    textSpan: TextSpan(
                                      text: '%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 4)
                                        ],
                                      ),
                                    ),
                                  )
                                : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                height: 150,
                                child: Center(
                                  child: widget.product.thumbnail_image == ""
                                      ? Image.asset(
                                          'assets/images/placeholder.png')
                                      : FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/images/placeholder.png',
                                          fit: BoxFit.cover,
                                          image: AppConfig.BASE_PATH +
                                              widget.product.thumbnail_image,
                                        ),
                                ),
                              ),
                              Spacer(),
                              AutoSizeText(
                                widget.product.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 2,
                              ),
                              Container(
                                height: 35,
                                child: Stack(
                                  children: [
                                    widget.product.discount == null ||
                                            widget.product.discount == 0
                                        ? Container()
                                        : Align(
                                            child: Text(
                                              (widget.product.base_price)
                                                      .toStringAsFixed(2) +
                                                  widget
                                                      .product.currency_symbol,
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
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        widget.product.discount != null ||
                                                widget.product.discount != 0
                                            ? (widget.product.base_price -
                                                        widget.product.discount)
                                                    .toStringAsFixed(2) +
                                                widget.product.currency_symbol
                                            : widget.product.base_price
                                                    .toStringAsFixed(2) +
                                                widget.product.currency_symbol,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              value.productsList[
                                          widget.product.id.toString()] ==
                                      null
                                  ? Container()
                                  : InkWell(
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
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    onPressed: () {
                                                      if (value.productsList[
                                                              widget.product.id
                                                                  .toString()] !=
                                                          null) {
                                                        value.updateCartLocal(
                                                            context,
                                                            widget.product.id,
                                                            (value.productsList[
                                                                    widget
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
                                                            widget.product.id,
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
                                                    value.productsList[widget
                                                            .product.id
                                                            .toString()]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      if (value.productsList[
                                                              widget.product.id
                                                                  .toString()] !=
                                                          null) {
                                                        value.updateCartLocal(
                                                            context,
                                                            widget.product.id,
                                                            (value.productsList[
                                                                    widget
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
                                                            widget.product.id,
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
                                    ),
                            ],
                          ),
                        ),
                      ));
                },
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
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            )),
                        padding: EdgeInsets.only(left: 2, right: 5),
                        child: Text(
                          getLang(context, 'Out of stock'),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orange.withOpacity(0.2)),
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    '1 ' + widget.product.unit,
                    style: TextStyle(fontSize: 12, color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
            Consumer<CartProvider>(
              builder: (context, value, child) {
                return value.productsList[widget.product.id.toString()] == null
                    ? Container()
                    : value.productsList[widget.product.id.toString()] != null
                        ? Container(
                            padding: EdgeInsets.fromLTRB(8, 45, 8, 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          )),
                                ),
                              ),
                            ),
                          )
                        : Container();
              },
            ),
          ],
        );
      },
    );
  }
}
