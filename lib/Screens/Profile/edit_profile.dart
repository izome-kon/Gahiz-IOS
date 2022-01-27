import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/profile_repositories.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Common/toast_component.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class EditProfile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<EditProfile> {
  var _nameController = TextEditingController(text: user_name.$);
  var _phoneController = TextEditingController(text: user_phone.$);
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          getLang(context, 'edit_profile'),
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                avatar_original.$ != null
                    ? Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          avatar_original.$ != ''
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundColor: primaryColor,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    child: Container(
                                      width: 136,
                                      height: 136,
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                        image: AppConfig.BASE_PATH_FOR_NETWORK +
                                            avatar_original.$,
                                      ),
                                    ),
                                  ),
                                )
                              : Logo(
                                  LogoType.DARK,
                                  enableTitle: false,
                                ),
                          IconButton(
                              onPressed: () {
                                chooseAndUploadImage(context);
                              },
                              icon: CircleAvatar(
                                  backgroundColor: accentColor,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )))
                        ],
                      )
                    : Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Logo(
                            LogoType.DARK,
                            enableTitle: false,
                          ),
                          IconButton(
                              onPressed: () {
                                chooseAndUploadImage(context);
                              },
                              icon: CircleAvatar(
                                  backgroundColor: accentColor,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: whiteColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: getLang(context, 'name'),
                          suffixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: getLang(context, 'phone_number'),
                            prefix: Text('+2 '),
                            suffixIcon: Icon(Icons.phone_android_outlined)),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: getLang(context, 'password'),
                            suffixIcon: Icon(Icons.lock_outline)),
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: getLang(context, "Confirm Password"),
                            suffixIcon: Icon(Icons.lock_outline)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                    color: primaryColor,
                    minWidth: MediaQuery.of(context).size.width - 10,
                    onPressed: () {
                      onPressUpdate();
                    },
                    child: Text(getLang(context, 'edit_profile'),
                        style: TextStyle(
                          color: whiteColor,
                        )))
              ]),
        ),
      ),
    );
  }

  //for image uploading
  File _file;
  PickedFile _pickedImage;

  chooseAndUploadImage(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(getLang(context, 'Photo Permission')),
                content: Text(getLang(context,
                    'This app needs photo to take pictures for upload user profile photo')),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(getLang(context, 'Deny')),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text(getLang(context, 'Settings')),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          getLang(context,
              "Go to your application settings and give photo permission"),
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    } else if (status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _pickedImage = await _picker.getImage(source: ImageSource.gallery);
      _file = File(_pickedImage.path);
      if (_file == null) {
        ToastComponent.showDialog(
            getLang(context, "No file is chosen"), context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }
      CoolAlert.show(
          context: context,
          barrierDismissible: false,
          lottieAsset: 'assets/lottie/plan.json',
          type: CoolAlertType.loading,
          title: getLang(context, "Edit Profile.."));

      //return;
      String base64Image = base64Encode(_file.readAsBytesSync());
      String fileName = _file.path.split("/").last;

      var profileImageUpdateResponse =
          await ProfileRepository().getProfileImageUpdateResponse(
        base64Image,
        fileName,
      );
      Navigator.of(context)
        ..pop()
        ..pop();
      if (profileImageUpdateResponse.result == false) {
        ToastComponent.showDialog(profileImageUpdateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else {
        ToastComponent.showDialog(profileImageUpdateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

        avatar_original.$ = profileImageUpdateResponse.path;
        setState(() {});
      }
    }
  }

  onPressUpdate() async {
    var name = _nameController.text.toString();
    var phone = '0' + int.parse(_phoneController.text).toString();
    var password = _passwordController.text.toString();
    var password_confirm = _confirmPasswordController.text.toString();

    var change_password = password != "" ||
        password_confirm !=
            ""; // if both fields are empty we will not change user's password

    if (name == "") {
      ToastComponent.showDialog(getLang(context, "Enter your name"), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password == "") {
      ToastComponent.showDialog(getLang(context, "Enter password"), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password_confirm == "") {
      ToastComponent.showDialog(
          getLang(context, "Confirm your password"), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password.length < 6) {
      ToastComponent.showDialog(
          getLang(context, "Password must contain at least 6 characters"),
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password != password_confirm) {
      ToastComponent.showDialog(
          getLang(context, "Passwords do not match"), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    CoolAlert.show(
        context: context,
        barrierDismissible: false,
        lottieAsset: 'assets/lottie/plan.json',
        type: CoolAlertType.loading,
        title: getLang(context, "Edit Profile.."));
    var profileUpdateResponse = await ProfileRepository()
        .getProfileUpdateResponse(name, change_password ? password : "", phone);

    if (profileUpdateResponse.result == false) {
      ToastComponent.showDialog(profileUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(profileUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context)
        ..pop()
        ..pop();
      user_name.$ = name;
      user_phone.$ = phone;
      setState(() {});
    }
  }
}
