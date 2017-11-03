#import "CustomTabBarController.h"
#import "ContainerViewController.h"
#import "ABKLocationManager.h"

@implementation CustomTabBarController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Add tab bar items to UITabBarController
  NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:
                                     [self addNavigationControllerWithChildren:@[@"Attributes", @"Arrays", @"Events", @"Alias"] andTitle:@"User" andImageName:@"user" withFeedAndFlushButtons:YES], // User tab
                                     [self addNavigationControllerWithChildren:@[@"UI", @"Controls"] andTitle:@"IAM" andImageName:@"IAM" withFeedAndFlushButtons:NO], // IAM tab
                                     [self addNavigationControllerWithIdentifier:@"FeedAndFeedbackViewController" withTitle:@"Feed/Feedback" andImageName:@"newsfeed"], // Feed/Feedback tab
                                     [self addNavigationControllerWithChildren:@[@"Misc", @"PushStory"] andTitle:@"Advanced" andImageName:@"bolt" withFeedAndFlushButtons:NO], // Advanced tab
                                     nil];
  [self setViewControllers:viewControllers];
  
  // Location Tracking: Let Appboy request location permission on your behalf
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
- (UINavigationController *)addNavigationControllerWithChildren:(NSArray *)childViewContainers andTitle:(NSString *)title andImageName:(NSString *)imageName withFeedAndFlushButtons:(BOOL)hasButtons {
  UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationController"];
  [(ContainerViewController *)navigationController.viewControllers[0] initWithArray:childViewContainers andTitle:title andImageName:imageName withFeedAndFlushButtons:hasButtons];
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
