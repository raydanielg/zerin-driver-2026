import UIKit
import Flutter
import UserNotifications
#if canImport(flutter_downloader)
import flutter_downloader
#endif


@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let googleMapsAPIKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
       !googleMapsAPIKey.isEmpty {
      let selector = NSSelectorFromString("provideAPIKey:")
      if let gmsServicesClass = NSClassFromString("GMSServices") as? NSObject.Type,
         gmsServicesClass.responds(to: selector) {
        _ = (gmsServicesClass as AnyObject).perform(selector, with: googleMapsAPIKey)
      }
    }
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
#if canImport(flutter_downloader)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
#endif
  }
}

#if canImport(flutter_downloader)
private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
    FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
   }
}
#endif
