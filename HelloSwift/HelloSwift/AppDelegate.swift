import UIKit
import Appboy_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    Appboy.startWithApiKey("6deb7788-edee-4a02-b75a-a254cdb9f58b", inApplication:application, withLaunchOptions:launchOptions)
    
    // Register push
    let setting : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(setting)
    UIApplication.sharedApplication().registerForRemoteNotifications()
    
    return true
  }

  func applicationDidBecomeActive(application: UIApplication) {
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let deviceTokenString = String(format: "%@", deviceToken)
    Appboy.sharedInstance()!.registerPushToken(deviceTokenString)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    Appboy.sharedInstance()!.registerApplication(application, didReceiveRemoteNotification: userInfo)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    Appboy.sharedInstance()!.registerApplication(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
}

