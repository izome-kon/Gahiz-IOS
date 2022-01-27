import 'package:denta_needs/Common/custom_drawer.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Screens/Offers/offer_card.dart';
import 'package:denta_needs/Screens/Product/wholesaler_card.dart';
import 'package:denta_needs/Screens/Profile/edit_profile.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_page_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          getLang(context, 'profile'),
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
      ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                avatar_original.$ != ''
                    ? CircleAvatar(
                        radius: 70,
                        backgroundColor: primaryColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Container(
                            width: 136,
                            height: 136,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                              image: AppConfig.BASE_PATH_FOR_NETWORK +
                                  avatar_original.$,
                            ),
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
                  '${user_name.$}',
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user_phone.$}',
                  style: TextStyle(
                    color: fontColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          height: 210,
        ),
        Container(
          color: whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  getLang(context, 'name'),
                  style: TextStyle(color: fontColor.withOpacity(0.5)),
                ),
                trailing: Text(
                  '${user_name.$}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  getLang(context, 'phone_number'),
                  style: TextStyle(color: fontColor.withOpacity(0.5)),
                ),
                trailing: Text(
                  '${user_phone.$}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  getLang(context, 'account_type'),
                  style: TextStyle(color: fontColor.withOpacity(0.5)),
                ),
                trailing: Text(
                  getLang(context, user_email.$),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
            color: primaryColor,
            minWidth: MediaQuery.of(context).size.width - 10,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => EditProfile(),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            child: Text(getLang(context, 'edit_profile'),
                style: TextStyle(
                  color: whiteColor,
                )))
      ]),
    );
  }
}
