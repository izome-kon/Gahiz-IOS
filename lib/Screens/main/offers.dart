import 'package:denta_needs/Apis/productApi.dart';
import 'package:denta_needs/Common/custom_drawer.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/notification_button.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/global.dart';
import 'package:denta_needs/Responses/Product/flash_deal_response.dart';
import 'package:denta_needs/Screens/Offers/offer_card.dart';
import 'package:denta_needs/Screens/Product/wholesaler_card.dart';
import 'package:denta_needs/Screens/Search/search.dart';
import 'package:denta_needs/Screens/Wholesaler/wholesaler_page_card.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:lottie/lottie.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  FlashDealResponse _flashDeals;
  List<CountdownTimerController> _timerControllerList = [];

  getData() async {
    _flashDeals = await ProductApi().getFlashDeals();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
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
          getLang(context, 'offers'),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      drawer: CustomDrawer(),
      body: _flashDeals == null
          ? ShimmerHelper().buildListShimmer(item_height: 200.0)
          : _flashDeals.flash_deals.length == 0
              ? Column(
                  children: [
                    Lottie.asset('assets/lottie/offers_empty.json',
                        repeat: false),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 300,
                        child: Text(
                          'Currently we do not have offers, come back to get more of them',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: accentColor,
                  onRefresh: _onShopListRefresh,
                  child: ListView.separated(
                    itemCount: _flashDeals.flash_deals.length,
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => Divider(
                      thickness: 0,
                    ),
                    itemBuilder: (context, index) {
                      DateTime end = Global.convertTimeStampToDateTime(
                          _flashDeals.flash_deals[index].date); // YYYY-mm-dd
                      DateTime now = DateTime.now();
                      int diff = end.difference(now).inMilliseconds;
                      int endTime = diff + now.millisecondsSinceEpoch;

                      void onEnd() {}

                      CountdownTimerController time_controller =
                          CountdownTimerController(
                              endTime: endTime, onEnd: onEnd);
                      _timerControllerList.add(time_controller);
                      return CountdownTimer(
                          controller: _timerControllerList[index],
                          widgetBuilder: (_, CurrentRemainingTime time) {
                            return OfferCard(
                              flashDeal: _flashDeals.flash_deals[index],
                              currentRemainingTime: time,
                            );
                          });
                    },
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                  ),
                ),
    );
  }

  Future<void> _onShopListRefresh() async {
    _flashDeals = null;
    setState(() {});
    getData();
  }
}
