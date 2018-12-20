#import <UIKit/UIKit.h>
#import <AppboyKit.h>

/**
 * ContainerViewController is a custom container view controller that switches child views based on the
 * `selectedSegmentIndex` of a UISegmentedControl in the navigation item's `titleView`. See the Apple
 * Developer documentation for creating a custom container view controller:
 * https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html
 */

@interface ContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIViewController *currentViewController;
@property UISegmentedControl *segmentedControl;
@property BOOL hasFlushButton;
@property NSMutableArray *childViewControllers;
@property NSArray *segmentIndexToViewControllerId;

// This method fills in the data for switching between child view controllers and must be called before the view controller is presented
- (void)initWithArray:(NSArray *)segmentIndexToViewControllerId andTitle:(NSString *)title andImageName:(NSString *)imageName withFlushButton:(BOOL)hasFlushButton;

// Displays view controller for the selected segment index
- (void)displayViewForSegmentAtIndex:(NSUInteger)index;

// Switches between children view controllers
- (IBAction)changeViewController:(id)sender;

// Manually flush data to Braze
- (IBAction)flushDataToAppboy:(id)sender;

@end
