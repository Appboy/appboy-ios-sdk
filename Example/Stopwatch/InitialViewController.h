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
    ABKFeedbackViewControllerNavigationContextDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *UpgradeButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *facebookButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *twitterButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *newsAndFeedbackButton;
@property (retain, nonatomic) IBOutlet UINavigationController *newsAndFeedbackNavigationController;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *contactUsButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *latestNewsButton;


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
