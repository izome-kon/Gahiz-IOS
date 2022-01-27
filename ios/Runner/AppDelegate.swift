import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCzw9TIaSUYhhOsP7-zXny4e-nMx8G_JjU")
    GeneratedPluginRegistrant.register(with: self)
//    let freshchatSdkPlugin = FreshchatSdkPlugin()
//    if freshchatSdkPlugin.isFreshchatNotification(userInfo){    freshchatSdkPlugin.handlePushNotification(userInfo)}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    override func application(_ application: UIApplication,
                              didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        let freshchatSdkPlugin = FreshchatSdkPlugin()
        if freshchatSdkPlugin.isFreshchatNotification(userInfo){    freshchatSdkPlugin.handlePushNotification(userInfo)}
    }
    
    override func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
         
        let freshchatSdkPlugin = FreshchatSdkPlugin()
        freshchatSdkPlugin.setPushRegistrationToken(deviceToken)
    }
}
