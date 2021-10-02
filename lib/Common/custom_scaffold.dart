// import 'dart:async';
//
// import 'package:connectivity/connectivity.dart';
// import 'package:denta_needs/Helper/applocal.dart';
// import 'package:denta_needs/Utils/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';
//
// enum AniProps { x, y }
//
// class CustomScaffold extends StatefulWidget {
//   final Scaffold scaffold;
//   CustomScaffold(this.scaffold);
//   @override
//   _CustomScaffoldState createState() => _CustomScaffoldState();
// }
//
// class _CustomScaffoldState extends State<CustomScaffold> {
//   var subscription;
//   ConnectivityResult connection;
//   bool connectedNow, first;
//
//   @override
//   void initState() {
//     connectedNow = false;
//     first = true;
//     subscription = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       print(result);
//       setState(() {
//         connection = result;
//         if (connection == ConnectivityResult.wifi ||
//             connection == ConnectivityResult.mobile) {
//           if (!first)
//             connectedNow = true;
//           else
//             first = false;
//           timer();
//         }
//       });
//     });
//     if (first) check();
//     super.initState();
//   }
//
//   check() async {
//     connection = await (Connectivity().checkConnectivity());
//     setState(() {
//       first = false;
//     });
//   }
//
//   timer() {
//     new Timer(Duration(seconds: 3), () {
//       if (mounted)
//         setState(() {
//           connectedNow = false;
//         });
//     });
//   }
//
//   @override
//   dispose() {
//     super.dispose();
//     subscription.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (connection == ConnectivityResult.none)
//         ? Material(
//             child: Stack(
//               children: [
//                 widget.scaffold,
//                 PlayAnimation<TimelineValue<AniProps>>(
//                   tween: _tween, // Pass in tween
//                   duration: _tween.duration, // Obtain duration
//                   builder: (context, child, value) {
//                     return Align(
//                       alignment: Alignment.topCenter,
//                       child: SafeArea(
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: value.get(AniProps.y),
//                           padding: EdgeInsets.all(1),
//                           color: Colors.redAccent,
//                           alignment: Alignment.topCenter,
//                           child: Text(
//                             getLang(context, 'check_network'),
//                             style: TextStyle(
//                                 color: whiteColor, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           )
//         : connectedNow
//             ? Material(
//                 child: Stack(
//                   children: [
//                     widget.scaffold,
//                     PlayAnimation<TimelineValue<AniProps>>(
//                         tween: _tween, // Pass in tween
//                         duration: _tween.duration, // Obtain duration
//                         builder: (context, child, value) {
//                           return Align(
//                             alignment: Alignment.topCenter,
//                             child: SafeArea(
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 height: value.get(AniProps.y),
//                                 padding: EdgeInsets.all(1),
//                                 color: Colors.green,
//                                 alignment: Alignment.topCenter,
//                                 child: Text(
//                                   getLang(context, 'connected_to_network'),
//                                   style: TextStyle(
//                                       color: whiteColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                   ],
//                 ),
//               )
//             : widget.scaffold;
//   }
//
//   var _tween = TimelineTween<AniProps>()
//     ..addScene(begin: 0.milliseconds, duration: 500.milliseconds)
//         .animate(AniProps.y, tween: (0.0).tweenTo(30.0));
// }
