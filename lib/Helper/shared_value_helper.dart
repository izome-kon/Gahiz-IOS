import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';

class SharedValueHelper {
  static SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String getCartList() {
    return sharedPreferences.getString('cart_list_local');
  }

  static setCartList(string) {
    sharedPreferences.setString('cart_list_local', string);
  }

  static int messagesCount;

  static chatInit() async {
    Freshchat.init("bc07ec95-073b-4518-b6cb-a6d6fd558d99",
        "e6d551b6-f782-46ef-975a-6109bf4e569f", "msdk.freshchat.com",
        stringsBundle: "FCCustomLocalizable",
        errorLogsEnabled: true,
        teamMemberInfoVisible: true,
        cameraCaptureEnabled: true,
        gallerySelectionEnabled: true,
        responseExpectationEnabled: true,
        themeName: "CustomTheme.plist");

    FreshchatUser freshchatUser = await Freshchat.getUser;
    if (is_logged_in.$) {
      freshchatUser.setFirstName(user_name.$);
      freshchatUser.setPhone(user_phone.$.substring(0, 3),
          user_phone.$.substring(3, user_phone.$.length));
      Freshchat.setUser(freshchatUser);
    }
    FirebaseMessaging.instance.getToken().then((value) {
      Freshchat.setPushRegistrationToken(value);
    });

    var unreadCountStream = Freshchat.onMessageCountUpdate;
    unreadCountStream.listen((event) {
      print("New message generated: " + event.toString());
    });
  }
}

final SharedValue<bool> is_logged_in = SharedValue(
  value: false, // initial value
  key: "is_logged_in", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<bool> is_first_login = SharedValue(
  value: true, // initial value
  key: "is_first_login", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<bool> showHomeSteps = SharedValue(
  value: true, // initial value
  key: "showHomeSteps", // disk storage key for shared_preferences
);
final SharedValue<bool> showSuppliersSteps = SharedValue(
  value: true, // initial value
  key: "showSuppliersSteps", // disk storage key for shared_preferences
);

// final SharedValue<String> cart_local_qtys = SharedValue(
//   value: "", // initial value
//   key: "cart_local_qtys", // disk storage key for shared_preferences
//   autosave: true, // autosave to shared prefs when value changes
// );

final SharedValue<List<String>> localCartList =
    SharedValue(key: 'cart_items', autosave: true, value: []);

final SharedValue<String> access_token = SharedValue(
  value: "[]", // initial value
  key: "access_token", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<int> user_id = SharedValue(
  value: 0, // initial value
  key: "user_id", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> avatar_original = SharedValue(
  value: "", // initial value
  key: "avatar_original", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> user_name = SharedValue(
  value: "", // initial value
  key: "user_name", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> user_email = SharedValue(
  value: "", // initial value
  key: "user_email", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> user_phone = SharedValue(
  value: "", // initial value
  key: "user_phone", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);
