import 'dart:convert';
import 'dart:ui';

import 'package:denta_needs/Apis/auth_repository.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/pushNotificationServices.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Screens/intro.dart';
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    PushNotificationService().initialise(context);

    /// remove status bar from this screen ( status bar is bar contain clock and battery)
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    ///before going to other screen show status bar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  Future<Widget> loadFromFuture() async {
    /// load token from device
    await access_token.load().whenComplete(() async {
      await is_first_login.load();
      var userByTokenResponse = await AuthRepository().getUserByTokenResponse();
      if (userByTokenResponse.result == true) {
        loadCart();
        updateSharedValues(userByTokenResponse);
        setFreshChatUser(userByTokenResponse);
      }
    });

    /// if user first login will navigate to introduction screens
    /// if token found in device will navigate to home screen
    /// else will navigate to login screen
    if (is_first_login.$) return IntroPages();
    return is_logged_in.$ ? Main() : Login();
  }

  /// (If the user has products in the cart and closes the application, they will be kept locally)
  /// Load Cart from local device
  loadCart() {
    CartProvider cartProvider;
    if (this.mounted)
      cartProvider = Provider.of<CartProvider>(context, listen: false);
    var cartLocal = SharedValueHelper.getCartList() != null
        ? jsonDecode(SharedValueHelper.getCartList())
        : Map<String, dynamic>();
    if (this.mounted) cartProvider.productsList = cartLocal;
    if (cartLocal != {} && this.mounted) cartProvider.sendUpdateRequest = true;
  }

  /// Change values in device by values from api response
  updateSharedValues(userByTokenResponse) {
    is_logged_in.$ = true;
    is_first_login.$ = false;
    is_first_login.save();
    user_id.$ = userByTokenResponse.id;
    user_name.$ = userByTokenResponse.name;
    user_email.$ = userByTokenResponse.email;
    user_phone.$ = userByTokenResponse.phone;
    avatar_original.$ = userByTokenResponse.avatar_original;
  }

  ///
  setFreshChatUser(userByTokenResponse) async {
    FreshchatUser freshchatUser = await Freshchat.getUser;
    freshchatUser.setFirstName(userByTokenResponse.name);
    freshchatUser.setPhone(
        '+20',
        userByTokenResponse.phone
            .substring(3, userByTokenResponse.phone.length));
    Freshchat.setUser(freshchatUser);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen(
      navigateAfterFuture: loadFromFuture(),
      title: Center(
        child: CircularProgressIndicator(
          backgroundColor: primaryColor,
          color: whiteColor,
        ),
      ),
      // useLoader: false,
      loadingText: Text(
        AppConfig.copyrightText,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
          color: fontColor,
        ),
      ),
      image: Image.asset('assets/logo/logo-light.png'),
      backgroundImage: Image.asset(
        "assets/images/pattern2.png",
        fit: BoxFit.cover,
        width: 500,
      ),
      loaderColor: primaryColor,
      backgroundColor: Colors.white,
      photoSize: 60.0,
      backgroundPhotoSize: 140.0,
    );
  }
}

class CustomSplashScreen extends StatefulWidget {
  /// Seconds to navigate after for time based navigation
  final int seconds;

  /// App title, shown in the middle of screen in case of no image available
  final Widget title;

  /// Page background color
  final Color backgroundColor;

  /// Style for the laodertext
  final TextStyle styleTextUnderTheLoader;

  /// The page where you want to navigate if you have chosen time based navigation
  final dynamic navigateAfterSeconds;

  /// Main image size
  final double photoSize;

  final double backgroundPhotoSize;

  /// Triggered if the user clicks the screen
  final dynamic onClick;

  /// Loader color
  final Color loaderColor;

  /// Main image mainly used for logos and like that
  final Image image;

  final Image backgroundImage;

  /// Loading text, default: "Loading"
  final Text loadingText;

  ///  Background image for the entire screen
  final ImageProvider imageBackground;

  /// Background gradient for the entire screen
  final Gradient gradientBackground;

  /// Whether to display a loader or not
  final bool useLoader;

  /// Custom page route if you have a custom transition you want to play
  final Route pageRoute;

  /// RouteSettings name for pushing a route with custom name (if left out in MaterialApp route names) to navigator stack (Contribution by Ramis Mustafa)
  final String routeName;

  /// expects a function that returns a future, when this future is returned it will navigate
  final Future<dynamic> navigateAfterFuture;

