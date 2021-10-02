import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String pageName;
  CustomAppBar([this.pageName]);
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: primaryColor,
            ))
      ],
      title: Text(
        getLang(context, widget.pageName),
        style: TextStyle(color: accentColor, fontSize: 18),
      ),
    );
  }
}
