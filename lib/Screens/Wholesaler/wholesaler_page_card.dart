import 'package:denta_needs/Apis/shop_repository.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_info_page.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';

class WholesalerPageCard extends StatefulWidget {
  final shop;

  WholesalerPageCard({this.shop});

  @override
  _WholesalerCardState createState() => _WholesalerCardState();
}

class _WholesalerCardState extends State<WholesalerPageCard> {
  /// Wholesaler products count
  String productsCount;

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    productsCount =
        await ShopRepository().getProductsCount(id: widget.shop.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return

      Container(
      height: 107,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => WholesalerInfoPage(
                shop: widget.shop,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.all(2),
          color: whiteColor,
          child: Column(
            children: [
              Row(
                children: [
                  Card(
                    child: Container(
                      width: 90,
                      height: 92,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: AppConfig.BASE_PATH + widget.shop.logo,
                          width: 70,
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Text(
                          //   'عدد المنتجات: ' +
                          //       (productsCount == null ? '...' : productsCount),
                          //   style: TextStyle(color: primaryColor, fontSize: 13),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 2,
                height: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
