import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    Appboy.startWithApiKey("6deb7788-edee-4a02-b75a-a254cdb9f58b", inApplication:application, withLaunchOptions:launchOptions)
    
    // Register push
    let types : UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
    var setting : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(setting)
    UIApplication.sharedApplication().registerForRemoteNotifications()
    
    return true
  }

  func applicationDidBecomeActive(application: UIApplication) {
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    var deviceTokenString = String(format: "%@", deviceToken)
    Appboy.sharedInstance().registerPushToken(deviceTokenString)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    Appboy.sharedInstance().registerApplication(application, didReceiveRemoteNotification: userInfo)
  }
}

