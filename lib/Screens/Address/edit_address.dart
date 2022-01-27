import 'package:denta_needs/Apis/address_repositories.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Helper/valedator.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Address/address_response.dart';
import 'package:denta_needs/Screens/SignUp/doctor_info.dart';
import 'package:denta_needs/Screens/map.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditAddress extends StatefulWidget {
  final Address address;

  EditAddress({this.address});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<EditAddress> {
  var clinicName;
  var branchName;
  var city;
  var addressText;
  var addressArea;
  var addressString;

  Address _address;
  final _formKey = GlobalKey<FormState>();
  GoogleMapController mapController;
  bool loading = false;

  @override
  void initState() {
    _address = widget.address;
    clinicName = TextEditingController(text: _address.clinicName);
    branchName = TextEditingController(text: _address.branchName);
    city = TextEditingController(text: _address.city);
    addressText = TextEditingController(text: _address.address);
    addressArea = TextEditingController(text: _address.country);
    getData();
    super.initState();
  }

  getData() async {
    await placemarkFromCoordinates(_address.latitude, _address.longitude)
        .then((value) {
      if (value.length != 0) {
        addressString = value.first.name +
            ' ' +
            value.first.thoroughfare +
            ' ' +
            value.first.locality;
        setState(() {});
      }
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          getLang(context, "Edit clinic"),
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                child: InkWell(
                  onTap: goToMapPage,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GoogleMap(
                          onMapCreated: onMapCreated,
                          onTap: (l) {
                            goToMapPage();
                          },
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: _address.latitude != null
                                  ? LatLng(
                                      _address.latitude, _address.longitude)
                                  : LatLng(30.033333, 31.233334),
                              zoom: 18.0),
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          rotateGesturesEnabled: false,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                      Align(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/dental-location.png',
                            width: 45,
                            height: 45,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: primaryColor, width: 0.3),
                                color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Text(addressString != null
                                  ? addressString
                                  : getLang(context,
                                      'Touch the map to change the location')),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: accentColor,
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          color: whiteColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          getLang(context, 'clinic_info'),
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: clinicName,
                              validator: (v) => Validator.password(context, v),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: getLang(context, 'clinic_name'),
                                hintText: getLang(context, 'enter_clinic_name'),
                              ),
                            ),
                            TextFormField(
                              controller: branchName,
                              validator: (v) => Validator.password(context, v),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: getLang(context, 'branch_name'),
                                hintText: getLang(context, 'enter_branch_name'),
                              ),
                            ),
                            TextFormField(
                              controller: city,
                              validator: (v) => Validator.password(context, v),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: getLang(context, 'city'),
                                hintText: getLang(context, 'enter_city'),
                              ),
                            ),
                            TextFormField(
                              validator: (v) => Validator.password(context, v),
                              keyboardType: TextInputType.text,
                              controller: addressArea,
                              enabled: false,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: getLang(context, 'area'),
                                hintText: getLang(context, 'enter_area'),
                              ),
                            ),
                            TextFormField(
                              controller: addressText,
                              validator: (v) => Validator.password(context, v),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: getLang(context, 'address'),
                                hintText: getLang(context, 'enter_address'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FlatButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  AddressRepository()
                                      .getAddressUpdateResponse(
                                          address: addressText.text,
                                          branch: branchName.text,
                                          id: _address.id,
                                          city: city.text,
                                          clinic: clinicName.text,
                                          country: addressArea.text,
                                          longitude: _address.longitude,
                                          latitude: _address.latitude)
                                      .then((value) {
                                    if (value.result) {
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.success(
                                          message: value.message,
                                          backgroundColor: Colors.green,
                                        ),
                                        displayDuration: Duration(seconds: 1),
                                      );
                                      Navigator.of(context).pop();
                                    } else {
                                      //wrong
                                      setState(() {
                                        loading = false;
                                      });
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message: value.message,
                                        ),
                                        displayDuration: Duration(seconds: 1),
                                      );
                                    }
                                  });
                                }
                              },
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width,
                              child: loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      getLang(context, 'Edit Clinic'),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  goToMapPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => UserLocation(
                  isNew: false,
                ))).then((_) {
      UserProvider prov = Provider.of<UserProvider>(context, listen: false);
      _address.longitude = prov.address.longitude;
      _address.latitude = prov.address.latitude;
      addressString = prov.addressString;
      setState(() {});
      mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(_address.latitude, _address.longitude), zoom: 18.0)));
    });
  }
}
