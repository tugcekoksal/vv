import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    GMSServices.provideAPIKey("AIzaSyBlp6Yxj5ZOT0E3OMjhmi0YQH50YnVFm1c")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
