//
//  TestingViewController.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestingViewController : UIViewController

- (IBAction) enableAppboySwitchChanged:(id)sender;
- (IBAction)ratingStepperChanged:(UIStepper *)sender;
@property (retain, nonatomic) IBOutlet UILabel *ratedScoreLabel;
@property (retain, nonatomic) IBOutlet UISwitch *enableAppboySwitch;
@property (retain, nonatomic) IBOutlet UILabel *unreadCardLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalCardsLabel;
@end
