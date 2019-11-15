import UIKit
import Appboy_iOS_SDK
import UserNotifications
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ABKInAppMessageControllerDelegate, ABKURLDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    // Override point for customization after application launch.
    let appboyOptions: [AnyHashable: Any] = [
      ABKMinimumTriggerTimeIntervalKey : 1,
      ABKInAppMessageControllerDelegateKey : self,
      ABKURLDelegateKey : self
    ]
    Appboy.start(withApiKey: "1fbb9af3-93e0-43a2-920c-c6d867dab72a", in:application, withLaunchOptions:launchOptions, withAppboyOptions: appboyOptions)
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      Appboy.sharedInstance()?.pushAuthorization(fromUserNotificationCenter: granted)                                                             
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
    Appboy.sharedInstance()!.registerDeviceToken(deviceToken)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    Appboy.sharedInstance()!.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    NSLog("HelloSwift open url delegate called with: %@", url.absoluteString)
    let urlString = url.absoluteString.removingPercentEncoding
    if (urlString == "helloswift:appstore-review") {
      NSLog("Received app store review request.")
      if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()
      }
      return true;
    }
    let deeplinkAlert = UIAlertController(title: "Deeplink", message: urlString, preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "ok", style: .default, handler: nil)
    deeplinkAlert.addAction(action)
    self.window?.rootViewController?.present(deeplinkAlert, animated: true, completion: nil)

    return true;
  }

  func before(inAppMessageDisplayed inAppMessage: ABKInAppMessage) -> ABKInAppMessageDisplayChoice {
    if inAppMessage.extras?["Appstore Review"] != nil && inAppMessage.uri != nil {
      UIApplication.shared.open(inAppMessage.uri!, options: [:], completionHandler: nil)
      return ABKInAppMessageDisplayChoice.discardInAppMessage
    } else {
      return ABKInAppMessageDisplayChoice.displayInAppMessageNow
    }
  }

  func handleAppboyURL(_ url: URL, from channel: ABKChannel, withExtras extras: [AnyHashable : Any]) -> Bool {
    if (url.host == "sweeney.appboy.com") {
      NSLog("Received link with host sweeney.appboy.com.")
      return true;
    }
    // Let Braze handle links otherwise
    return false;
  }
}
