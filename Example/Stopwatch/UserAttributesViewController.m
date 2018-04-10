#import "UserAttributesViewController.h"
#import <AppboyKit.h>
#import "UserCells.h"
#import "UIViewController+Keyboard.h"

static NSInteger const TextFieldTagNumber = 1000;
static NSInteger const TotalNumberOfAttributes = 14;
static NSInteger const IndexOfBirthday = 9;
static NSInteger const IndexOfPushSubscriptionState = 12;
static NSInteger const IndexOfEmailSubscriptionState = 13;
static NSMutableArray *attributesValuesArray = nil;

@implementation UserAttributesViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.attributesLabelsArray = @[NSLocalizedString(@"Appboy.Stopwatch.user-attributes.user-ID", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.first-name", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.last-name", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.email", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.country", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.home-city", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.language", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.gender", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.phone", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.date-of-birth", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.favorite-color", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.favorite-food", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.push-subscription", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.email-subscription", nil)];

  if (attributesValuesArray == nil || [attributesValuesArray count] <= 0) {
    attributesValuesArray = [NSMutableArray arrayWithCapacity:TotalNumberOfAttributes];
    for (int i = 0; i < TotalNumberOfAttributes; i ++) {
      [attributesValuesArray addObject:[NSNull null]];
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  // Pull current, locally-stored user ID every time user navigates to this page
  NSString *appboyUserId = [Appboy sharedInstance].user.userID;
  if (appboyUserId != nil) {
    self.userId = appboyUserId;
    attributesValuesArray[0] = self.userId;
    [self.attributesTableView reloadData];
  }
}

#pragma Table View Data Source Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Cells with subscription state segmented control
  if (indexPath.row == IndexOfPushSubscriptionState || indexPath.row == IndexOfEmailSubscriptionState) {
    NSString *cellIdentifier = @"subscription cell";
    
    UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
      cell = [[UserAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.attributeNameLabel.text = self.attributesLabelsArray[(NSUInteger)indexPath.row];
    [cell.attributeSegmentedControl setTag:(TextFieldTagNumber + indexPath.row)]; // Segmented control's tag is 1000 + row number
    
    id object = attributesValuesArray[(NSUInteger)indexPath.row];
    if ([object isKindOfClass:[NSString class]] && ((NSString *)object).length == 1) {
      if ([(NSString *)object isEqualToString:@"u"]) {
        cell.attributeSegmentedControl.selectedSegmentIndex = 0;
      } else if ([(NSString *)object isEqualToString:@"s"]) {
        cell.attributeSegmentedControl.selectedSegmentIndex = 1;
      } else {
        cell.attributeSegmentedControl.selectedSegmentIndex = 2;
      }
    }
    return cell;
  } else {
    // Cell with text field
    static NSString *CellIdentifier = @"text field cell";

    UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[UserAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.attributeNameLabel.text = self.attributesLabelsArray[(NSUInteger)indexPath.row];
    
    // Keyboard typing
    cell.attributeTextField.inputView = nil;
    if ([cell.attributeNameLabel.text isEqualToString:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.email", nil)]) {
      // Email keyboard
      cell.attributeTextField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if ([cell.attributeNameLabel.text isEqualToString:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.phone", nil)]) {
      // Phone keyboard
      cell.attributeTextField.keyboardType = UIKeyboardTypePhonePad;
    } else {
      cell.attributeTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    // Preview text
    if ([cell.attributeNameLabel.text isEqualToString:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.gender", nil)]) {
      cell.attributeTextField.placeholder = @"Enter 'm', 'f', 'u', 'o', 'n', or 'p'";
    } else {
      cell.attributeTextField.placeholder = @"";
    }

    cell.attributeTextField.tag = TextFieldTagNumber + indexPath.row; // The text field's tag is 1000 plus the row number
    id object = attributesValuesArray[(NSUInteger)indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
      cell.attributeTextField.text = (NSString *)object;
    } else if ([object isKindOfClass:[NSDate class]]) {
      cell.attributeTextField.text = [self getBirthdayStringFromDate:(NSDate *)object];
    } else {
      cell.attributeTextField.text = nil;
    }

    return cell;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return TotalNumberOfAttributes;
}

#pragma Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  NSInteger nextTag = textField.tag + 1;
  // Try to find next responder
  UIResponder *nextResponder = [self.view viewWithTag:nextTag];
  if (nextResponder) {
    // Found next responder, so set it.
    [nextResponder becomeFirstResponder];
  }
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  // keep track of the current editing text field, so we can save the value of the last text field
  // user edited right before he/she click the "Done" button
  self.currentEditingTextField = textField;

  // Scroll the table view to make the text field visible
  NSIndexPath *index = [NSIndexPath indexPathForRow:textField.tag - TextFieldTagNumber inSection:0];
  [self.attributesTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];

  // If it is the text field for birthday, change the keyboard to date picker
  if (textField.tag == IndexOfBirthday + TextFieldTagNumber) {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor clearColor];
    textField.inputView = datePicker;
    if (textField.text && textField.text.length > 0) {
      datePicker.date = [self getDateFromBirthdayString:textField.text];
    } else {
      textField.text = [self getBirthdayStringFromDate:datePicker.date];
    }
  }

  return YES;
}

- (NSString *)getBirthdayStringFromDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSString *dateString = [dateFormatter stringFromDate:date];
  return dateString;
}

- (NSDate *)getDateFromBirthdayString:(NSString *)birthdayString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSDate *date = [dateFormatter dateFromString:birthdayString];
  return date;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  // When it's the date of birth text field get edited, we don't want to save the text in text field
  // but the date object. Ignore the input of text filed here.
  if (textField.tag == IndexOfBirthday + TextFieldTagNumber) {
    return YES;
  }
  // Save the input of text field, including the cases of valid text and empty input
  if (textField.text.length > 0) {
    attributesValuesArray[(NSUInteger)textField.tag - TextFieldTagNumber] = textField.text;
  }
  else {
    attributesValuesArray[(NSUInteger)textField.tag - TextFieldTagNumber] = [NSNull null];
  }
  return YES;
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
  // Save the date value
  attributesValuesArray[IndexOfBirthday] = sender.date;

  // Display the date value in the text field while user changing the date picker
  ((UITextField *)[self.view viewWithTag:IndexOfBirthday + TextFieldTagNumber]).text = [self getBirthdayStringFromDate:sender.date];
}

- (IBAction)setSubscriptionState:(UISegmentedControl *)sender {
  [self dismissKeyboard];
  NSString *subscriptionState;
  if (sender.selectedSegmentIndex == 0) {
    subscriptionState = @"u"; // unsubscribed
  } else if (sender.selectedSegmentIndex == 1) {
    subscriptionState = @"s"; // subscribed
  } else {
    subscriptionState = @"o"; // opted-in
  }

  attributesValuesArray[sender.tag - TextFieldTagNumber] = subscriptionState;
}

// Set user attributes and/or change the current userId.  See Appboy.h for a discussion about changing the userId.
- (IBAction)doneButtonTapped:(id)sender {
  [self dismissKeyboard];
  if (self.currentEditingTextField && self.currentEditingTextField.tag != IndexOfBirthday + TextFieldTagNumber) {
    if (self.currentEditingTextField.text.length > 0) {
      attributesValuesArray[(NSUInteger)self.currentEditingTextField.tag - TextFieldTagNumber] = self.currentEditingTextField.text;
    }
    else {
      attributesValuesArray[(NSUInteger)self.currentEditingTextField.tag - TextFieldTagNumber] = [NSNull null];
    }
  }

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.updated-message", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  alertView = nil;
  
  [self dismissViewControllerAnimated:YES completion:nil];

  for (NSUInteger i = 0; i < TotalNumberOfAttributes; i ++) {
    id object = attributesValuesArray[i];
    if (object && object != [NSNull null]) {
      switch (i) {
        case 0:
          [[Appboy sharedInstance] changeUser:(NSString *)object];
          continue;

        case 1:
          [Appboy sharedInstance].user.firstName = (NSString *)object;
          continue;

        case 2:
          [Appboy sharedInstance].user.lastName = (NSString *)object;
          continue;

        case 3:
          [Appboy sharedInstance].user.email = (NSString *)object;
          continue;

        case 4:
          [Appboy sharedInstance].user.country = (NSString *)object;
          continue;

        case 5:
          [Appboy sharedInstance].user.homeCity = (NSString *)object;
          continue;
          
        case 6:
          [Appboy sharedInstance].user.language = (NSString *)object;
          continue;

        case 7: {
          [[Appboy sharedInstance].user setGender:[self parseGenderFromString:(NSString *)object]];
          continue;
        }

        case 8:
          [Appboy sharedInstance].user.phone = (NSString *)object;
          continue;

        case 9:
          [Appboy sharedInstance].user.dateOfBirth = (NSDate *)object;
          continue;

        case 10:
          [[Appboy sharedInstance].user setCustomAttributeWithKey:@"favorite_color" andStringValue:(NSString *)object];
          continue;
          
        case 11:
          [[Appboy sharedInstance].user setCustomAttributeWithKey:@"favorite_food" andStringValue:(NSString *)object];
          continue;
          
        case 12: {
          [[Appboy sharedInstance].user setPushNotificationSubscriptionType:[self getSubscriptionType:object]];
          continue;
        }
          
        case 13: {
          [[Appboy sharedInstance].user setEmailNotificationSubscriptionType:[self getSubscriptionType:object]];
          continue;
        }

        default:
          break;
      }
    }
  }
}

- (ABKUserGenderType)parseGenderFromString:(NSString *)string {
  NSString *lowercaseString = [string lowercaseString];
  ABKUserGenderType gender;
  if ([lowercaseString isEqualToString:@"m"]) {
    gender = ABKUserGenderMale;
  } else if ([lowercaseString isEqualToString:@"f"]) {
    gender = ABKUserGenderFemale;
  } else if ([lowercaseString isEqualToString:@"o"]) {
    gender = ABKUserGenderOther;
  } else if ([lowercaseString isEqualToString:@"u"]) {
    gender = ABKUserGenderUnknown;
  } else if ([lowercaseString isEqualToString:@"n"]) {
    gender = ABKUserGenderNotApplicable;
  } else if ([lowercaseString isEqualToString:@"p"]) {
    gender = ABKUserGenderPreferNotToSay;
  } else {
    gender = ABKUserGenderUnknown;
  }
  return gender;
}

- (ABKNotificationSubscriptionType)getSubscriptionType:(id)object {
  NSString *subscriptionValue = (NSString*)object;
  ABKNotificationSubscriptionType subscriptionType;
  if ([subscriptionValue isEqualToString:@"u"]) {
    subscriptionType = ABKUnsubscribed;
  } else if ([subscriptionValue isEqualToString:@"s"]) {
    subscriptionType = ABKSubscribed;
  } else {
    subscriptionType = ABKOptedIn;
  }
  return subscriptionType;
}

- (void)keyboardDidShow:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  CGFloat keyboardHeight = keyboardSize.height < keyboardSize.width ? keyboardSize.height : keyboardSize.width;
  CGRect aRect = self.attributesTableView.frame;
  aRect.size.height = self.view.bounds.size.height - keyboardHeight;
  self.attributesTableView.frame = aRect;
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self.attributesTableView setNeedsUpdateConstraints];
}

- (void)viewDidUnload {
  [self setAttributesTableView:nil];
  [self setModalNavBar:nil];
  [super viewDidUnload];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self.modalNavBar];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
