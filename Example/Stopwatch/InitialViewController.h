//
//  InitialViewController.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clock.h"
#import "AppboyKit.h"

@interface InitialViewController : UIViewController
    <ABKFeedbackViewControllerPopoverContextDelegate,
    ABKFeedViewControllerPopoverContextDelegate,
    UIPopoverControllerDelegate,
    UIAlertViewDelegate,
    ClockDelegate>

- (IBAction) resetButtonTapped:(id)sender;
- (IBAction) startButtonTapped:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

// iPad only
@property (retain, nonatomic) IBOutlet UIBarButtonItem *contactUsButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *latestNewsButton;
- (IBAction) contactUsButtonTapped:(id)sender;
- (IBAction) latestNewsButtonTapped:(id)sender;

@end
