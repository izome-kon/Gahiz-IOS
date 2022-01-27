import 'package:denta_needs/Apis/order_repository.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OrderFeedback extends StatefulWidget {
  final int id;
  const OrderFeedback({Key key, this.id}) : super(key: key);

  @override
  _OrderFeedbackState createState() => _OrderFeedbackState();
}

class _OrderFeedbackState extends State<OrderFeedback> {
  double index = 0;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Please rate the quality of your order',
        style: TextStyle(fontSize: 15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RatingBar.builder(
            initialRating: index,
            itemCount: 5,
            glowColor: primaryColor,
            glowRadius: 0.1,
            glow: false,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                print(rating);
                index = rating;
              });
            },
          ),
          index == 0
              ? Container()
              : TextField(
                  onChanged: (s) {
                    message = s;
                  },
                  decoration: InputDecoration(hintText: 'write something..'),
                ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text(
            'NOT NOW',
            style: TextStyle(color: primaryColor),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          onPressed: index == 0
              ? null
              : () {
                  OrderRepository()
                      .rateOrder(
                    orderId: widget.id,
                    rate: index,
                    message: message,
                  )
                      .then((value) {
                    if (value.result) {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.success(
                          message: value.message,
                          backgroundColor: Colors.green,
                        ),
                        displayDuration: Duration(seconds: 3),
                      );
                      Navigator.pop(context);
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
                },
          child: Text(
            'SUBMIT',
            style: TextStyle(color: index != 0 ? primaryColor : Colors.grey),
          ),
        ),
      ],
    );
  }
}
