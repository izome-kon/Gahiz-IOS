import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Profile/profile_image_update_response.dart';
import 'package:denta_needs/Responses/Profile/profile_update_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProfileRepository {
  Future<ProfileUpdateResponse> getProfileUpdateResponse(
      @required String name, @required String password, phone) async {
    var post_body = jsonEncode({
      "id": "${user_id.value}",
      "name": name,
      "password": "$password",
      "phone": phone
    });

    final response = await http.post("${AppConfig.BASE_URL}/profile/update",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);

    //print(response.body.toString());
    return profileUpdateResponseFromJson(response.body);
  }

  Future<ProfileUpdateResponse> getDeviceTokenUpdateResponse(token) async {
    var post_body = jsonEncode({
      "id": "${user_id.value}",
      "device_token": token,
    });

    final response = await http.post("${AppConfig.BASE_URL}/profile/update-device-token",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);

    //print(response.body.toString());
    return profileUpdateResponseFromJson(response.body);
  }

  Future<ProfileImageUpdateResponse> getProfileImageUpdateResponse(
      @required String image, @required String filename) async {
    var post_body = jsonEncode({
      "id": "${user_id.value}",
      "image": "${image}",
      "filename": "$filename"
    });
    //print(post_body.toString());

    final response =
        await http.post("${AppConfig.BASE_URL}/profile/update-image",
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${access_token.value}"
            },
            body: post_body);

    //print(response.body.toString());
    return profileImageUpdateResponseFromJson(response.body);
  }
}
