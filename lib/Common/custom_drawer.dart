import 'package:badges/badges.dart';
import 'package:denta_needs/Apis/auth_repository.dart';
import 'package:denta_needs/Chat/chat.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/auth_helper.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Screens/MyOrders/my_orders.dart';
import 'package:denta_needs/Screens/WishList/wish_list.dart';
import 'package:denta_needs/Screens/main/profile.dart';
import 'package:denta_needs/Screens/privacy_policy.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:full_screen_image/full_screen_image.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    getCount();
    super.initState();
  }

  int messageCount = 0;

  getCount() {
    Freshchat.getUnreadCountAsync.then((value) {
      setState(() {
        messageCount = value['count'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      avatar_original.value != ''
                          ? CircleAvatar(
                              radius: 70,
                              backgroundColor: primaryColor,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Container(
                                  width: 136,
                                  height: 136,
                                  child: FullScreenWidget(
                                      child: Hero(
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                      image: AppConfig.BASE_PATH +
                                          avatar_original.value,
                                    ),
                                    tag: 'profileImage',
                                  )),
                                ),
                              ),
                            )
                          : Logo(
                              LogoType.DARK,
                              enableTitle: false,
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${user_name.value}',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${user_phone.value}',
                        style: TextStyle(
                          color: fontColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  height: 210,
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => MyOrders(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.shopping_bag_outlined,
                  color: primaryColor,
                ),
                title: Text(
                  getLang(context, 'my_orders'),
                  style: TextStyle(color: fontColor),
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ProfilePage(),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                leading: Icon(
                  Icons.description_outlined,
                  color: primaryColor,
                ),
                title: Text(
                  getLang(context, 'information'),
                  style: TextStyle(color: fontColor),
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => WishList(),
                    ),
                  );
                },
                leading: Icon(
                  FontAwesome.heart_o,
                  color: primaryColor,
                ),
                title: Text(
                  getLang(context, 'wish_list'),
                  style: TextStyle(color: fontColor),
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                onTap: () {
                  Freshchat.showConversations();
                },
                leading: Icon(
                  Icons.messenger_outline,
                  color: primaryColor,
                ),
                trailing: messageCount == 0
                    ? null
                    : Badge(
                        elevation: 0,
                        badgeContent: Text(
                          '$messageCount',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                title: Text(
                  getLang(context, 'support'),
                  style: TextStyle(color: fontColor),
                ),
              ),
              Divider(
                height: 1,
              ),
              // ListTile(
              //   onTap: () {
              //     Freshchat.showFAQ(
              //         showContactUsOnFaqScreens: true,
              //         showContactUsOnAppBar: true,
              //         showFaqCategoriesAsGrid: true,
              //         showContactUsOnFaqNotHelpful: true);
              //   },
              //   leading: Icon(
              //     Icons.help_outline,
              //     color: primaryColor,
              //   ),
              //   title: Text(
              //     getLang(context, 'FAQs'),
              //     style: TextStyle(color: fontColor),
              //   ),
              // ),
              // Divider(
              //   height: 1,
              // ),
              ListTile(
                onTap: () {
                  AuthHelper().clearUserData();
                  Freshchat.resetUser();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Login();
                    }),
                    (Route<dynamic> route) => false,
                  );
                },
                leading: Icon(
                  Icons.logout,
                  color: primaryColor,
                ),
                title: Text(
                  getLang(context, 'log_out'),
                  style: TextStyle(color: fontColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 25),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                                page_name: getLang(context, 'privacy_policy'),
                                url: AppConfig.RAW_BASE_URL +
                                    '/mobile-page/privacypolicy',
                              )));
                },
                child: Text(
                  getLang(context, 'privacy_policy'),
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
