import 'package:denta_needs/Apis/categoryApi.dart';
import 'package:denta_needs/Common/Widgets/category_card.dart';
import 'package:denta_needs/Common/custom_drawer.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/notification_button.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/Category/category_response.dart';
import 'package:denta_needs/Screens/Offers/offer_card.dart';
import 'package:denta_needs/Screens/Product/wholesaler_card.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_page_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Widget> categoriesWidgets;

  buildCategories() {
    return FutureBuilder<CategoryResponse>(
        future: CategoryApi().getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            /*print("product error");
            print(snapshot.error.toString());*/
            return Container();
          } else if (snapshot.hasData) {
            categoriesWidgets = [];
            //snapshot.hasData
            var featuredProductResponse = snapshot.data;
            for (int i = 0; i < featuredProductResponse.categories.length;) {
              List<Widget> row = [];
              for (int j = 0; j < 3; j++) {
                if (i == featuredProductResponse.categories.length) break;
                row.add(CategoryCard(
                  category: featuredProductResponse.categories[i],
                ));
                i++;
              }
              categoriesWidgets.add(Row(
                children: row,
              ));
            }
            categoriesWidgets.add(Row(
              children: [
                SizedBox(
                  height: 50,
                ),
              ],
            ));
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: categoriesWidgets,
            );
          } else {
            return ShimmerHelper().buildSquareGridShimmer(item_count: 15);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [NotificationButton()],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          getLang(context, 'categories'),
          style: TextStyle(color: whiteColor, fontSize: 18),
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: buildCategories(),
      ),
    );
  }
}
