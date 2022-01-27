import 'package:avatar_glow/avatar_glow.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/Screens/Category/category_page.dart';
import 'package:denta_needs/Screens/OrderFeatchers/record_order.dart';
import 'package:denta_needs/Screens/OrderFeatchers/tack_photo.dart';
import 'package:denta_needs/Screens/OrderFeatchers/take_by_text.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import '../../app_config.dart';

enum OrderFeacherType { VOICE, TYPING, PHOTO }

class OrderFeacherButton extends StatefulWidget {
  final OrderFeacherType buttonType;
  final Duration duration;
  OrderFeacherButton({
    @required this.buttonType,
    this.duration,
  });

  @override
  _OrderFeacherButtonState createState() => _OrderFeacherButtonState();
}

class _OrderFeacherButtonState extends State<OrderFeacherButton> {
  bool toolTipShow = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handelOnTab,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
            endRadius: 50,
            glowColor: Colors.blue,
            showTwoGlows: true,
            startDelay: widget.duration,
            child: Container(
              width: 90,
              height: 90,
              padding: EdgeInsets.all(4),
              child: SimpleTooltip(
                animationDuration: Duration(milliseconds: 200),
                show: toolTipShow,
                borderWidth: 0,
                arrowLength: 5,
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
                                    builder: (_) => TackPhotoScreen(
                                          imageSource: ImageSource.gallery,
                                        )));
                          },
                          color: primaryColor,
                          child: Text(
                            getLang(context, 'From gallery'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TackPhotoScreen(
                                          imageSource: ImageSource.camera,
                                        )));
                          },
                          color: primaryColor,
                          child: Text(
                            getLang(context, 'Open Camera'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(500)),
                      color: whiteColor,
                      border: Border.all(
                        width: 2,
                        color: primaryColor,
                      )),
                  child: Center(
                    child: Lottie.asset(
                      handelImage(),
                      repeat: false,
                      width: 60,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            handelText(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void handelOnTab() {
    switch (widget.buttonType) {
      case OrderFeacherType.PHOTO:
        setState(() {
          toolTipShow = !toolTipShow;
        });
        break;
      case OrderFeacherType.TYPING:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => TackTextScreen()));
        break;
      case OrderFeacherType.VOICE:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => RecordOrderScreen()));
        break;
    }
  }

  String handelImage() {
    switch (widget.buttonType) {
      case OrderFeacherType.PHOTO:
        return 'assets/lottie/tack_pic.json';
        break;
      case OrderFeacherType.TYPING:
        return 'assets/lottie/write_order.json';
        break;
      case OrderFeacherType.VOICE:
        return 'assets/lottie/voice.json';
        break;
      default:
        return '';
    }
  }

  String handelText() {
    switch (widget.buttonType) {
      case OrderFeacherType.PHOTO:
        return getLang(context, 'pic Order');
        break;
      case OrderFeacherType.TYPING:
        return getLang(context, 'write Order');
        break;
      case OrderFeacherType.VOICE:
        return getLang(context, 'Record Order');
        break;
      default:
        return '';
    }
  }
}
