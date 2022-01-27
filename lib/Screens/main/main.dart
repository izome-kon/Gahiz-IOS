import 'dart:async';

import 'package:blur/blur.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/settings.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Auth/login_response.dart';
import 'package:denta_needs/Screens/Cart/cart.dart';
import 'package:denta_needs/Screens/OrderFeatchers/record_order.dart';
import 'package:denta_needs/Screens/OrderFeatchers/tack_photo.dart';
import 'package:denta_needs/Screens/OrderFeatchers/take_by_text.dart';

import 'package:denta_needs/Screens/main/categories.dart';
import 'package:denta_needs/Screens/main/home.dart';
import 'package:denta_needs/Screens/main/offers.dart';
import 'package:denta_needs/Screens/main/wholesaler.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/main.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:new_version/new_version.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class Main extends StatefulWidget {
  static GlobalKey presintKeyCart = GlobalKey();
  static bool showBlurMenu = false;
  static AnimationController controller;
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin {
  Animation<double> _animation;

  bool toolTipShow = false;

  StreamSubscription unreadCountSubscription;

  int x = 0;
  bool display = false;
  VersionStatus status;
  NewVersion newVersion ;
  checkVersion() async {
    status = await newVersion.getVersionStatus();
    if (status.canUpdate) {

      newVersion.showUpdateDialog(status);
      // newVersion.showUpdateDialog(
        // context: context,
        // versionStatus: status,
        // allowDismissal: false,
        // dialogTitle: 'Gahiz needs an update',
        // dialogText: 'To use this app, download the latest version.',
        // updateButtonText: 'Update Now',
        // dismissButtonText: 'Later',
        // dismissAction: () {},
      // );
    }
  }

  @override
  initState() {
   newVersion= NewVersion(
    androidId: 'com.gahez',
    iOSId:'com.gahiz',
    context:context,
    dialogTitle: 'Gahiz needs an update',
        dialogText: 'To use this app, download the latest version.',
        dismissAction: (){},
        dismissText:'',
  );
    checkVersion();
    Provider.of<UserProvider>(context, listen: false).loadUnRead();
    Main.controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: Main.controller, curve: Curves.easeInOutSine);

    var unreadCountStream = Freshchat.onMessageCountUpdate;

    unreadCountSubscription = unreadCountStream.listen((event) async {
      var y = await Freshchat.getUnreadCountAsync;
      if (!display && y['count'] > 0)
        showSimpleNotification(
          InkWell(
            onTap: () {
              Freshchat.showConversations();
            },
            child: Text(
              'you have ${y['count']} unread message!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            'click here to open chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          slideDismiss: true,
          duration: Duration(seconds: 3),
          leading: Icon(
            Icons.messenger_outline_rounded,
            color: Colors.white,
          ),
          background: accentColor,
        ).dismissed.then((_) {
          display = false;
        });
      display = true;
    });

    Freshchat.setNotificationConfig(
      priority: Priority.PRIORITY_HIGH,
      importance: Importance.IMPORTANCE_HIGH,
      notificationSoundEnabled: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    unreadCountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: Consumer<Settings>(
            builder: (context, value, child) {
              return Stack(
                children: [
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: value.navBarcontroller,
                    children: [
                      Home(),
                      Wholesaler(),
                      OffersPage(),
                      CategoriesPage(),
                    ],
                  ),
                  Main.showBlurMenu
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              Main.showBlurMenu = false;
                              Main.controller.reset();
                              toolTipShow = false;
                            });
                          },
                          child: Blur(
                            blurColor: Colors.black,
                            colorOpacity: 0.15,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        )
                      : Container(),
                  Main.showBlurMenu
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 200,
                            width: MediaQuery.of(context).size.width - 80,
                            child: Stack(
                              children: [
                                ScaleTransition(
                                  scale: _animation,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 100, height: 120),
                                      child: ElevatedButton(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.asset(
                                                'assets/lottie/voice.json',
                                                repeat: false,
                                                width: 70),
                                            Text(
                                              getLang(context, 'Record Order'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: fontColor),
                                            ),
                                          ],
                                        ),
                                        onPressed: onPressRecordOrder,
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          shape: CircleBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ScaleTransition(
                                  scale: _animation,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 100, height: 120),
                                      child: SimpleTooltip(
                                        animationDuration:
                                            Duration(milliseconds: 200),
                                        show: toolTipShow,
                                        borderWidth: 0,
                                        ballonPadding: EdgeInsets.zero,
                                        tooltipDirection: TooltipDirection.up,
                                        content: Container(
                                          height: 100,
                                          child: Column(
                                            children: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                TackPhotoScreen(
                                                                  imageSource:
                                                                      ImageSource
                                                                          .gallery,
                                                                )));
                                                  },
                                                  color: primaryColor,
                                                  child: Text(
                                                    getLang(context,
                                                        'From gallery'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                TackPhotoScreen(
                                                                  imageSource:
                                                                      ImageSource
                                                                          .camera,
                                                                )));
                                                  },
                                                  color: primaryColor,
                                                  child: Text(
                                                    getLang(
                                                        context, 'Open Camera'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Lottie.asset(
                                                  'assets/lottie/tack_pic.json',
                                                  repeat: false,
                                                  width: 70),
                                              Text(
                                                getLang(context, 'pic Order'),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: fontColor),
                                              ),
                                            ],
                                          ),
                                          onPressed: onPressTackPic,
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            shape: CircleBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ScaleTransition(
                                  scale: _animation,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 100, height: 120),
                                      child: ElevatedButton(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.asset(
                                              'assets/lottie/write_order.json',
                                              repeat: false,
                                              width: 60,
                                            ),
                                            Text(
                                              getLang(context, 'write Order'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: fontColor),
                                            ),
                                          ],
                                        ),
                                        onPressed: onPressTackText,
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          shape: CircleBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            },
          ),
          floatingActionButton: value.productsList.values.length == 0
              ? InkWell(
                  onLongPress: onLongPress,
                  child: Showcase(
                    key: Main.presintKeyCart,
                    description: getLang(context,
                        'Click and hold on cart to order voice, image or text'),
                    child: FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: onCartPress,
                      child: Main.showBlurMenu
                          ? Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            )
                          : Lottie.asset(
                              'assets/lottie/cart.json',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                )
              : InkWell(
                  onLongPress: onLongPress,
                  child: Badge(
                    borderRadius: BorderRadius.circular(8),
                    badgeContent: Consumer<CartProvider>(
                      builder: (context, value, child) {
                        return Text(
                          value.productsList.values.length.toString(),
                          style: TextStyle(color: whiteColor),
                        );
                      },
                    ),
                    alignment: Alignment.topRight,
                    child: FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: onCartPress,
                      child: Main.showBlurMenu
                          ? Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            )
                          : Lottie.asset(
                              'assets/lottie/cart.json',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
          floatingActionButtonLocation: Main.showBlurMenu
              ? FloatingActionButtonLocation.centerFloat
              : FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Consumer<Settings>(
              builder: (context, value, child) {
                return BottomNavigationBar(
                  backgroundColor: whiteColor.withOpacity(0),
                  elevation: 0,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: Colors.grey,
                  selectedLabelStyle: TextStyle(color: primaryColor),
                  unselectedLabelStyle: TextStyle(color: Colors.grey),
                  showUnselectedLabels: true,
                  currentIndex: value.pageIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    setState(() {
                      value.changePageIndex(index);
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: getLang(context, 'home')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.store_outlined),
                        label: getLang(context, 'wholesaler')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.local_offer_outlined),
                        label: getLang(context, 'offers')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.category_outlined),
                        label: getLang(context, 'categories')),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void onLongPress() {
    setState(() {
      Main.showBlurMenu = true;
      Main.controller.forward();
      showSuppliersSteps.$ = false;

      showSuppliersSteps.save();
    });
  }

  void onCartPress() async {
    if (Main.showBlurMenu) {
      setState(() {
        Main.showBlurMenu = false;
        Main.controller.reset();
        toolTipShow = false;
      });
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => CartPage(),
        ),
      );
    }
  }

  void onPressRecordOrder() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RecordOrderScreen()));
  }

  void onPressTackPic() {
    setState(() {
      toolTipShow = !toolTipShow;
    });
  }

  void onPressTackText() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => TackTextScreen()));
  }
}
