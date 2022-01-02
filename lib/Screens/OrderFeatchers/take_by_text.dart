import 'dart:async';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
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
import 'package:record/record.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TackTextScreen extends StatefulWidget {
  const TackTextScreen({Key key}) : super(key: key);

  @override
  _RecordOrderScreenState createState() => _RecordOrderScreenState();
}

enum TackPhotoScreenState { TACK, VIEW }

class _RecordOrderScreenState extends State<TackTextScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String text = '';

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
          getLang(context, 'write Order'),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    minLines: 3,
                    maxLines: 6,
                    onChanged: (s) {
                      setState(() {
                        text = s;
                      });
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: getLang(context, 'Write here...'),
                        focusColor: Colors.white,
                        hoverColor: whiteColor,
                        border: OutlineInputBorder(),
                        fillColor: Colors.white),
                  ),
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
          color: text.isEmpty ? Colors.grey : primaryColor,
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            onPressed: () async {
              if (text.isNotEmpty) {
                CoolAlert.show(
                    context: context,
                    barrierDismissible: false,
                    lottieAsset: 'assets/lottie/plan.json',
                    type: CoolAlertType.loading,
                    title: getLang(context, "Uploading.."));
                await CartRepository()
                    .getCartAddVoiceRecordResponse(
                        filename: null,
                        image: null,
                        user_id: user_id.$,
                        description: text,
                        owner_user_id: AppConfig.TEXT_ORDER_ID,
                        order_type: 'Text')
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
            },
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
}
