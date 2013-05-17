//
//  UserAttributesViewController.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAttributesViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *userIDTextField;
@property (retain, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *homeCityTextField;
@property (retain, nonatomic) IBOutlet UITextField *countryTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *bioTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *monthTextField;
@property (retain, nonatomic) IBOutlet UITextField *dayTextField;
@property (retain, nonatomic) IBOutlet UITextField *yearTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *genderButton;
- (IBAction) doneButtonTapped:(id)sender;
@end
