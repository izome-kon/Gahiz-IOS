import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:lottie/lottie.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({Key key}) : super(key: key);

  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  /// list of pages
  var page;

  @override
  Widget build(BuildContext context) {
    page = [
      PageViewModel(
        pageBackground: Image.asset(
          'assets/images/pattern2.png',
          fit: BoxFit.cover,
          width: 2000,
        ),
        pageColor: Colors.white.withOpacity(0.5),
        bubbleBackgroundColor: primaryColor,
        body: Container(
            height: 100,
            child: Column(
              children: [
                Text(
                  getLang(context, 'One Stop Shop'),
                  style: TextStyle(
                    fontSize: 22,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getLang(context,
                      "Browse many products and suppliers easily from one place"),
                )
              ],
            )),
        bubble: Icon(
          Icons.store_outlined,
          color: Colors.white,
        ),
        title: Logo(
          LogoType.DARK,
          enableTitle: false,
          size: 50,
        ),
        mainImage: Lottie.asset(
          'assets/lottie/select.json',
        ),
        bodyTextStyle: TextStyle(color: fontColor, fontSize: 16),
      ),
      PageViewModel(
        pageColor: Color.fromRGBO(245, 242, 239, 0.6),
        pageBackground: Image.asset(
          'assets/images/pattern2.png',
          fit: BoxFit.cover,
          width: 2000,
        ),
        bubble: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white,
        ),
        bubbleBackgroundColor: primaryColor,
        body: Container(
            height: 100,
            child: Column(
              children: [
                Text(
                  getLang(context, 'Easy To Use'),
                  style: TextStyle(
                    fontSize: 22,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getLang(context,
                      'You can order products from more than one supplier at the same time'),
                )
              ],
            )),
        title: Logo(
          LogoType.DARK,
          enableTitle: false,
          size: 50,
        ),
        mainImage:
        Lottie.asset('assets/lottie/select_products.json', repeat: false),
        bodyTextStyle: TextStyle(color: fontColor, fontSize: 16),
      ),
      PageViewModel(
        pageBackground: Image.asset(
          'assets/images/pattern2.png',
          fit: BoxFit.cover,
          width: 2000,
        ),
        pageColor: Colors.white.withOpacity(0.5),
        bubbleBackgroundColor: primaryColor,
        body: Container(
            height: 100,
            child: Column(
              children: [
                Text(
                  getLang(context, 'We live to save time'),
                  style: TextStyle(
                    fontSize: 22,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getLang(context,
                      'A delivery services you can depend on with direct follow up of order status'),
                )
              ],
            )),
        title: Logo(
          LogoType.DARK,
          enableTitle: false,
          size: 50,
        ),
        bubble: Icon(
          Icons.location_on_outlined,
          color: Colors.white,
        ),
        mainImage: Lottie.asset('assets/lottie/delivery.json'),
        bodyTextStyle: TextStyle(color: fontColor, fontSize: 16),
      ),
    ];
    return IntroViewsFlutter(
      page,
      onTapDoneButton: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
      },
      doneText: Text(getLang(context, 'Get Started')),
      background: Colors.white,
      showSkipButton: false,
      pageButtonsColor: primaryColor,
      pageButtonTextStyles: TextStyle(
        fontSize: 18.0,
      ),
    );
  }
}
