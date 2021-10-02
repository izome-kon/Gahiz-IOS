import 'package:denta_needs/Apis/auth_repository.dart';
import 'package:denta_needs/Common/logo.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Helper/pushNotificationServices.dart';
import 'package:denta_needs/Helper/shared_value_helper.dart';
import 'package:denta_needs/Provider/cart_provider.dart';
import 'package:denta_needs/Provider/register_provider.dart';
import 'package:denta_needs/Provider/settings.dart';
import 'package:denta_needs/Provider/user_provider.dart';

import 'package:denta_needs/Screens/Login/login.dart';
import 'package:denta_needs/Screens/MyOrders/OrderDetails.dart';

import 'package:denta_needs/Screens/SignUp/sign_up.dart';
import 'package:denta_needs/Screens/intro.dart';
import 'package:denta_needs/Screens/main/main.dart';
import 'package:denta_needs/Screens/splash.dart';

import 'package:denta_needs/Utils/theme.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_value/shared_value.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message,
    {context}) async {
  await Firebase.initializeApp();
  print(message.data);
  if (await Freshchat.isFreshchatNotification(message.data)) {
    Freshchat.handlePushNotification(message.data);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  access_token.load().whenComplete(() {
    print(access_token.value);
  });

  /*is_logged_in.load();
  user_id.load();
  avatar_original.load();
  user_name.load();
  user_email.load();
  user_phone.load();*/

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SharedValueHelper.init();
    SharedValueHelper.chatInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => Settings()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: OverlaySupport.global(
          child: FeatureDiscovery(
        child: MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          title: 'Gahiz - جاهز',
          localizationsDelegates: [
            AppLocale.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: [
            Locale("en", "EN"),
            Locale("ar", "AR"),
          ],
          localeResolutionCallback: (currentLang, supportLang) {
            if (currentLang != null) {
              for (Locale locale in supportLang) {
                if (locale.languageCode == currentLang.languageCode) {
                  // mySharedPreferences.setString("lang", currentLang.languageCode);
                  return currentLang;
                }
              }
            }
            return supportLang.first;
          },
          theme: myThemeData,
          debugShowCheckedModeBanner: false,
          home: Splash(),
          // ),
        ),
      )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Logo(LogoType.LIGHT)),
    );
  }
}
