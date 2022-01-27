import 'package:country_code_picker/country_code_picker.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:denta_needs/Apis/authApi.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Helper/valedator.dart';
import 'package:denta_needs/Provider/register_provider.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  UserInfo();

  @override
  _UserInfoState createState() => _UserInfoState();
}

/// Account Type ( DOCTOR OR STUDENT )
enum AccountType { DOCTOR, STUDENT }

class _UserInfoState extends State<UserInfo> {
  AccountType type;

  String countryCode = '+20';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<RegisterProvider>(
        builder: (context, value, child) => Form(
          key: value.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getLang(context, 'new_regester'),
                style: TextStyle(
                    fontSize: 22,
                    color: fontColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 50,
                    child: TextFormField(
                      validator: (value) {
                        return Validator.password(context, value);
                      },
                      keyboardType: TextInputType.text,
                      onChanged: (s) {
                        value.setFName = s;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: getLang(context, 'First Name'),
                          hintText: getLang(context, 'enter_your_name'),
                          suffixIcon: Icon(Icons.person)),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 50,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return Validator.password(context, value);
                      },
                      keyboardType: TextInputType.text,
                      onChanged: (s) {
                        value.setLName = s;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: getLang(context, 'Last Name'),
                          hintText: getLang(context, 'enter_your_name'),
                          suffixIcon: Icon(Icons.person)),
                    ),
                  ),
                ],
              ),
              TextFormField(
                validator: (value) {
                  return Validator.password(context, value);
                },
                textInputAction: TextInputAction.next,
                onChanged: (s) {
                  value.setPhone = s;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    prefix: CountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        value.countryCode = countryCode.dialCode;
                        print('code' + value.countryCode);
                      },
                      // Initial selection
                      initialSelection: 'EG',
                      favorite: ['+20', 'EG'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                    labelText: getLang(context, 'phone_number'),
                    hintText: getLang(context, 'enter_your_phone'),
                    suffixIcon: Icon(Icons.phone_android)),
              ),
              TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  return Validator.password(context, value);
                },
                onChanged: (s) {
                  value.setPassword = s;
                },
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: getLang(context, 'password'),
                    hintText: getLang(context, 'enter_password'),
                    suffixIcon: Icon(Icons.lock)),
              ),
              SizedBox(
                height: 15,
              ),
              CupertinoRadioChoice(
                  choices: {
                    'doctor': getLang(context, 'doctor'),
                    'student': getLang(context, 'student'),
                  },
                  selectedColor: primaryColor,
                  onChange: (selectedGender) {
                    value.newAccountType = selectedGender;
                    print(selectedGender);
                  },
                  initialKeyValue: 'male')
            ],
          ),
        ),
      ),
    );
  }
}
