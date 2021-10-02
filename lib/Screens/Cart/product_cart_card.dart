import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Common/toast_component.dart';
import 'package:denta_needs/Helper/PositionInCart.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Cart/cart_response.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProductCartCard extends StatefulWidget {
  final bool payment;
  final CartItem cartItem;
  final row, col; //supplier index , product index

  ProductCartCard({this.payment = false, this.cartItem, this.col, this.row});

  @override
  _ProductCartCardState createState() => _ProductCartCardState();
}

class _ProductCartCardState extends State<ProductCartCard> {
  PositionInCart positionInCart;
  bool deleteIsLoading = false;

  @override
  void initState() {
    positionInCart = Provider.of<CartProvider>(context, listen: false)
        .getPosition(widget.cartItem.product_id);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        children: [
          Container(
              width: 90,
              height: 90,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: AppConfig.BASE_PATH +
                    widget.cartItem.product_thumbnail_image,
                width: 120,
              )),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  widget.cartItem.product_name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                      fontSize: 14),
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      color: accentColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.cartItem.price.toStringAsFixed(2)} ${widget.cartItem.currency_symbol}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ],
                ),
                Spacer(),
                widget.payment
                    ? Text(
                        getLang(context, 'quantity') +
                            " : " +
                            widget.cartItem.quantity.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: fontColor.withOpacity(0.7)))
                    : Consumer<CartProvider>(
                        builder: (context, value, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: accentColor.withOpacity(0.2))),
                                padding: EdgeInsets.all(2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (widget.cartItem.quantity - 1 != 0) {
                                          value.updateCartLocal(
                                              context,
                                              widget.cartItem.product_id,
                                              widget.cartItem.quantity - 1,
                                              lowerLimit: 1,
                                              upperLimit:
                                                  widget.cartItem.upper_limit);
                                          setState(() {
                                            widget.cartItem.quantity--;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: redColor,
                                      ),
                                    ),
                                    Text(
                                      widget.cartItem.quantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (widget.cartItem.quantity <
                                            widget.cartItem.upper_limit) {
                                          value.updateCartLocal(
                                              context,
                                              widget.cartItem.product_id,
                                              widget.cartItem.quantity + 1,
                                              lowerLimit: 1,
                                              upperLimit:
                                                  widget.cartItem.upper_limit);
                                          setState(() {
                                            widget.cartItem.quantity++;
                                          });
                                        } else {
                                          showTopSnackBar(
                                            context,
                                            CustomSnackBar.info(
                                              backgroundColor: primaryColor,
                                              message: getLang(context,
                                                  "You have reached the limit from this product"),
                                            ),
                                            displayDuration:
                                                Duration(seconds: 1),
                                          );
                                        }
                                      },
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Consumer<CartProvider>(
                                builder: (context, value, child) {
                                  return IconButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.warning,
                                            text: getLang(context,
                                                "Are you sure to delete from the cart?"),
                                            confirmBtnText:
                                                getLang(context, 'Delete'),
                                            cancelBtnText:
                                                getLang(context, 'Cancel'),
                                            showCancelBtn: true,
                                            confirmBtnColor: Colors.red,

                                            onConfirmBtnTap: () {
                                              setState(() {
                                                deleteIsLoading = true;
                                              });
                                              Navigator.pop(context);
                                              value
                                                  .deleteFromCart(
                                                      context,
                                                      widget
                                                          .cartItem.product_id)
                                                  .then((_) {
                                                value.getData().then((value) {
                                                  setState(() {
                                                    deleteIsLoading = false;
                                                  });
                                                });
                                              });
                                            });
                                      },
                                      splashRadius: 1,
                                      constraints: BoxConstraints(minWidth: 10),
                                      padding: EdgeInsets.zero,
                                      icon: deleteIsLoading
                                          ? CircularProgressIndicator(
                                              backgroundColor: Colors.red,
                                              color: primaryColor,
                                            )
                                          : Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ));
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
