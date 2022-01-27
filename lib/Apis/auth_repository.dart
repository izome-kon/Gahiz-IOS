import 'dart:io';

import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Responses/Auth/confirm_code_response.dart';
import 'package:denta_needs/Responses/Auth/login_response.dart';
import 'package:denta_needs/Responses/Auth/logout_response.dart';
import 'package:denta_needs/Responses/Auth/password_confirm_response.dart';
import 'package:denta_needs/Responses/Auth/resend_code_response.dart';
import 'package:denta_needs/Responses/Auth/user_by_token.dart';
import 'package:denta_needs/Responses/Signup/signupResponse.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthRepository {
  var _codeController;

  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    String platform = Platform.isAndroid
        ? 'Android'
        : Platform.isIOS
            ? 'IOS'
            : 'Other';
    var post_body = jsonEncode({
      "phone": "$email",
      "password": "$password",
      "platform": "$platform"
    });

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: post_body);
    print('${response.body}');
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/auth/logout"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
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

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      @required int user_id, @required String verify_by) async {
    var post_body =
        jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/resend_code"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      @required int user_id, @required String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String phone, @required String password) async {
    var post_body = jsonEncode({"phone": "$phone", "password": "$password"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/password/confirm_reset"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token"),
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }
}
