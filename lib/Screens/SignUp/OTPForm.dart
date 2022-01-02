import 'package:denta_needs/Apis/authApi.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Helper/valedator.dart';
import 'package:denta_needs/Provider/register_provider.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Screens/SignUp/user_info.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OTPForm extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<OTPForm> {
  AccountType type;

  /// Signup button is loading
  bool loading = false;

  /// Used for increase time for resend otp message
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
      child: Consumer<RegisterProvider>(
        builder: (context, value, child) => Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/otp.json',
                      width: 200, height: 200),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      getLang(context,
                          'We have sent a 6-digit code to verify your mobile number'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: fontColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getLang(context, 'Please enter OTP Code'),
                style: TextStyle(
                    fontSize: 18,
                    color: fontColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                autoFocus: true,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  inactiveFillColor: Colors.blue.shade50,
                  inactiveColor: Colors.blue.shade100,
                  selectedFillColor: Colors.white,
                  selectedColor: Colors.blue.shade50,
                  fieldWidth: 40,
                  activeColor: Colors.blue.shade50,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                onChanged: (v) {
                  value.otpController = v;
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  loading
                      ? Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            backgroundColor: primaryColor,
                            color: Colors.white,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            if (value.timeOutAfter * count == 0) {
                              onClickResend(value);
                            }
                          },
                          child: Text(
                            value.timeOutAfter == 0
                                ? getLang(context, 'Resend Code')
                                : getLang(context, "Resend Code After") +
                                    ' ( ${value.timeOutAfter} )',
                            style: TextStyle(
                                color: value.timeOutAfter == 0
                                    ? primaryColor
                                    : fontColor.withOpacity(0.5)),
                          )),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// on click resend  otp message
  Future<void> onClickResend(RegisterProvider value) async {
    if (count < 2) count++;

    /// get instance from firebaseAuth
    var _auth = FirebaseAuth.instance;

    /// Set time for available resend otp button
    value.setTimeOut = 30 * count;

    /// Verify user  phone number
    await _auth.verifyPhoneNumber(
      /// use [int.parse()] fun for remove first digit if it is '0'
      phoneNumber: value.countryCode + int.parse(value.phone).toString(),
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          loading = false;
        });
      },
      timeout: Duration(seconds: value.timeOutAfter * count),
      verificationFailed: (verificationFailed) async {
        setState(() {
          loading = false;
        });
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: verificationFailed.message,
          ),
          displayDuration: Duration(seconds: 1),
        );
      },
      codeSent: (verificationId, resendingToken) async {
        value.startTimer();
        setState(() {
          loading = false;
          value.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }
}
