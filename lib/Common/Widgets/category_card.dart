import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/Screens/Category/category_page.dart';
import 'package:flutter/material.dart';

import '../../app_config.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => CategoryPage(
              category: widget.category,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 150,
        padding: EdgeInsets.all(4),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                  child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: AppConfig.BASE_PATH_FOR_NETWORK + widget.category.icon,
                width: 70,
              )),
              Spacer(),
              Text(
                widget.category.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
