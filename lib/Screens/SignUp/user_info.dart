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

enum AccountType { DOCTOR, STUDENT }

class _UserInfoState extends State<UserInfo> {
  AccountType type;

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

              // Container(
              //   color: accentColor,
              //   padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.person,
              //         color: whiteColor,
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text(
              //         getLang(context, 'user_info'),
              //         style: TextStyle(
              //             color: whiteColor,
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
              //
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
                onChanged: (s) {
                  value.setPhone = s;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    prefix: Text(
                      '+20 ',
                    ),
                    labelText: getLang(context, 'phone_number'),
                    hintText: getLang(context, 'enter_your_phone'),
                    suffixIcon: Icon(Icons.phone_android)),
              ),
              TextFormField(
                obscureText: true,
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
              // Container(
              //   color: accentColor,
              //   padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.settings,
              //         color: whiteColor,
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text(
              //         getLang(context, 'account_type'),
              //         style: TextStyle(
              //             color: whiteColor,
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Column(
              //       children: [
              //         InkWell(
              //           onTap: () {
              //             value.setNewAccountType = "doctor";
              //                type = AccountType.DOCTOR;
              //
              //           },
              //           child: CircleAvatar(
              //             radius: 35,
              //             backgroundColor: type == AccountType.DOCTOR
              //                 ? primaryColor
              //                 : accentColor,
              //             child: CircleAvatar(
              //               radius: 32,
              //               child: Image.asset(
              //                 type == AccountType.DOCTOR
              //                     ? 'assets/images/dentist-selected.png'
              //                     : 'assets/images/dentist.png',
              //                 width: 45,
              //               ),
              //               backgroundColor: type == AccountType.DOCTOR
              //                   ? primaryColor
              //                   : whiteColor,
              //             ),
              //           ),
              //         ),
              //         Text(getLang(context, 'doctor'))
              //       ],
              //     ),
              //     Column(
              //       children: [
              //         InkWell(
              //           onTap: () {
              //             value.setNewAccountType = "student";
              //                type = AccountType.STUDENT;
              //           },
              //           child: CircleAvatar(
              //             radius: 35,
              //             backgroundColor: type == AccountType.STUDENT
              //                 ? primaryColor
              //                 : accentColor,
              //             child: CircleAvatar(
              //               radius: 32,
              //               child: type == AccountType.STUDENT
              //                   ? Image.asset(
              //                       'assets/images/graduated-selected.png',
              //                       width: 45,
              //                     )
              //                   : Image.asset(
              //                       'assets/images/graduated.png',
              //                       width: 45,
              //                     ),
              //               backgroundColor: type == AccountType.STUDENT
              //                   ? primaryColor
              //                   : whiteColor,
              //             ),
              //           ),
              //         ),
              //         Text(getLang(context, 'student'))
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
