import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/Auth/confirm_code_response.dart';
import 'package:denta_needs/Responses/Auth/login_response.dart';
import 'package:denta_needs/Responses/Auth/logout_response.dart';
import 'package:denta_needs/Responses/Auth/password_confirm_response.dart';
import 'package:denta_needs/Responses/Auth/password_forget_response.dart';
import 'package:denta_needs/Responses/Auth/resend_code_response.dart';
import 'package:denta_needs/Responses/Auth/user_by_token.dart';
import 'package:denta_needs/Responses/Signup/signupResponse.dart';
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthRepository {
  var _codeController;

  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    var post_body = jsonEncode({"phone": "${email}", "password": "$password"});

    final response = await http.post("${AppConfig.BASE_URL}/auth/login",
        headers: {"Content-Type": "application/json"}, body: post_body);
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/auth/logout",
      headers: {"Authorization": "Bearer ${access_token.value}"},
    );

    print(response.body);

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
      @required String name,
      @required String email_or_phone,
      @required String password,
      @required String passowrd_confirmation,
      @required String register_by) async {
    var post_body = jsonEncode({
      "name": "$name",
      "email_or_phone": "${email_or_phone}",
      "password": "$password",
      "password_confirmation": "${passowrd_confirmation}",
      "register_by": "$register_by"
    });

    final response = await http.post("${AppConfig.BASE_URL}/auth/signup",
        headers: {"Content-Type": "application/json"}, body: post_body);

    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      @required int user_id, @required String verify_by) async {
    var post_body =
        jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});

    final response = await http.post("${AppConfig.BASE_URL}/auth/resend_code",
        headers: {"Content-Type": "application/json"}, body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      @required int user_id, @required String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});

    final response = await http.post("${AppConfig.BASE_URL}/auth/confirm_code",
        headers: {"Content-Type": "application/json"}, body: post_body);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String phone, @required String password) async {
    var post_body = jsonEncode(
        {"phone": "$phone", "password": "$password"});

    final response = await http.post(
        "${AppConfig.BASE_URL}/auth/password/confirm_reset",
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    final response = await http.post(
        "${AppConfig.BASE_URL}/auth/password/resend_code",
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.value}"});

    final response = await http.post(
        "${AppConfig.BASE_URL}/get-user-by-access_token",
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }

  // Future<bool> loginUser(String phone, BuildContext context) async {
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   _auth.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       timeout: Duration(seconds: 60),
  //       verificationCompleted: (user) async {
  //         if (user != null) {
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => Main()));
  //         } else {
  //           print("Error");
  //         }
  //
  //         //This callback would gets called when verification is done auto maticlly
  //       },
  //       verificationFailed: (AuthException exception) {
  //         print(exception);
  //       },
  //       codeSent: (String verificationId, [int forceResendingToken]) {
  //         showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (context) {
  //               return AlertDialog(
  //                 title: Text("Give the code?"),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     TextField(
  //                       controller: _codeController,
  //                     ),
  //                   ],
  //                 ),
  //                 actions: <Widget>[
  //                   // FlatButton(
  //                   //   child: Text("Confirm"),
  //                   //   textColor: Colors.white,
  //                   //   color: Colors.blue,
  //                   //   onPressed: () async {
  //                   //     final code = _codeController.text.trim();
  //                   //     AuthCredential credential =
  //                   //         PhoneAuthProvider.getCredential(
  //                   //             verificationId: verificationId, smsCode: code);
  //
  //                   //     AuthResult result =
  //                   //         await _auth.signInWithCredential(credential);
  //
  //                   //     FirebaseUser user = result.user;
  //
  //                   //     if (user != null) {
  //                   //       Navigator.push(
  //                   //           context,
  //                   //           MaterialPageRoute(
  //                   //               builder: (context) => HomeScreen(
  //                   //                     user: user,
  //                   //                   )));
  //                   //     } else {
  //                   //       print("Error");
  //                   //     }
  //                   //   },
  //                   // )
  //                 ],
  //               );
  //             });
  //       },
  //       codeAutoRetrievalTimeout: null);
  // }
}
