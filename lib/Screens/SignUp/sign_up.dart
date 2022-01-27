import 'dart:async';

import 'package:denta_needs/Apis/authApi.dart';
import 'package:denta_needs/Apis/profile_repositories.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/auth_helper.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Provider/register_provider.dart';
import 'package:denta_needs/Responses/Auth/login_response.dart';
import 'package:denta_needs/Screens/Address/add_address.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Screens/SignUp/OTPForm.dart';
import 'package:denta_needs/Screens/SignUp/doctor_info.dart';
import 'package:denta_needs/Screens/SignUp/user_info.dart' as userInfo;
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/Screens/map.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:provider/provider.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class SignUp extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  userInfo.AccountType accountType;
  PageController pageController;
  int curPage;
  final SweetSheet _sweetSheet = SweetSheet();
  bool loading = false;
  AuthApi authApi = new AuthApi();
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  LoginResponse _loginResponse;

  @override
  void initState() {
    Global.newAccountType = userInfo.AccountType.DOCTOR;
    curPage = 0;
    pageController = new PageController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Image.asset(
          'assets/images/pattern2.png',
          fit: BoxFit.cover,
          width: 2000,
        ),
        Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo_login',
                    child: Logo(
                      LogoType.DARK,
                      enableTitle: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 15),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height -
                                  (curPage == 0 ? 320 : 250),
                              child: PageView(
                                controller: pageController,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  currentState ==
                                          MobileVerificationState
                                              .SHOW_OTP_FORM_STATE
                                      ? OTPForm()
                                      : userInfo.UserInfo(),
                                  DoctorInfo(),
                                ],
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width - 55,
                            child: Column(
                              children: [
                                Consumer<RegisterProvider>(
                                  builder: (context, value, child) =>
                                      currentState ==
                                              MobileVerificationState
                                                  .SHOW_OTP_FORM_STATE
                                          ? FlatButton(
                                              disabledColor:
                                                  primaryColor.withOpacity(0.2),
                                              onPressed: loading
                                                  ? null
                                                  : () {
                                                      onClickSubmitOtp(
                                                          _loginResponse);
                                                    },
                                              height: 50,
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: loading
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          getLang(context,
                                                              "Submit"),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                              color: primaryColor,
                                            )
                                          : FlatButton(
                                              disabledColor:
                                                  primaryColor.withOpacity(0.2),
                                              onPressed: loading
                                                  ? null
                                                  : () {
                                                      onClickNext(value);
                                                    },
                                              height: 50,
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: loading
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          getLang(
                                                              context, 'next'),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: whiteColor,
                                                          size: 15,
                                                        )
                                                      ],
                                                    ),
                                              color: primaryColor,
                                            ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  height: 50,
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    getLang(context, 'have_account'),
                                    style: TextStyle(
                                        fontSize: 12, color: fontColor),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> onClickNext(RegisterProvider value) async {
    if (value.newAccountType != null) {
      if (value.formKey.currentState.validate()) {
        setState(() {
          loading = true;
        });
        print(value.countryCode + int.parse(value.phone).toString());
        await _auth.verifyPhoneNumber(
          phoneNumber: value.countryCode + int.parse(value.phone).toString(),
          verificationCompleted: (phoneAuthCredential) async {
            setState(() {
              loading = false;
            });
            //signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          timeout: Duration(seconds: value.timeOutAfter),
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
            print(verificationFailed.message);
          },
          codeSent: (verificationId, resendingToken) async {
            value.setTimeOut = 30;
            value.startTimer();
            setState(() {
              loading = false;
              currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
              value.verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (verificationId) async {
            print('time out');
          },
        );
      }
    }
  }

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential,
      RegisterProvider registerProvider) async {
    setState(() {
      loading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        loading = false;
      });

      if (authCredential.user != null) {
        authApi
            .getSignupResponse(
          name: registerProvider.FName + " " + registerProvider.LName,
          emailOrPhone: registerProvider.countryCode +
              int.parse(registerProvider.phone).toString(),
          password: registerProvider.password,
          passwordConfirmation: registerProvider.password,
          userType: registerProvider.newAccountType,
        )
            .then((loginResponse) async {
          if (loginResponse.result) {
            print(loginResponse.result);
            AuthHelper().setUserData(loginResponse);
            FreshchatUser freshchatUser = await Freshchat.getUser;
            freshchatUser.setFirstName(loginResponse.user.name);
            freshchatUser.setPhone(
                registerProvider.countryCode,
                loginResponse.user.phone
                    .substring(3, loginResponse.user.phone.length));
            Freshchat.setUser(freshchatUser);
            showTopSnackBar(
              context,
              CustomSnackBar.success(
                message: getLang(context, "Welcome") +
                    " ${loginResponse.user.name} !",
                backgroundColor: Colors.green,
              ),
              displayDuration: Duration(seconds: 1),
            );
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) => Main(),
            //   ),
            //   (Route<dynamic> route) => false,
            // );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => UserLocation(
                  isNew: true,
                  addAddressType: AddAddressType.FROM_SIGN_UP,
                ),
              ),
              (Route<dynamic> route) => false,
            );
            FirebaseMessaging.instance.getToken().then((value) {
              ProfileRepository().getDeviceTokenUpdateResponse(value);
            });
          } else {
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: loginResponse.message,
              ),
              displayDuration: Duration(seconds: 1),
            );
            setState(() {
              loading = false;
            });
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
        displayDuration: Duration(seconds: 1),
      );
      print(e.message);
    }
  }

  void onClickSubmitOtp(v) {
    RegisterProvider prov =
        Provider.of<RegisterProvider>(context, listen: false);
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: prov.verificationId, smsCode: prov.otpController);
    signInWithPhoneAuthCredential(phoneAuthCredential, prov);
  }
}
