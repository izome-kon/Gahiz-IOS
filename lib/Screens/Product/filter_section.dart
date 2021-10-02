import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterChip(
          selectedColor: primaryColor,
          avatar: Icon(
            Icons.sort,
            color: primaryColor,
          ),
          labelStyle:
              TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
          label: Text(getLang(context, 'sort')),
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(side: BorderSide(color: primaryColor)),
          onSelected: (bool value) {},
        ),
        SizedBox(
          width: 10,
        ),
        FilterChip(
          selectedColor: primaryColor,
          avatar: Icon(
            Icons.filter_alt_outlined,
            color: primaryColor,
          ),
          labelStyle:
              TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
          label: Text(getLang(context, 'filter')),
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(side: BorderSide(color: primaryColor)),
          onSelected: (bool value) {},
        ),
        SizedBox(
          width: 10,
        ),
        FilterChip(
          avatar: Icon(
            Icons.info_outline,
            color: primaryColor,
          ),
          labelStyle:
              TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
          label: Text(getLang(context, 'details')),
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(side: BorderSide(color: primaryColor)),
          onSelected: (bool value) {},
        ),
      ],
    );
  }
}
