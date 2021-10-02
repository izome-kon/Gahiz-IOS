import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/cart_repository.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:denta_needs/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RecordOrderScreen extends StatefulWidget {
  const RecordOrderScreen({Key key}) : super(key: key);

  @override
  _RecordOrderScreenState createState() => _RecordOrderScreenState();
}

enum RecordPageState { RECORD, PLAY_RECORD }

class _RecordOrderScreenState extends State<RecordOrderScreen> {
  bool result;
  double recordRadius = 0;
  Color buttonColor = primaryColor;
   StopWatchTimer _stopWatchTimer = StopWatchTimer();
  RecordPageState pageState = RecordPageState.RECORD;
  bool isRecording;
   AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration();
  Duration position = Duration();
  String localPath = '';

  AudioPlayerState playerState = AudioPlayerState.STOPPED;

  hasPermission() async {
    result = await Record.hasPermission();
  }

  @override
  void initState() {
    hasPermission();
    audioPlayer.onAudioPositionChanged.listen((event) {
      if (this.mounted)
        setState(() {
          position = event;
        });
    });
    audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        if (this.mounted)
          setState(() {
            duration = audioPlayer.duration;
            playerState = AudioPlayerState.PLAYING;
          });
      } else if (s == AudioPlayerState.STOPPED) {
        // onComplete();
        if (this.mounted)
          setState(() {
            position = duration;
            playerState = AudioPlayerState.STOPPED;
          });
      }
    }, onError: (msg) {
      if (this.mounted)
        setState(() {
          playerState = AudioPlayerState.STOPPED;
          duration = new Duration(seconds: 0);
          position = new Duration(seconds: 0);
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    audioPlayer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          getLang(context, 'Record Order'),
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
      ),
      body: Stack(children: [
        Image.asset(
          'assets/images/pattern2.png',
          fit: BoxFit.cover,
          width: 2000,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: pageState == RecordPageState.PLAY_RECORD
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getLang(context, 'Listen'),
                      style: TextStyle(color: fontColor, fontSize: 18),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RippleAnimation(
                      repeat: true,
                      color: buttonColor,
                      minRadius: recordRadius,
                      ripplesCount: 5,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 120, height: 120),
                        child: ElevatedButton(
                          child: Icon(
                            playerState == AudioPlayerState.STOPPED ||
                                    playerState == AudioPlayerState.PAUSED
                                ? Icons.play_arrow_outlined
                                :
                                 Icons.pause,
                            size: 50,
                          ),
                          onPressed: onPressPlaySound,
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                               primary: 
                               (playerState ==
                                          AudioPlayerState.PAUSED ||
                                      playerState == AudioPlayerState.STOPPED)
                                  ? primaryColor
                                  : 
                                  accentColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: 
                      
                      ProgressBar(
                        progress: position,
                        total: duration,
                        barHeight: 10,
                        timeLabelLocation: TimeLabelLocation.above,
                        timeLabelTextStyle: TextStyle(color: fontColor),
                        thumbColor: (playerState == AudioPlayerState.PAUSED ||
                                playerState == AudioPlayerState.STOPPED)
                            ? primaryColor
                            : accentColor,
                        progressBarColor: primaryColor,
                        onSeek: (duration) {
                          audioPlayer.seek(duration.inSeconds.toDouble());
                          position = duration;
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 20,
                      child: FlatButton(
                          onPressed: onPressReset,
                          color: Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                getLang(context, 're-recording'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          )),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RippleAnimation(
                      repeat: true,
                      color: buttonColor,
                      minRadius: recordRadius,
                      ripplesCount: 5,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 120, height: 120),
                        child: ElevatedButton(
                          child: recordRadius > 0
                              ? Icon(
                                  Icons.stop,
                                  size: 40,
                                )
                              : Image.asset(
                                  'assets/images/microphone.png',
                                  width: 40,
                                  height: 40,
                                ),
                          onPressed: onPressRecordOrder,
                          style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    recordRadius > 0
                        ? StreamBuilder<int>(
                            initialData: 0,
                            stream: _stopWatchTimer.rawTime,
                            builder: (context, snapshot) {
                              duration = Duration(milliseconds: snapshot.data);
                              return Text(
                                DateFormat('mm:ss').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data)),
                                style:
                                    TextStyle(fontSize: 18, color: fontColor),
                              );
                            },
                          )
                        :
                         Text(
                            getLang(
                              context,
                              'Click the microphone button to record',
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: fontColor.withOpacity(0.5),
                            ),
                          ),
                  ],
                ),
        ),
      ]),
      bottomNavigationBar: pageState == RecordPageState.RECORD
          ? null
          : BottomAppBar(
              child: Container(
                alignment: Alignment.center,
                height: 60,
                color: primaryColor,
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: onPressAddToCart,
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            getLang(context, 'add_to_cart'),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      )),
                ),
              ),
            ),
    );
  }

  Future<void> onPressRecordOrder() async {
    isRecording = await Record.isRecording();
    if (isRecording) {
      await Record.stop();
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    } else {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      localPath = '${appDocumentsDirectory.path}/demo.aac';
      await Record.start(
        path: localPath, // required
        encoder: AudioEncoder.AAC, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }
    setState(() {
      if (recordRadius > 0) {
        recordRadius = 0;
        buttonColor = primaryColor;
        pageState = RecordPageState.PLAY_RECORD;
      } else {
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
        recordRadius = 60;
        buttonColor = Colors.redAccent;
      }
    });
  }

  onPressPlaySound() async {
    print(localPath);
    if (playerState == AudioPlayerState.PLAYING) {
      await audioPlayer.pause();
      playerState = AudioPlayerState.PAUSED;
    } else {
      await audioPlayer.play(localPath, isLocal: true);
    }
     setState(() {});
  }

  onPressReset() {
    recordRadius = 0;
    buttonColor = primaryColor;
     _stopWatchTimer = StopWatchTimer();
    pageState = RecordPageState.RECORD;
    isRecording = false;
    duration = Duration();
    position = Duration();
    localPath = '';

    playerState = AudioPlayerState.STOPPED;
    setState(() {});
  }

  onPressAddToCart() async {
    CoolAlert.show(
        context: context,
        barrierDismissible: false,
        lottieAsset: 'assets/lottie/plan.json',
        type: CoolAlertType.loading,
        title: getLang(context, "Uploading.."));

    File _file = File.fromUri(Uri.file(localPath));
    String base64Image = base64Encode(_file.readAsBytesSync());
    String fileName = _file.path.split("/").last;

    await CartRepository()
        .getCartAddVoiceRecordResponse(
            filename: fileName,
            image: base64Image,
            description: '',
            user_id: user_id.value,
            owner_user_id: AppConfig.VOICE_RECORD_ID,
            order_type: 'voice record')
        .then((value) {
      if (value.result) {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: value.message,
            backgroundColor: Colors.green,
          ),
          displayDuration: Duration(seconds: 2),
        );
        Provider.of<CartProvider>(context,listen: false).sendUpdateRequest=true;
        Navigator.of(context)..pop()..pop();
      } else {
        Navigator.of(context)..pop();
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: value.message,
          ),
          displayDuration: Duration(seconds: 2),
        );
      }
    });
  }
}
