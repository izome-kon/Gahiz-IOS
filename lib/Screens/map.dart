import 'dart:async';

import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Screens/Address/add_address.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocod;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserLocation extends StatefulWidget {
  /// if you will create new address set [isNew] true
  final bool isNew;
  AddAddressType addAddressType;
  UserLocation({this.isNew = true, this.addAddressType = AddAddressType.OTHER});

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<UserLocation> {
  GoogleMapController mapController;
  Location location = new Location();
  bool _serviceEnabled;
  bool viewAddress = false;
  PermissionStatus _permissionGranted;
  String searchAddr;
  String area;
  String city;
  CameraPosition _cameraPosition;
  List<Marker> markers = [];
  TextEditingController _searchController = TextEditingController();
  LatLng curuntLatLng;
  var initLatLong = LatLng(30.033333, 31.233334);
  UserProvider prov;

  var _locationData;

  @override
  void initState() {
    getCurLocation();
    curuntLatLng = initLatLong;
    prov = Provider.of<UserProvider>(context, listen: false);
    prov.updateUserLocation(
        address: null,
        addressString: null,
        addressArea: null,
        addressCity: null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: getCurLocation,
          backgroundColor: primaryColor,
          child: Icon(
            Icons.location_searching,
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: onMapCreated,
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: initLatLong, zoom: 18.0),
              onCameraMoveStarted: () {
                setState(() {
                  viewAddress = false;
                });
              },
              onCameraIdle: () {
                if (_cameraPosition != null)
                  onLongPress(latLng: _cameraPosition.target);
              },
              onCameraMove: (pos) {
                _cameraPosition = pos;
              },
              markers: Set.from(markers),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: FlatButton(
                    child: Text(
                      getLang(context, 'confirm location'),
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      prov.updateUserLocation(
                          address: curuntLatLng,
                          addressString: _searchController.text,
                          addressArea: area,
                          addressCity: city);
                      if (widget.isNew) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AddAddress(
                                  addAddressType: widget.addAddressType,
                                )));
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    color: primaryColor,
                  ),
                )),
            Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    lottie.Lottie.asset('assets/lottie/location.json',
                        width: 70, height: 70),
                    !viewAddress
                        ? SizedBox(
                            height: 50,
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: primaryColor, width: 0.3),
                                color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Text(_searchController.text == ''
                                  ? getLang(context,
                                      'Touch the map to change the location')
                                  : _searchController.text),
                            ),
                          ),
                  ],
                ))
          ],
        ));
  }

  Future<void> getCurLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation().then((value) {
      changeCameraPos(
          new Position(latitude: value.latitude, longitude: value.longitude));
      onLongPress(latLng: LatLng(value.latitude, value.longitude));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void changeCameraPos(Position p) {
    geocod.placemarkFromCoordinates(p.latitude, p.longitude).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(p.latitude, p.longitude), zoom: 50.0)));
    });
  }

  Future<void> onLongPress({LatLng latLng}) async {
    if (latLng == null) {
      // markers.add(Marker(
      //     markerId: MarkerId(initLatLong.toString()), position: initLatLong));
    } else {
      try {
        var addresses = await geocod.placemarkFromCoordinates(
            latLng.latitude, latLng.longitude);
        setState(() {
          viewAddress = true;
        });
        area = addresses.first.country;
        city = addresses.first.name;
        searchAddr = addresses.first.name +
            ' ' +
            addresses.first.thoroughfare +
            ' ' +
            addresses.first.locality;
        _searchController.text = searchAddr;

        curuntLatLng = latLng;
        setState(() {});
      } catch (e) {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: getLang(context,
                'Unfortunately, a problem occurred. Please make sure you are connected to the Internet and try again'),
          ),
          displayDuration: Duration(seconds: 1),
        );
      }
    }
  }
}
