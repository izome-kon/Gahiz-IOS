import 'dart:io';

import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Models/user_model.dart';
import 'package:denta_needs/Screens/SignUp/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Global {
  static LatLng address;
  static UserModel newAccountTemp;
  static AccountType newAccountType;

  static DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  static Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 50,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }


}
