var thisYear = DateTime.now().year.toString();

class AppConfig {
  static String copyrightText =
      "@ Gahiz " + thisYear; //this shows in the splash screen
  static String appName = "Gahiz - جاهز"; //this shows in the splash screen

  //configure this
  static const bool HTTPS = true;

  //configure this
  // static const DOMAIN_PATH = "192.168.1.5";
  static const DOMAIN_PATH = "dental.xlink-egy.com";

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PUBLIC_FOLDER = "public";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
  static const String BASE_PATH = "$RAW_BASE_URL/$PUBLIC_FOLDER/";


  static const int VOICE_RECORD_ID = 195;
  static const int PIC_ORDER_ID = 196;
  static const int TEXT_ORDER_ID = 197;
}
