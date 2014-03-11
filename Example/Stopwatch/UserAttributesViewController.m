#import "UserAttributesViewController.h"
#import "AppboyKit.h"
#import "UserAttributeCell.h"
#import "Crittercism.h"

static NSInteger const TextFieldTagNumber = 1000;
static NSInteger const TotalNumberOfAttributes = 11;
static NSInteger const IndexOfGender = 7;
static NSInteger const IndexOfBirthday = 9;
static NSMutableArray *attributesValuesArray = nil;

@implementation UserAttributesViewController


- (void) viewDidLoad {
  [super viewDidLoad];

  self.attributesLabelsArray = [NSArray arrayWithObjects:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.user-ID", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.first-name", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.last-name", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.email", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.country", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.home-city", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.bio", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.gender", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.phone", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.date-of-birth", nil),
                                                         NSLocalizedString(@"Appboy.Stopwatch.user-attributes.favorite-color", nil), nil];

  if (attributesValuesArray == nil || [attributesValuesArray count] <= 0) {
    attributesValuesArray = [[NSMutableArray arrayWithCapacity:TotalNumberOfAttributes] retain];
    for (int i = 0; i < TotalNumberOfAttributes; i ++) {
      [attributesValuesArray addObject:[NSNull null]];
    }
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    // in iOS 7, views are automatically extended to full screen mode, under the navigation bar etc. For our feedback,
    // we don't want the view to under any other UI in all cases, so we need to turn it off in iOS 7
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

#pragma Table View Data Source Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Cell with gender segmented control
  if (indexPath.row == IndexOfGender) {
    static NSString *CellIdentifier = @"gender cell";

    UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
      cell = [[[UserAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id object = [attributesValuesArray objectAtIndex:(NSUInteger)indexPath.row];
    if ([object isKindOfClass:[NSString class]] && ((NSString *)object).length == 1) {
      if ([(NSString *)object isEqualToString:@"m"]) {
        cell.attributeSegmentedControl.selectedSegmentIndex = 0;
      } else if ([(NSString *)object isEqualToString:@"f"]) {
        cell.attributeSegmentedControl.selectedSegmentIndex = 1;
      }
    }
    return cell;

  }
  else {
    // Cell with text field
    static NSString *CellIdentifier = @"text field cell";

    UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UserAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.attributeNameLabel.text = [self.attributesLabelsArray objectAtIndex:(NSUInteger)indexPath.row];

    cell.attributeTextField.tag = TextFieldTagNumber + indexPath.row; // The text field's tag is 1000 plus the row number
    id object = [attributesValuesArray objectAtIndex:(NSUInteger)indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
      cell.attributeTextField.text = (NSString *)object;
    }
    else if ([object isKindOfClass:[NSDate class]]) {
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
- (BOOL) textFieldShouldReturn:(UITextField *)textField {

  NSInteger nextTag = textField.tag + 1;
  // Try to find next responder
  UIResponder* nextResponder = [self.view viewWithTag:nextTag];
  if (nextResponder) {
    // Found next responder, so set it.
    [nextResponder becomeFirstResponder];
  }
  return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
  // keep track of the current editing text field, so we can save the value of the last text field
  // user edited right before he/she click the "Done" button
  self.currentEditingTextField = textField;

  // Scroll the table view to make the text field visible
  NSIndexPath *index = [NSIndexPath indexPathForRow:textField.tag - TextFieldTagNumber inSection:0];
  [self.attributesTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];

  // If it is the text field for birthday, change the keyboard to date picker
  if (textField.tag == IndexOfBirthday + TextFieldTagNumber) {
    UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
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

- (NSString *) getBirthdayStringFromDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSString *dateString = [dateFormatter stringFromDate:date];
  [dateFormatter release];
  return dateString;
}

- (NSDate *) getDateFromBirthdayString:(NSString *)birthdayString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSDate *date = [dateFormatter dateFromString:birthdayString];
  [dateFormatter release];
  return date;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  // Save the input of text field, including the cases of valid text and empty input
  if (textField.text.length > 0) {
    [attributesValuesArray replaceObjectAtIndex:(NSUInteger)textField.tag - TextFieldTagNumber withObject:textField.text];
  }
  else {
    [attributesValuesArray replaceObjectAtIndex:(NSUInteger)textField.tag - TextFieldTagNumber withObject:[NSNull null]];
  }
  return YES;
}

- (void) datePickerValueChanged:(UIDatePicker *)sender {
  // Save the date value
  [attributesValuesArray replaceObjectAtIndex:IndexOfBirthday withObject:sender.date];

  // Display the date value in the text field while user changing the date picker
  ((UITextField *)[self.view viewWithTag:IndexOfBirthday + TextFieldTagNumber]).text = [self getBirthdayStringFromDate:sender.date];
}

- (IBAction) setGender:(UISegmentedControl *)sender {
  NSString *gender = sender.selectedSegmentIndex == 0 ? @"m" : @"f";
  [attributesValuesArray replaceObjectAtIndex:IndexOfGender withObject:gender];
}

// Set user attributes and/or change the current userID.  See Appboy.h for a discussion about changing the userID.
- (IBAction) doneButtonTapped:(id)sender {
  if (self.currentEditingTextField && self.currentEditingTextField.tag != IndexOfBirthday + TextFieldTagNumber) {
    if (self.currentEditingTextField.text.length > 0) {
      [attributesValuesArray replaceObjectAtIndex:(NSUInteger)self.currentEditingTextField.tag - TextFieldTagNumber
                                       withObject:self.currentEditingTextField.text];
    }
    else {
      [attributesValuesArray replaceObjectAtIndex:(NSUInteger)self.currentEditingTextField.tag - TextFieldTagNumber
                                       withObject:[NSNull null]];
    }
  }

  [Crittercism leaveBreadcrumb:@"update appboy user's attributes"];

  UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil
                                                      message:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.updated-message", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil] autorelease];
  [alertView show];
  
  [self dismissModalViewControllerAnimated:YES];

  for (NSUInteger i = 0; i < TotalNumberOfAttributes; i ++) {
    id object = [attributesValuesArray objectAtIndex:i];
    if (object && object != [NSNull null]) {
      switch (i) {
        case 0:
          [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"change appboy user to %@", object]];
          [[Appboy sharedInstance] changeUser:(NSString *)object];
          continue;

        case 1:
          [Appboy sharedInstance].user.firstName = (NSString *)object;
          continue;

        case 2:
          [Appboy sharedInstance].user.lastName = (NSString *)object;
          continue;

        case 3:
          [Crittercism setUsername:[Appboy sharedInstance].user.email];
          [Appboy sharedInstance].user.email = (NSString *)object;
          continue;

        case 4:
          [Appboy sharedInstance].user.country = (NSString *)object;
          continue;

        case 5:
          [Appboy sharedInstance].user.homeCity = (NSString *)object;
          continue;

        case 6:
          [Appboy sharedInstance].user.bio = (NSString *)object;
          continue;

        case 7:{
          BOOL genderIsMale = [(NSString *)object isEqualToString:@"m"];
          ABKUserGenderType userGender = genderIsMale ? ABKUserGenderMale : ABKUserGenderFemale;
          [[Appboy sharedInstance].user setGender:userGender];
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

        default:
          break;
      }
    }
  }
}

- (void) keyboardDidShow:(NSNotification *)notification {

  NSDictionary* info = [notification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

  CGRect aRect = self.attributesTableView.frame;
  aRect.size.height = self.view.frame.size.height - kbSize.height - 44; // 44 is the height of the navigation bar
  self.attributesTableView.frame = aRect;

}

- (void) viewDidUnload {
  [self setAttributesTableView:nil];
  [self setModalNavBar:nil];
  [super viewDidUnload];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self.modalNavBar];
  [_attributesLabelsArray release];
  [_attributesTableView release];
  [_modalNavBar release];
  [super dealloc];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
