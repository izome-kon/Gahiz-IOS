 
import 'dart:convert';

List<Address> addressFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(List<Address> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Address {
  Address({
    this.id,
    this.clinicName,
    this.branchName,
    this.userId,
    this.address,
    this.country,
    this.city,
    this.longitude,
    this.latitude,
    this.postalCode,
    this.phone,
    this.setDefault,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String clinicName;
  String branchName;
  int userId;
  String address;
  String country;
  String city;
  double longitude;
  double latitude;
  String postalCode;
  String phone;
  int setDefault;
  DateTime createdAt;
  DateTime updatedAt;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    clinicName: json["clinic_name"],
    branchName: json["branch_name"],
    userId: json["user_id"],
    address: json["address"],
    country: json["country"],
    city: json["city"],
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    postalCode: json["postal_code"],
    phone: json["phone"],
    setDefault: json["set_default"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clinic_name": clinicName,
    "branch_name": branchName,
    "user_id": userId,
    "address": address,
    "country": country,
    "city": city,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
    "postal_code": postalCode,
    "phone": phone,
    "set_default": setDefault,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
