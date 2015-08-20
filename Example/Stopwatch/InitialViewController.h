#import <UIKit/UIKit.h>
#import "Clock.h"
#import <AppboyKit.h>
#import "Crittercism.h"
#import <CoreLocation/CoreLocation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface InitialViewController : UIViewController
    <ABKFeedbackViewControllerPopoverContextDelegate,
    ABKFeedViewControllerPopoverContextDelegate,
    ABKFeedbackViewControllerModalContextDelegate,
    UISplitViewControllerDelegate, CrittercismDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate>

@property IBOutlet UIButton *startButton;
@property IBOutlet UILabel *timeLabel;
@property IBOutlet UIBarButtonItem *UpgradeButton;
@property IBOutlet UIBarButtonItem *facebookButton;
@property IBOutlet UIBarButtonItem *twitterButton;
@property IBOutlet UIBarButtonItem *newsAndFeedbackButton;
@property IBOutlet UINavigationController *newsAndFeedbackNavigationController;
@property IBOutlet UIBarButtonItem *contactUsButton;
@property IBOutlet UIBarButtonItem *latestNewsButton;


- (IBAction) resetButtonTapped:(id)sender;
- (IBAction) startButtonTapped:(id)sender;

- (IBAction) latestNewsButtonTappediPad:(id)sender;
- (IBAction) contactUsButtonTappediPad:(id)sender;
- (IBAction) contactUsButtonTappediPhone:(id)sender;
- (IBAction) newsAndFeedbackButtonTapped:(id)sender;

- (IBAction) purchaseButtonTapped:(id)sender;
- (IBAction) facebookButtonTapped:(id)sender;
- (IBAction) twitterButtonTapped:(id)sender;

@end
