import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TackPhotoScreen extends StatefulWidget {
  final ImageSource imageSource;

  const TackPhotoScreen({this.imageSource});

  @override
  _RecordOrderScreenState createState() => _RecordOrderScreenState();
}

enum TackPhotoScreenState { TACK, VIEW }

class _RecordOrderScreenState extends State<TackPhotoScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: widget.imageSource);
    if (pickedFile != null) {
      _image = await Global.compressFile(File(pickedFile.path));
    } else if (_image == null) {
      Navigator.pop(context);
    }
    if (this.mounted) setState(() {});
  }

  String text = '';

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          getLang(context, 'pic Order'),
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
      ),
      body: Stack(children: [
        Image.asset(
          'assets/images/pattern2.png',
          fit: BoxFit.cover,
          width: 2000,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                    shape: RoundedRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _image == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Image.file(
                              _image,
                              width: 300,
                              height: 500,
                            ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (s) {
                      text = s;
                    },
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                        hintText: getLang(context, 'Write something...'),
                        focusColor: Colors.white,
                        hoverColor: whiteColor,
                        border: OutlineInputBorder(),
                        fillColor: Colors.white),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  child: FlatButton(
                      onPressed: onPressReset,
                      color: Colors.redAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            getLang(context, 're-take'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          alignment: Alignment.center,
          height: 60,
          color: primaryColor,
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            onPressed: onPressRecordOrder,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      getLang(context, 'add_to_cart'),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<void> onPressRecordOrder() async {

    CoolAlert.show(
        context: context,
        barrierDismissible: false,
        lottieAsset: 'assets/lottie/plan.json',
        type: CoolAlertType.loading,
        title: getLang(context, "Uploading.."));

    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;
    await CartRepository()
        .getCartAddVoiceRecordResponse(
            filename: fileName,
            image: base64Image,
            user_id: user_id.value,
            description: text,
            owner_user_id: AppConfig.PIC_ORDER_ID,
            order_type: 'picture')
        .then((value) {
      if (value.result) {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: value.message,
            backgroundColor: Colors.green,
          ),
          displayDuration: Duration(seconds: 2),
        );
        Provider.of<CartProvider>(context,listen: false).sendUpdateRequest=true;
        Navigator.of(context)..pop()..pop();
      } else {
        Navigator.of(context)..pop();
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: value.message,
          ),
          displayDuration: Duration(seconds: 2),
        );
      }
    });
  }

  onPressTack() async {}

  onPressReset() {
    getImage();
  }
}
