import UIKit
import Appboy_iOS_SDK
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    // Override point for customization after application launch.
    Appboy.start(withApiKey: "5cafd0c6-26da-4773-922a-fd0c3c0d2eea", in:application, withLaunchOptions:launchOptions)
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      print("Permission granted.")
    }
    center.delegate = self
    UIApplication.shared.registerForRemoteNotifications()
    
    // Sample usage of unsafeInstance.  Note: startWithApiKey: MUST be called before calling unsafeInstance or an exception will be thrown.  
    // Note: this is a nonoptional alternative to sharedInstance()
    Appboy.unsafeInstance().user.setCustomAttributeWithKey("unsafeCustomAttributeSwift", andStringValue: "unsafeCustomAttributeSwift value")

    return true
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
    Appboy.sharedInstance()!.registerPushToken(deviceTokenString)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    Appboy.sharedInstance()!.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
}

