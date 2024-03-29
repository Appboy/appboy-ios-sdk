#import "CustomTabBarController.h"
#import "ContainerViewController.h"
#import "ABKLocationManager.h"
#import "ColorUtils.h"
#import "LoggerUtils.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation CustomTabBarController

- (UIViewController *)childViewControllerForStatusBarStyle {
  return ((UINavigationController *)self.selectedViewController).topViewController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [ColorUtils applyThemeToViewController:self];
#if !TARGET_OS_TV
  if (@available(iOS 15.0, *)) {
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
  }
#endif
  // Add tab bar items to UITabBarController
  NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:
                                     [self addNavigationControllerWithChildren:@[@"Events", @"Attributes", @"Arrays", @"Alias"] andTitle:@"User" andImageName:@"user" withFlushButton:YES], // User tab
                                     [self addNavigationControllerWithChildren:@[@"UI", @"Controls"] andTitle:@"IAM" andImageName:@"IAM" withFlushButton:NO], // IAM tab
                                     [self addNavigationControllerWithIdentifier:@"FeedUIViewController" withTitle:@"Braze UI" andImageName:@"newsfeed"], // UI tab
                                     [self addNavigationControllerWithChildren:@[@"Misc", @"Data", @"About"] andTitle:@"Advanced" andImageName:@"bolt" withFlushButton:NO], // Advanced tab
                                     nil];
  [self setViewControllers:viewControllers];

  self.locationManager = [[CLLocationManager alloc] init];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(requestLocationAuthorization)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(requestAppTrackingTransperancyAuthorization)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

- (void)requestLocationAuthorization {
  [self.locationManager requestAlwaysAuthorization];
}

- (void)requestAppTrackingTransperancyAuthorization {
  if (@available(iOS 14, *)) {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
      StopwatchDebugMsg(@"Got result from App Track Transparency popup %ld", (long)status);
    }];
  }
}

/* Helper methods for adding tab bar items to the root UITabBarController */

// Initializes and returns a ContainerViewController nested inside a UINavigationController
- (UINavigationController *)addNavigationControllerWithChildren:(NSArray *)childViewContainers andTitle:(NSString *)title andImageName:(NSString *)imageName withFlushButton:(BOOL)hasFlushButton {
  UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationController"];
  [(ContainerViewController *)navigationController.viewControllers[0] initWithArray:childViewContainers andTitle:title andImageName:imageName withFlushButton:hasFlushButton];
  navigationController.navigationBar.tintColor = [ColorUtils stopwatchBlueColor];

  return navigationController;
}

// Initializes and returns a UINavigationController wrapping a UIViewController with the given identifier
- (UINavigationController *)addNavigationControllerWithIdentifier:(NSString *)identifier withTitle:(NSString *)title andImageName:(NSString *)imageName {
  UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  navigationController.tabBarItem.title = title;
  navigationController.tabBarItem.image = [UIImage imageNamed:imageName];
  return navigationController;
}

@end
