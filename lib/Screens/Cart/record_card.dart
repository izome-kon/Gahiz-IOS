import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Common/toast_component.dart';
import 'package:denta_needs/Helper/PositionInCart.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/page_manager.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/user_provider.dart';
import 'package:denta_needs/Responses/Cart/cart_response.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:toast/toast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RecordCartCard extends StatefulWidget {
  final bool payment;
  final CartItem cartItem;
  final row, col; //supplier index , product index

  RecordCartCard({this.payment = false, this.cartItem, this.col, this.row});

  @override
  _ProductCartCardState createState() => _ProductCartCardState();
}

class _ProductCartCardState extends State<RecordCartCard> {
  PositionInCart positionInCart;
  bool deleteIsLoading = false;
  bool result;
  double recordRadius = 0;
  Color buttonColor = primaryColor;
  AudioPlayerState playerState = AudioPlayerState.STOPPED;
  Duration duration = Duration();
  Duration position = Duration();
  PageManager _pageManager;

  @override
  void initState() {
    positionInCart = Provider.of<CartProvider>(context, listen: false)
        .getPosition(widget.cartItem.product_id);

    _pageManager = PageManager(AppConfig.BASE_PATH_FOR_NETWORK +
        widget.cartItem.product_thumbnail_image);
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            children: [
              Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 10, height: 10),
                    child: ValueListenableBuilder<ButtonState>(
                        valueListenable: _pageManager.buttonNotifier,
                        builder: (_, value, __) {
                          switch (value) {
                            case ButtonState.loading:
                              return Container(
                                margin: EdgeInsets.all(8.0),
                                width: 20.0,
                                height: 20.0,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: primaryColor,
                                )),
                              );
                            case ButtonState.paused:
                              return ElevatedButton(
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 28,
                                ),
                                onPressed: _pageManager.play,
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: primaryColor),
                              );
                            case ButtonState.playing:
                              return ElevatedButton(
                                child: Icon(
                                  Icons.pause,
                                  size: 28,
                                ),
                                onPressed: _pageManager.pause,
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: primaryColor),
                              );
                            default:
                              return ElevatedButton(
                                child: Icon(
                                  Icons.play_arrow_outlined,
                                  size: 28,
                                ),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: primaryColor),
                              );
                          }
                        }),
                  )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<ProgressBarState>(
                      valueListenable: _pageManager.progressNotifier,
                      builder: (_, value, __) {
                        return ProgressBar(
                          progress: value.current,
                          buffered: value.buffered,
                          total: value.total,
                          barHeight: 5,
                          timeLabelLocation: TimeLabelLocation.sides,
                          timeLabelTextStyle: TextStyle(color: fontColor),
                          progressBarColor: primaryColor,
                          onSeek: _pageManager.seek,
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        widget.payment
            ? Container()
            : Positioned(
                bottom: 10,
                right: 20,
                child: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return IconButton(
                        onPressed: () {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              text: getLang(context,
                                  "Are you sure to delete from the cart?"),
                              confirmBtnText: getLang(context, 'Delete'),
                              cancelBtnText: getLang(context, 'Cancel'),
                              showCancelBtn: true,
                              confirmBtnColor: Colors.red,
                              onConfirmBtnTap: () {
                                setState(() {
                                  deleteIsLoading = true;
                                });
                                Navigator.pop(context);
                                value
                                    .deleteFromCart(
                                        context, widget.cartItem.product_id)
                                    .then((_) {
                                  value.getData().then((value) {
                                    setState(() {
                                      deleteIsLoading = false;
                                    });
                                  });
                                });
                              });
                        },
                        splashRadius: 1,
                        constraints: BoxConstraints(minWidth: 10),
                        padding: EdgeInsets.zero,
                        icon: deleteIsLoading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.red,
                                color: primaryColor,
                              )
                            : Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ));
                  },
                ),
              ),
      ],
    );
  }
}
