#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CustomTabBarController : UITabBarController <UITabBarControllerDelegate, UINavigationControllerDelegate>

@property CLLocationManager *locationManager;

@end
