// import 'package:connectivity/connectivity.dart';
import 'package:denta_needs/Apis/authApi.dart';
import 'package:denta_needs/Apis/auth_repository.dart';
import 'package:denta_needs/Apis/profile_repositories.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/auth_helper.dart';
import 'package:denta_needs/Helper/valedator.dart';
import 'package:denta_needs/Provider/register_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Screens/SignUp/OTPForm.dart';
import 'package:denta_needs/Screens/SignUp/sign_up.dart';
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone = "";
  String password = "";
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool showResetPasswordForm = false;
  bool codeConfirmed = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/pattern2.png',
            fit: BoxFit.cover,
            width: 2000,
          ),
          Center(
            child: SingleChildScrollView(
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
                  currentState == MobileVerificationState.SHOW_OTP_FORM_STATE
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                              child: codeConfirmed
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Form(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(getLang(
                                              context, 'Enter new password')),
                                          TextFormField(
                                            onChanged: (s) {
                                              password = s;
                                            },
                                            validator: (s) {
                                              return Validator.password(
                                                  context, s);
                                            },
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: getLang(
                                                    context, 'password'),
                                                hintText: getLang(
                                                    context, 'enter_password'),
                                                suffixIcon: Icon(Icons.lock)),
                                          )
                                        ],
                                      )),
                                    )
                                  : OTPForm()),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  showResetPasswordForm
                                      ? Text(
                                          getLang(context, 'Password Reset'),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: fontColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          getLang(context, 'login'),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: fontColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            return Validator.password(
                                                context, value);
                                          },
                                          onChanged: (s) {
                                            phone = s;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: getLang(
                                                  context, 'phone_number'),
                                              hintText: getLang(
                                                  context, 'enter_your_phone'),
                                              prefix: Text(
                                                '+20 ',
                                                style:
                                                    TextStyle(color: fontColor),
                                              ),
                                              suffixIcon:
                                                  Icon(Icons.phone_android)),
                                        ),
                                        showResetPasswordForm
                                            ? Container()
                                            : TextFormField(
                                                onChanged: (s) {
                                                  password = s;
                                                },
                                                validator: (s) {
                                                  return Validator.password(
                                                      context, s);
                                                },
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    border:
                                                        UnderlineInputBorder(),
                                                    labelText: getLang(
                                                        context, 'password'),
                                                    hintText: getLang(context,
                                                        'enter_password'),
                                                    suffixIcon:
                                                        Icon(Icons.lock)),
                                              ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        showResetPasswordForm
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        showResetPasswordForm =
                                                            true;
                                                      });
                                                    },
                                                    child: Text(
                                                      getLang(context,
                                                          'Forget Password?'),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: fontColor
                                                              .withOpacity(
                                                                  0.6)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        showResetPasswordForm
                                            ? Consumer<UserProvider>(builder:
                                                (context, value, child) {
                                                return FlatButton(
                                                  onPressed: onResetPassword,
                                                  height: 50,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: loading
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        )
                                                      : Text(
                                                          getLang(context,
                                                              'Password Reset'),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                  color: primaryColor,
                                                );
                                              })
                                            : Consumer<UserProvider>(builder:
                                                (context, value, child) {
                                                return FlatButton(
                                                  onPressed: onLoginPressed,
                                                  height: 50,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: loading
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        )
                                                      : Text(
                                                          getLang(
                                                              context, 'login'),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                  color: primaryColor,
                                                );
                                              }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  showResetPasswordForm
                                      ? MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showResetPasswordForm = false;
                                            });
                                          },
                                          height: 50,
                                          shape: Border.all(
                                              color:
                                                  fontColor.withOpacity(0.2)),
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            getLang(context, 'login'),
                                            style: TextStyle(
                                                fontSize: 15, color: fontColor),
                                          ),
                                        )
                                      : MaterialButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        SignUp(),
                                              ),
                                            );
                                          },
                                          height: 50,
                                          shape: Border.all(
                                              color:
                                                  fontColor.withOpacity(0.2)),
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            getLang(context, 'new_regester'),
                                            style: TextStyle(
                                                fontSize: 15, color: fontColor),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  currentState == MobileVerificationState.SHOW_OTP_FORM_STATE
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                          child: FlatButton(
                            onPressed: onSubmitClick,
                            height: 50,
                            minWidth: MediaQuery.of(context).size.width,
                            child: loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Text(
                                    getLang(context, 'Submit'),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                            color: primaryColor,
                          ),
                        )
                      : Container(),
                  SizedBox(height: 5,),
                  currentState == MobileVerificationState.SHOW_OTP_FORM_STATE
                      ?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                    child: MaterialButton(
                      color: Colors.white,
                      elevation: 0,
                      onPressed: () {
                        setState(() {
                          showResetPasswordForm = false;
                          currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
                          codeConfirmed = false;
                          phone = '';
                          phoneInt = 0;
                          password ='';
                        });
                      },
                      height: 50,
                      shape: Border.all(
                          color:
                          fontColor.withOpacity(0.2)),
                      minWidth:
                      MediaQuery.of(context).size.width,
                      child: Text(
                        getLang(context, 'login'),
                        style: TextStyle(
                            fontSize: 15, color: fontColor),
                      ),
                    ),
                  ):Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void onLoginPressed() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState.validate()) {
      loading = true;
      setState(() {});
      int phoneInt = int.parse(phone);

      AuthRepository()
          .getLoginResponse('+20${phoneInt.toString()}', password)
          .then((v) async {
        print(v.result);
        if (v.result) {
          //authed
          AuthHelper().setUserData(v);
          FreshchatUser freshchatUser = await Freshchat.getUser;
          freshchatUser.setFirstName(v.user.name);
          freshchatUser.setPhone(
              '+20', v.user.phone.substring(3, v.user.phone.length));
          Freshchat.setUser(freshchatUser);
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: getLang(context, 'Welcome') + " ${v.user.name} !",
              backgroundColor: Colors.green,
            ),
            displayDuration: Duration(seconds: 1),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Main(),
            ),
            (Route<dynamic> route) => false,
          );
          FirebaseMessaging.instance.getToken().then((value) {
            ProfileRepository().getDeviceTokenUpdateResponse(value);
          });
        } else {
          //wrong
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: getLang(context, 'Invalid phone or password'),
            ),
            displayDuration: Duration(seconds: 1),
          );
        }
        loading = false;
        setState(() {});
      });
    }
  }

  int phoneInt;

  Future<void> onResetPassword() async {
    if(phone==''||phone==null) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: getLang(context, 'required'),
        ),
        displayDuration: Duration(seconds: 2),
      );
      
      return;
    }
    var value = Provider.of<RegisterProvider>(context, listen: false);
    setState(() {
      loading = true;
    });
    phoneInt = int.parse(phone);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+20' + phoneInt.toString(),
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

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, registerProvider) async {
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
        setState(() {
          codeConfirmed = true;
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

  void onSubmitClick() {
    print('+20' + phoneInt.toString());
    if (codeConfirmed) {
      setState(() {
        loading = true;
      });
      AuthRepository()
          .getPasswordConfirmResponse('+20' + phoneInt.toString(), password)
          .then((value) {
        if (value.result) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: value.message,
              backgroundColor: Colors.green,
            ),
            displayDuration: Duration(seconds: 3),
          );
          setState(() {
            showResetPasswordForm = false;
            currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
            codeConfirmed = false;
            phone = '';
            phoneInt = 0;
            password ='';
            loading = false;
          });
        } else {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: value.message,
            ),
            displayDuration: Duration(seconds: 2),
          );
          setState(() {
            loading = false;
          });
        }
      });
    } else {
      onClickSubmitOtp();
    }
  }

  void onClickSubmitOtp() {
    RegisterProvider prov =
        Provider.of<RegisterProvider>(context, listen: false);
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: prov.verificationId, smsCode: prov.otpController);
    signInWithPhoneAuthCredential(phoneAuthCredential, prov);
  }
}