  /// Use one of the provided factory constructors instead of.
  @protected
  CustomSplashScreen({
    this.loaderColor,
    this.navigateAfterFuture,
    this.seconds,
    this.photoSize,
    this.backgroundPhotoSize,
    this.pageRoute,
    this.onClick,
    this.navigateAfterSeconds,
    this.title = const Text(''),
    this.backgroundColor = Colors.white,
    this.styleTextUnderTheLoader = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    this.image,
    this.backgroundImage,
    this.loadingText = const Text(""),
    this.imageBackground,
    this.gradientBackground,
    this.useLoader = true,
    this.routeName,
  });

  factory CustomSplashScreen.timer(
          {@required int seconds,
          Color loaderColor,
          Color backgroundColor,
          double photoSize,
          Text loadingText,
          Image image,
          Route pageRoute,
          dynamic onClick,
          dynamic navigateAfterSeconds,
          Text title,
          TextStyle styleTextUnderTheLoader,
          ImageProvider imageBackground,
          Gradient gradientBackground,
          bool useLoader,
          String routeName}) =>
      CustomSplashScreen(
        loaderColor: loaderColor,
        seconds: seconds,
        photoSize: photoSize,
        loadingText: loadingText,
        backgroundColor: backgroundColor,
        image: image,
        pageRoute: pageRoute,
        onClick: onClick,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        styleTextUnderTheLoader: styleTextUnderTheLoader,
        imageBackground: imageBackground,
        gradientBackground: gradientBackground,
        useLoader: useLoader,
        routeName: routeName,
      );

  factory CustomSplashScreen.network(
          {@required Future<dynamic> navigateAfterFuture,
          Color loaderColor,
          Color backgroundColor,
          double photoSize,
          double backgroundPhotoSize,
          Text loadingText,
          Image image,
          Route pageRoute,
          dynamic onClick,
          dynamic navigateAfterSeconds,
          Text title,
          TextStyle styleTextUnderTheLoader,
          ImageProvider imageBackground,
          Gradient gradientBackground,
          bool useLoader,
          String routeName}) =>
      CustomSplashScreen(
        loaderColor: loaderColor,
        navigateAfterFuture: navigateAfterFuture,
        photoSize: photoSize,
        backgroundPhotoSize: backgroundPhotoSize,
        loadingText: loadingText,
        backgroundColor: backgroundColor,
        image: image,
        pageRoute: pageRoute,
        onClick: onClick,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        styleTextUnderTheLoader: styleTextUnderTheLoader,
        imageBackground: imageBackground,
        gradientBackground: gradientBackground,
        useLoader: useLoader,
        routeName: routeName,
      );

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.routeName != null &&
        widget.routeName is String &&
        "${widget.routeName[0]}" != "/") {
      throw ArgumentError(
          "widget.routeName must be a String beginning with forward slash (/)");
    }
    if (widget.navigateAfterFuture == null) {
      Timer(Duration(seconds: widget.seconds), () {
        if (widget.navigateAfterSeconds is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context)
              .pushReplacementNamed(widget.navigateAfterSeconds);
        } else if (widget.navigateAfterSeconds is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : MaterialPageRoute(
                  settings: widget.routeName != null
                      ? RouteSettings(name: "${widget.routeName}")
                      : null,
                  builder: (BuildContext context) =>
                      widget.navigateAfterSeconds));
        } else {
          throw ArgumentError(
              'widget.navigateAfterSeconds must either be a String or Widget');
        }
      });
    } else {
      widget.navigateAfterFuture.then((navigateTo) {
        if (navigateTo is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(navigateTo);
        } else if (navigateTo is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : MaterialPageRoute(
                  settings: widget.routeName != null
                      ? RouteSettings(name: "${widget.routeName}")
                      : null,
                  builder: (BuildContext context) => navigateTo));
        } else {
          throw ArgumentError(
              'widget.navigateAfterFuture must either be a String or Widget');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: widget.onClick,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: widget.imageBackground == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.imageBackground,
                      ),
                gradient: widget.gradientBackground,
                color: widget.backgroundColor,
              ),
            ),
            Stack(
              children: [
                widget.backgroundImage,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 120.0),
                      child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 60.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Hero(
                                    tag: "splashscreenImage",
                                    child: Container(child: widget.image),
                                  ),
                                  radius: widget.photoSize,
                                ),
                              ),
                              widget.title,
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                              widget.loadingText
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
