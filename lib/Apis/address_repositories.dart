import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Address/address_add_response.dart';
import 'package:denta_needs/Responses/Address/address_delete_response.dart';
import 'package:denta_needs/Responses/Address/address_make_default_response.dart';
import 'package:denta_needs/Responses/Address/address_response.dart';
import 'package:denta_needs/Responses/Address/address_update_in_cart_response.dart';
import 'package:denta_needs/Responses/Address/address_update_response.dart';
import 'package:denta_needs/Responses/Address/shipping_cost_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AddressRepository {
  Future<List<Address>> getAddressList() async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/user/shipping/address/${user_id.value}",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.value}"
      },
    );
    return addressFromJson(response.body);
  }

  Future<AddressAddResponse> getAddressAddResponse(
      {String address,
      String country,
      String city,
      String postal_code,
      String phone,
      String clinic,
      String branch,
      latitude,
      longitude}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.value}",
      "address": "$address",
      "country": "$country",
      "city": "$city",
      "postal_code": "$postal_code",
      "phone": "$phone",
      "clinic_name": "$clinic",
      'latitude': '$latitude',
      'longitude': '$longitude',
      "branch_name": "$branch",
    });
    final response =
        await http.post("${AppConfig.BASE_URL}/user/shipping/create",
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${access_token.value}"
            },
            body: post_body);

    return addressAddResponseFromJson(response.body);
  }

  Future<AddressUpdateResponse> getAddressUpdateResponse(
      {int id,
      String address,
      String country,
      String city,
      String postal_code,
      String phone,
      String clinic,
      String branch,
      latitude,
      longitude}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.value}",
      "address": "$address",
      "country": "$country",
      "city": "$city",
      "postal_code": "$postal_code",
      "phone": "$phone",
      "clinic_name": "$clinic",
      'latitude': '$latitude',
      'longitude': '$longitude',
      "branch_name": "$branch",
    });
    final response =
        await http.post("${AppConfig.BASE_URL}/user/shipping/update",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.value}"
            },
            body: post_body);
print(response.body);
    return addressUpdateResponseFromJson(response.body);
  }

  Future<AddressMakeDefaultResponse> getAddressMakeDefaultResponse(
    @required int id,
  ) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.value}",
      "id": "$id",
    });
    final response =
        await http.post("${AppConfig.BASE_URL}/user/shipping/make_default",
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${access_token.value}"
            },
            body: post_body);

    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<AddressDeleteResponse> getAddressDeleteResponse(
    @required int id,
  ) async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/user/shipping/delete/$id",
      headers: {
        "Authorization": "Bearer ${access_token.value}"
      },
    );

    return addressDeleteResponseFromJson(response.body);
  }

  // Future<CityResponse> getCityList() async {
  //   final response = await http.get("${AppConfig.BASE_URL}/cities");
  //
  //   return cityResponseFromJson(response.body);
  // }
  //
  // Future<CountryResponse> getCountryList() async {
  //   final response = await http.get("${AppConfig.BASE_URL}/countries");
  //   return countryResponseFromJson(response.body);
  // }

  Future<ShippingCostResponse> getShippingCostResponse(@required int owner_id,
      @required int user_ID, @required String city_name) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "$user_ID",
      "city_name": "$city_name"
    });
    final response = await http.post("${AppConfig.BASE_URL}/shipping_cost",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user_id.value}"
        },
        body: post_body);

    return shippingCostResponseFromJson(response.body);
  }

  Future<AddressUpdateInCartResponse> getAddressUpdateInCartResponse(
    @required int address_id,
  ) async {
    var post_body = jsonEncode({
      "address_id": "${address_id}",
      "user_id": "${user_id.value}"
    });
    final response =
        await http.post("${AppConfig.BASE_URL}/update-address-in-cart",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.value}"
            },
            body: post_body);

    return addressUpdateInCartResponseFromJson(response.body);
  }
}
