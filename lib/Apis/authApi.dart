import 'dart:convert';

import 'package:denta_needs/Responses/Auth/login_response.dart';
import 'package:denta_needs/Responses/Signup/signupResponse.dart';
import 'package:denta_needs/app_config.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  Future<LoginResponse> getSignupResponse(
      {@required String name,
      @required String emailOrPhone,
      @required String password,
      @required String passwordConfirmation,
      @required String userType = "doctor",
      String register_by = "phone"}) async {
    var postBody = jsonEncode({
      "name": "$name",
      "phone": "$emailOrPhone",
      "password": "$password",
      "password_confirmation": "$passwordConfirmation",
      "register_by": "$register_by",
      "user_type": userType,
    });

    final response = await http.post("${AppConfig.BASE_URL}/auth/signup",
        headers: {"Content-Type": "application/json"}, body: postBody);

    return loginResponseFromJson(response.body);
  }
}
