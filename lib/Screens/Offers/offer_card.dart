import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/Product/flash_deal_response.dart';
import 'package:denta_needs/Screens/Offers/offer_info.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:intl/intl.dart';

class OfferCard extends StatefulWidget {
  final bool button;
  final FlashDeal flashDeal;
  final currentRemainingTime;

  OfferCard({this.button = true, this.flashDeal, this.currentRemainingTime});

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  @override
  Widget build(BuildContext context) {
    return widget.button
        ? MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => OfferInfo(
                    flashDeal: widget.flashDeal,
                    currentRemainingTime: widget.currentRemainingTime,
                  ),
                ),
              );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: AppConfig.BASE_PATH_FOR_NETWORK +
                              widget.flashDeal.banner,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.flashDeal.title,
                          style: TextStyle(fontSize: 20),
                        ),
                        buildTimerRowRow(widget.currentRemainingTime)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: AppConfig.BASE_PATH_FOR_NETWORK +
                            widget.flashDeal.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.flashDeal.title,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                            getLang(context, "End at") +
                                ' ${DateFormat('yyyy/MM/dd').format(convertTimeStampToDateTime(widget.flashDeal.date))}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black45)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  buildTimerRowRow(CurrentRemainingTime time) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(2))),
      padding: EdgeInsets.only(left: 2, right: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.access_time,
            color: accentColor,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            timeText(time.days.toString(), default_length: 3),
            style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 1.0),
            child: Text(
              ":",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            timeText(time.hours.toString(), default_length: 2),
            style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 1.0),
            child: Text(
              ":",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            timeText(time.min.toString(), default_length: 2),
            style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 1.0),
            child: Text(
              ":",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            timeText(time.sec.toString(), default_length: 2),
            style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String timeText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }
}
