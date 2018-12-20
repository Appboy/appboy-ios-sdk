#import "CustomTabBarController.h"
#import "ContainerViewController.h"
#import "ABKLocationManager.h"

@implementation CustomTabBarController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Add tab bar items to UITabBarController
  NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:
                                     [self addNavigationControllerWithChildren:@[@"Attributes", @"Arrays", @"Events", @"Alias"] andTitle:@"User" andImageName:@"user" withFlushButton:YES], // User tab
                                     [self addNavigationControllerWithChildren:@[@"UI", @"Controls"] andTitle:@"IAM" andImageName:@"IAM" withFlushButton:NO], // IAM tab
                                     [self addNavigationControllerWithIdentifier:@"FeedAndFeedbackViewController" withTitle:@"Braze UI" andImageName:@"newsfeed"], // UI tab
                                     [self addNavigationControllerWithChildren:@[@"Misc", @"PushStory", @"Data"] andTitle:@"Advanced" andImageName:@"bolt" withFlushButton:NO], // Advanced tab
                                     nil];
  [self setViewControllers:viewControllers];
  
  // Location Tracking: Let Braze request location permission on your behalf
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(requestLocationAuthorization)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)requestLocationAuthorization {
  [[Appboy sharedInstance].locationManager allowRequestAlwaysPermission];
}

/* Helper methods for adding tab bar items to the root UITabBarController */

// Initializes and returns a ContainerViewController nested inside a UINavigationController
- (UINavigationController *)addNavigationControllerWithChildren:(NSArray *)childViewContainers andTitle:(NSString *)title andImageName:(NSString *)imageName withFlushButton:(BOOL)hasFlushButton {
  UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationController"];
  [(ContainerViewController *)navigationController.viewControllers[0] initWithArray:childViewContainers andTitle:title andImageName:imageName withFlushButton:hasFlushButton];
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
