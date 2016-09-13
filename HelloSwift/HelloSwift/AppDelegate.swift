import UIKit
import Appboy_iOS_SDK
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    // Override point for customization after application launch.
    Appboy.start(withApiKey: "6deb7788-edee-4a02-b75a-a254cdb9f58b", in:application, withLaunchOptions:launchOptions)
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      print("Permission granted.")
    }
    center.delegate = self
    UIApplication.shared.registerForRemoteNotifications()
    
    return true
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = String(format: "%@", deviceToken.description)
    Appboy.sharedInstance()!.registerPushToken(deviceTokenString)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    Appboy.sharedInstance()!.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
}

