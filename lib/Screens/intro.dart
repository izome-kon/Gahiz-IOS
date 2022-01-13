import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({Key key}) : super(key: key);

  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  /// list of pages
  var page;

  List<PageViewModel> listPagesViewModel;

  @override
  Widget build(BuildContext context) {
    listPagesViewModel = [
      PageViewModel(
        title: getLang(context, 'One Stop Shop'),
        body: getLang(context,
            "Browse many products and suppliers easily from one place"),
        image: Lottie.asset(
          'assets/lottie/select.json',
        ),
        decoration: const PageDecoration(
          imageFlex: 2,
          boxDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pattern2.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 18.0),
        ),
      ),
      PageViewModel(
        title: getLang(context, 'Easy To Use'),
        body: getLang(context,
            'You can order products from more than one supplier at the same time'),
        image:
            Lottie.asset('assets/lottie/select_products.json', repeat: false),
        decoration: const PageDecoration(
          imageFlex: 2,
          boxDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pattern2.png'),
              fit: BoxFit.cover,
            ),
            color: Color.fromRGBO(245, 242, 239, 0.8),
          ),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 18.0),
        ),
      ),
      PageViewModel(
        title: getLang(context, 'We live to save time'),
        body: getLang(context,
            'A delivery services you can depend on with direct follow up of order status'),
        image: Lottie.asset('assets/lottie/delivery.json'),
        decoration: const PageDecoration(
          imageFlex: 2,
          boxDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pattern2.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 18.0),
        ),
      ),
    ];

    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
      },
      globalBackgroundColor: Colors.white,
      showSkipButton: true,
      skip: Text(
        getLang(context, 'skip'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      next: const Icon(Icons.chevron_right_rounded),
      done: Text(getLang(context, 'start'),
          style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: accentColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );

    // IntroViewsFlutter(
    //   page,
    //   onTapDoneButton: () {
    //     Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
    //   },
    //   doneText: Text(getLang(context, 'Get Started')),
    //   background: Colors.white,
    //   showSkipButton: false,
    //   pageButtonsColor: primaryColor,
    //   pageButtonTextStyles: TextStyle(
    //     fontSize: 18.0,
    //   ),
    // );
  }
}
