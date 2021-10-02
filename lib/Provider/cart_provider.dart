import 'dart:convert';

import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Helper/PositionInCart.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/Cart/cart_add_response.dart';
import 'package:denta_needs/Responses/Cart/cart_delete_response.dart';
import 'package:denta_needs/Responses/Cart/cart_response.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CartProvider extends ChangeNotifier {
  Map<String, dynamic> productsList = {}; //cart_id    //qty
  List<CartResponse> cartList = [];
  int productsCount = 0;
  double totalPrice = 0;
  bool sendUpdateRequest = false;

  Future<void> getData() async {
    cartList = await CartRepository().getCartResponseList(user_id.value);
    notifyListeners();
  }

  setCartList(List<CartResponse> cartList) {
    this.cartList = cartList;
    notifyListeners();
  }

  // add to cart

  PositionInCart getPosition(productId) {
    List<int> rowColCartId = getRowColCartIdInCartList(productId);

    return rowColCartId == null
        ? null
        : PositionInCart(rowColCartId[0], rowColCartId[1]);
  }

  Future<void> deleteFromCart(context, productId) async {
    List<int> rowColCartId = getRowColCartIdInCartList(productId);
    if (rowColCartId != null) {
      productsList.remove(productId.toString());
      CartDeleteResponse cdr =
      await CartRepository().getCartDeleteResponse(rowColCartId[2]);
      if (cdr.result) {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: cdr.message,
            backgroundColor: Colors.green,
          ),
          displayDuration: Duration(seconds: 1),
        );
      } else {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            backgroundColor: primaryColor,
            message: cdr.message,
          ),
          displayDuration: Duration(seconds: 1),
        );
      }
    }
  }

  Future<void> deleteAllFromCart(context) async {
    String ids = "";
    for (int i = 0; i < cartList.length; i++) {
      for (int j = 0; j < cartList[i].cart_items.length; j++) {
        if (j + 1 == cartList[i].cart_items.length &&
            cartList.length == i + 1) {
          ids += cartList[i].cart_items[j].id.toString();
        } else {
          ids += cartList[i].cart_items[j].id.toString() + ',';
        }
      }
    }
    print(ids);
    sendUpdateRequest = true;
    productsList = {};
    CartRepository().getCartDeleteAllResponse(ids).then((value) {
      setCartList(List<CartResponse>());
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: value.message,
          backgroundColor: Colors.green,
        ),
        displayDuration: Duration(seconds: 1),
      );
    });
  }

  List<int> getRowColCartIdInCartList(productId) {
    if (cartList != null) {
      for (int i = 0; i < cartList.length; i++) {
        for (int j = 0; j < cartList[i].cart_items.length; j++) {
          if (cartList[i].cart_items[j].product_id == productId) {
            return [i, j, cartList[i].cart_items[j].id];
          }
        }
      }
    }
    return null;
  }

  saveCartLocal() {}

  /////// LOCAL

  updateCartLocal(context, int productId, int qty,
      {int upperLimit, int lowerLimit}) {
    if (qty > upperLimit) {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          backgroundColor: primaryColor,
          message: getLang(context, 'Only') + ' $upperLimit ' +
              getLang(context, 'item(s) are available'),
        ),
        displayDuration: Duration(seconds: 1),
      );
      return;
    }
    if (qty < lowerLimit) {
      sendUpdateRequest = true;
      productsList.remove(productId.toString());
      setCartList(null);
      notifyListeners();
      return;
    }
    sendUpdateRequest = true;
    productsList[productId.toString()] = qty;
    SharedValueHelper.setCartList(jsonEncode(productsList));
    print(SharedValueHelper.getCartList());
    notifyListeners();
  }

  deleteFromCartLocal(context, int productId) {
    sendUpdateRequest = true;
    productsList.remove(productId.toString());
    SharedValueHelper.setCartList(jsonEncode(productsList));
    deleteFromCart(context, productId);
    notifyListeners();
  }

  setCartProductsListToEmpty() {
    sendUpdateRequest = true;
    productsList.clear();
    SharedValueHelper.setCartList(jsonEncode(productsList));
    notifyListeners();
  }
}
