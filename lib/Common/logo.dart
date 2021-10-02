import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

enum LogoType { LIGHT, DARK }

class Logo extends StatelessWidget {
  final LogoType _logoType;
  double size;
  double fontSize;
  bool enableTitle;

  Logo(this._logoType,
      {this.size = 100, this.fontSize = 20, this.enableTitle = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _logoType == LogoType.DARK
            ? Shimmer(
                child: Image.asset(
                  _logoType == LogoType.LIGHT
                      ? 'assets/logo.png'
                      : 'assets/logo-light.png',
                  width: size,
                ),
              )
            : CircleAvatar(
                radius: size - 20,
                backgroundColor: primaryColor,
                child: Image.asset(
                  _logoType == LogoType.LIGHT
                      ? 'assets/logo.png'
                      : 'assets/logo-light.png',
                  width: size,
                ),
              ),
        SizedBox(
          height: 10,
        ),
        enableTitle
            ? Text(
                'جاهز',
                style: TextStyle(
                    color:
                        _logoType == LogoType.LIGHT ? accentColor : accentColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold),
              )
            : Container()
      ],
    );
  }
}
