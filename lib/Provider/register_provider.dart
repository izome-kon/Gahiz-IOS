import 'dart:async';

import 'package:flutter/cupertino.dart';

class RegisterProvider extends ChangeNotifier {
  String FName;
  String LName;
  String phone;
  String password;
  String otpCode;
  String newAccountType = 'doctor';
  String otpController;
  Timer time;
  int timeOutAfter = 30;
  String verificationId;
  String resendingToken;
  String countryCode = '+20';

  set setTimeOut(int setTimeOut) {
    timeOutAfter = setTimeOut;
    notifyListeners();
  }

  startTimer() {
    time = Timer.periodic(Duration(seconds: 1), (timer) {
      timeOutAfter--;
      if (timeOutAfter == 0) timer.cancel();

      notifyListeners();
    });
  }

  var formKey = GlobalKey<FormState>();

  get getFName => FName;
  get getLame => LName;

  get getPhone => phone;

  get getPassword => password;

  get getNewAccountType => newAccountType;

  set setFName(n) {
    FName = n;
    notifyListeners();
  }

  set setLName(n) {
    LName = n;
    notifyListeners();
  }

  set setPhone(n) {
    phone = n;
    notifyListeners();
  }

  set setPassword(n) {
    password = n;
    notifyListeners();
  }

  set setOtpCode(n) {
    otpCode = n;
    notifyListeners();
  }

  set setNewAccountType(n) {
    newAccountType = n;

    notifyListeners();
  }
}
