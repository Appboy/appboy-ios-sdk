//
//  UserAttributesViewController.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "UserAttributesViewController.h"
#import "AppboyKit.h"

@implementation UserAttributesViewController

- (void) loadView {
  NSArray *nibArray;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    (nibArray = [[NSBundle mainBundle] loadNibNamed:@"UserAttributesViewController_iPad" owner:self options:nil]);
  }
  else {
    (nibArray = [[NSBundle mainBundle] loadNibNamed:@"UserAttributesViewController" owner:self options:nil]);

    // Shrink the gender segmented control down a little...
    CGRect aFrame = self.genderButton.frame;
    aFrame.size.height = 30;
    self.genderButton.frame = aFrame;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [self.genderButton setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
  }
  if (nibArray) {
    self.view = [nibArray objectAtIndex:0];
  }
  else {
    NSLog(@"Could not load nib");
  }
}

// Set user attributes and/or change the current userID.  See Appboy.h for a discussion about changing the userID.
- (IBAction) doneButtonTapped:(id)sender {
  [self dismissModalViewControllerAnimated:YES];

  [Appboy sharedInstance].user.firstName = self.firstNameTextField.text;
  [Appboy sharedInstance].user.lastName = self.lastNameTextField.text;
  [Appboy sharedInstance].user.homeCity = self.homeCityTextField.text;
  [Appboy sharedInstance].user.country = self.countryTextField.text;
  [Appboy sharedInstance].user.email = self.emailTextField.text;
  [Appboy sharedInstance].user.bio = self.bioTextField.text;
  [Appboy sharedInstance].user.phone = self.phoneTextField.text;

  [[Appboy sharedInstance].user setEmail:self.emailTextField.text];

  if (self.genderButton.selectedSegmentIndex == 0) {
    [[Appboy sharedInstance].user setGender:ABKUserGenderMale];
  }
  else {
    [[Appboy sharedInstance].user setGender:ABKUserGenderFemale];
  }

  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  dateFormatter.dateFormat = @"mm-dd-yyyy";
  NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@",
                                                    self.monthTextField.text, self.dayTextField.text, self.yearTextField.text];
  NSDate *date = [dateFormatter dateFromString:dateString];
  [Appboy sharedInstance].user.dateOfBirth = date;

  if (self.userIDTextField.text.length != 0) {
    [[Appboy sharedInstance] changeUser:self.userIDTextField.text];
  }

  UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"User Attributes Set"
                                                      delegate:nil cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil] autorelease];
  [alertView show];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void) viewDidLoad {
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void) keyboardDidShow:(NSNotification *)notification {

  NSDictionary *info = [notification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

  CGSize origContentSize = self.scrollView.frame.size;
  self.scrollView.contentSize = (CGSize) {origContentSize.width, origContentSize.height + kbSize.height};
  [self.scrollView setContentOffset:(CGPoint) {0, kbSize.height} animated:YES];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  [_firstNameTextField release];
  [_lastNameTextField release];
  [_homeCityTextField release];
  [_countryTextField release];
  [_emailTextField release];
  [_bioTextField release];
  [_phoneTextField release];
  [_userIDTextField release];
  [_monthTextField release];
  [_dayTextField release];
  [_yearTextField release];
  [_scrollView release];
  [_genderButton release];
  [super dealloc];
}

- (void) viewDidUnload {
  [self setFirstNameTextField:nil];
  [self setLastNameTextField:nil];
  [self setHomeCityTextField:nil];
  [self setEmailTextField:nil];
  [self setCountryTextField:nil];
  [self setBioTextField:nil];
  [self setPhoneTextField:nil];
  [self setUserIDTextField:nil];
  [self setMonthTextField:nil];
  [self setDayTextField:nil];
  [self setYearTextField:nil];
  [self setScrollView:nil];
  [self setGenderButton:nil];
  [super viewDidUnload];
}

@end
