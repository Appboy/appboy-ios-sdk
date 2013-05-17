//
//  InfoViewController.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppboyKit.h"

@interface InfoViewController : UIViewController <ABKFeedbackViewControllerModalContextDelegate, UIAlertViewDelegate>

- (IBAction) talkToUsButtonTapped:(id)sender;
- (IBAction) twitterButtonTapped:(id)sender;
- (IBAction) facebookButtonTapped:(id)sender;
- (IBAction) buyStopwatchProTapped:(id)sender;
@end
