import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';

class DoctorInfo extends StatefulWidget {
  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getLang(context, 'new_regester'),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
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
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: getLang(context, 'clinic_name'),
              hintText: getLang(context, 'enter_clinic_name'),
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: getLang(context, 'branch_name'),
              hintText: getLang(context, 'enter_branch_name'),
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: getLang(context, 'city'),
              hintText: getLang(context, 'enter_city'),
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: getLang(context, 'area'),
              hintText: getLang(context, 'enter_area'),
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: getLang(context, 'address'),
              hintText: getLang(context, 'enter_address'),
            ),
          ),
        ],
      ),
    );
  }
}
