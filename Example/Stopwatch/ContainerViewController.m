#import "ContainerViewController.h"

@implementation ContainerViewController

/**
 @param segmentIndexToViewControllerId  An array where indices represent UISegmentedControl segment indices and values are the child UIViewController storyboard restoration IDs (NSString*) associated with that segment index. Restoration IDs also double as UISegmentedControl titles for a given segment.
 @param title The UITabBarItem title for this tab in the root UITabBarController
 @param imageName The image filename associated with the UITabBarItem image for this tab
 @param withFlushButton A boolean for whether this ContainerViewController will have a Data Flush UIBarButtonItem in the UINavigationBar
 */
- (void)initWithArray:(NSArray *)segmentIndexToViewControllerId andTitle:(NSString *)title andImageName:(NSString *)imageName withFlushButton:(BOOL)hasFlushButton {
  self.segmentIndexToViewControllerId = segmentIndexToViewControllerId;
  self.hasFlushButton = hasFlushButton;
  
  self.tabBarItem.title = title;
  self.tabBarItem.image = [UIImage imageNamed:imageName];
  
  // Initialize UISegmentedControl
  self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentIndexToViewControllerId];
  [self.segmentedControl addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];
  [self.segmentedControl setSelectedSegmentIndex:0];
}

- (void)viewDidLoad {
  [self.navigationItem setTitleView:self.segmentedControl];
  [self displayViewForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]];
  
  // Add Flush navigation bar item
  if (self.hasFlushButton) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"appboy"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                             action:@selector(flushDataToAppboy:)];
  }
}

- (void)viewDidLayoutSubviews{
  /* Ensures that the child view controller has the correct frame and shows up correctly in the
   * container view. This call is in `viewDidLayoutSubviews` as opposed to `viewDidLoad` to handle the 
   * edge case where the phone is rotated and then the user switches to a tab that has been previously 
   * loaded. In this case, `viewDidLoad` is not called again, and the frames are not redrawn for the new 
   * orientation. */
  if (!CGRectEqualToRect(self.currentViewController.view.frame, self.containerView.frame)) {
    self.currentViewController.view.frame = self.containerView.frame;
  }
}

- (void)instantiateChildViewControllers{
  NSInteger numberOfChildViews = [self.segmentIndexToViewControllerId count];
  self.childViewControllers = [NSMutableArray arrayWithCapacity:numberOfChildViews];
  for (int i = 0; i < numberOfChildViews; i++) {
    self.childViewControllers[i] = [self.storyboard instantiateViewControllerWithIdentifier:self.segmentIndexToViewControllerId[i]];
  }
}

- (void)displayViewForSegmentAtIndex:(NSUInteger)index {
  if (self.childViewControllers == nil || [self.childViewControllers count] == 0) {
    [self instantiateChildViewControllers];
  }
  
  // Get view controller to be displayed
  UIViewController *newViewController = self.childViewControllers[index];
  
  if (newViewController) {
    // Set the frame size of the child view to the frame of its container
    newViewController.view.frame = self.containerView.frame;
    
    [self addChildViewController:newViewController];
    [self.containerView addSubview:newViewController.view];
    
    [newViewController didMoveToParentViewController:self];
    self.currentViewController = newViewController;
  }
}

- (IBAction)changeViewController:(id)sender {
  // Handle removal of old view controller
  [self.currentViewController willMoveToParentViewController:nil];
  [self.currentViewController.view removeFromSuperview];
  [self.currentViewController removeFromParentViewController];
  
  // Display new view controller
  [self displayViewForSegmentAtIndex:[sender selectedSegmentIndex]];
}

- (IBAction)flushDataToAppboy:(id)sender {
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
}

@end
