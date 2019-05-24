#import "UserAttributesViewController.h"
#import <AppboyKit.h>
#import "UserCells.h"
#import "UIViewController+Keyboard.h"
#import "UserCustomAttribute.h"
#import "UserCustomAttributeCell.h"
#import "AlertControllerUtils.h"

static NSInteger const TextFieldTagNumber = 1000;
static NSInteger const TotalNumberOfAttributes = 12;
static NSInteger const IndexOfBirthday = 9;
static NSInteger const IndexOfPushSubscriptionState = 12;
static NSInteger const IndexOfEmailSubscriptionState = 13;
static NSMutableArray *attributesValuesArray = nil;

@interface UserAttributesViewController ()

@property (nonatomic, strong) NSMutableArray<UserCustomAttribute *> *userCustomAttributes;

@end

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
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.push-subscription", nil),
                                 NSLocalizedString(@"Appboy.Stopwatch.user-attributes.email-subscription", nil)];

  if (attributesValuesArray == nil || [attributesValuesArray count] <= 0) {
    attributesValuesArray = [NSMutableArray arrayWithCapacity:TotalNumberOfAttributes];
    for (int i = 0; i < TotalNumberOfAttributes; i ++) {
      [attributesValuesArray addObject:[NSNull null]];
    }
  }
  self.userCustomAttributes = [NSMutableArray array];
}

- (void)viewDidUnload {
  [self setAttributesTableView:nil];
  [self setModalNavBar:nil];
  [super viewDidUnload];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self.modalNavBar];
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

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Table view cells setup methods

- (UITableViewCell *)setupTableView:(UITableView *)tableView subscriptionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"subscription cell";
  
  UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
}

- (UITableViewCell *)setupTableView:(UITableView *)tableView textFieldCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"text field cell";
  
  UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

- (UITableViewCell *)setupTableView:(UITableView *)tableView customAttributeCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UserCustomAttributeCell *cell = (UserCustomAttributeCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomAttributeCell" forIndexPath:indexPath];
  UserCustomAttribute *attribute = self.userCustomAttributes[indexPath.row - 1];
  typeof(self) __weak weakSelf = self;
  [cell setUserCustomAttribute:attribute selectNextCellBlock:^(UITableViewCell *cell){
    NSIndexPath *indexPath = [weakSelf.attributesTableView indexPathForCell:cell];
    if (indexPath && (weakSelf.userCustomAttributes.count > indexPath.row)) {
      // we can pick next cell since it exists
      UserCustomAttributeCell *nextCell = [weakSelf.attributesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section]];
      [nextCell.keyTextField becomeFirstResponder];
    }
  } textFieldShouldBeginEditingBlock:^(UITableViewCell *cell) {
    NSIndexPath *indexPath = [weakSelf.attributesTableView indexPathForCell:cell];
    if (indexPath) {
      [weakSelf.attributesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
  }];
  return cell;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case 0: {
      // default user attributes
      if (indexPath.row == IndexOfPushSubscriptionState || indexPath.row == IndexOfEmailSubscriptionState) {
        // Cells with subscription state segmented control
        return [self setupTableView:tableView subscriptionCellForRowAtIndexPath:indexPath];
      } else {
        // Cell with text field
        return [self setupTableView:tableView textFieldCellForRowAtIndexPath:indexPath];
      }
    }
      
    case 1: {
      return [tableView dequeueReusableCellWithIdentifier:@"LocationAttributeCell" forIndexPath:indexPath];
    }
      
    case 2: {
      // custom user attributes
      if (indexPath.row == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"AddAttributeCell" forIndexPath:indexPath];
      } else {
        return [self setupTableView:tableView customAttributeCellForRowAtIndexPath:indexPath];
      }
    }
      
    default:
      return [UITableViewCell new];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      // default attributes
      return TotalNumberOfAttributes;
      
    case 1:
      // location custom attribute
      return 1;
      
    case 2:
      // 'add attribute' button + custom attributes
      return 1 + self.userCustomAttributes.count;
      
    default:
      return 0;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      // default attributes
      return NSLocalizedString(@"Default Attributes", @"");
      
    case 1:
      // 'location custom attribute' button
      return NSLocalizedString(@"Location Custom Attribute", @"");
      
    case 2:
      // 'add attribute' button + custom attributes
      return NSLocalizedString(@"Custom Attributes", @"");
      
    default:
      return @"";
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // we can remove custom attributes
  return (indexPath.section == 2 && indexPath.row > 0);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  [self.userCustomAttributes removeObjectAtIndex:(indexPath.row - 1)]; // since 0th row in the table view is button, not array element
  [self.attributesTableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSInteger nextTag = textField.tag + 1;
  // Try to find next responder
  UIResponder *nextResponder = [self.view viewWithTag:nextTag];
  [nextResponder becomeFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  // Scroll the table view to make the text field visible
  NSIndexPath *indexPath = [self indexPathFromTextFieldTag:textField.tag];
  [self.attributesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  // When it's the date of birth text field get edited, we don't want to save the text in text field
  // but the date object. Ignore the input of text filled here.
  if (textField.tag == IndexOfBirthday + TextFieldTagNumber) {
    return YES;
  }
  
  NSIndexPath *indexPath = [self indexPathFromTextFieldTag:textField.tag];
  if (textField.text.length > 0) {
    attributesValuesArray[indexPath.row] = textField.text;
  } else {
    attributesValuesArray[indexPath.row] = [NSNull null];
  }
  return YES;
}

#pragma mark - Buttons actions

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

- (IBAction)addCustomAttributeTapped:(id)sender {
  [self.userCustomAttributes addObject:[UserCustomAttribute new]];
  NSIndexPath *addedIndexPath = [NSIndexPath indexPathForRow:self.userCustomAttributes.count inSection:2];
  [self.attributesTableView insertRowsAtIndexPaths:@[ addedIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.attributesTableView scrollToRowAtIndexPath:addedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)locationCustomAttributeTapped:(id)sender {
  UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationCustomAttributeViewController"];
  [self.navigationController pushViewController:vc animated:YES];
  return;
}

// Set user attributes and/or change the current userId.  See Appboy.h for a discussion about changing the userId.
- (IBAction)doneButtonTapped:(id)sender {
  [self dismissKeyboard];

  [self showAttributesSetAlert];

  Appboy *appboyInstance = [Appboy sharedInstance];
  for (NSUInteger i = 0; i < TotalNumberOfAttributes; i ++) {
    id object = attributesValuesArray[i];
    if (object && object != [NSNull null]) {
      switch (i) {
        case 0:
          [appboyInstance changeUser:(NSString *)object];
          continue;

        case 1:
          appboyInstance.user.firstName = (NSString *)object;
          continue;

        case 2:
          appboyInstance.user.lastName = (NSString *)object;
          continue;

        case 3:
          appboyInstance.user.email = (NSString *)object;
          continue;

        case 4:
          appboyInstance.user.country = (NSString *)object;
          continue;

        case 5:
          appboyInstance.user.homeCity = (NSString *)object;
          continue;
          
        case 6:
          appboyInstance.user.language = (NSString *)object;
          continue;

        case 7: {
          [appboyInstance.user setGender:[self parseGenderFromString:(NSString *)object]];
          continue;
        }

        case 8:
          appboyInstance.user.phone = (NSString *)object;
          continue;

        case 9:
          appboyInstance.user.dateOfBirth = (NSDate *)object;
          continue;
          
        case 10: {
          [appboyInstance.user setPushNotificationSubscriptionType:[self getSubscriptionType:object]];
          continue;
        }
          
        case 11: {
          [appboyInstance.user setEmailNotificationSubscriptionType:[self getSubscriptionType:object]];
          continue;
        }

        default:
          break;
      }
    }
  }
  
  for (UserCustomAttribute *attribute in self.userCustomAttributes) {
    if (![attribute.attributeKey isEqualToString:@""] && ![attribute.attributeValue isEqualToString:@""]) {
      if ([self stringIsADouble:attribute.attributeValue]) {
        [appboyInstance.user setCustomAttributeWithKey:attribute.attributeKey
                                        andDoubleValue:[attribute.attributeValue doubleValue]];
      } else {
        [appboyInstance.user setCustomAttributeWithKey:attribute.attributeKey andStringValue:attribute.attributeValue];
      }
    }
  }
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
  CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  CGFloat keyboardHeight = MIN(keyboardSize.height, keyboardSize.width);
  self.attributesTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
  self.attributesTableView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - UI

- (void)showAttributesSetAlert {
  [AlertControllerUtils presentTemporaryAlertWithTitle:nil
                                                 message:NSLocalizedString(@"Appboy.Stopwatch.user-attributes.updated-message", nil)
                                            presentingVC:self];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

#pragma mark - Private methods

- (NSIndexPath *)indexPathFromTextFieldTag:(NSInteger)tag {
  return [NSIndexPath indexPathForRow:(tag - TextFieldTagNumber) inSection:0];
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

// Returns YES if it is a valid double. In the case where there are letters
// in the string, [string doubleValue] will return a valid number if it begins with
// a numeric character or "-"
- (BOOL)stringIsADouble:(NSString *)string {
  return [string doubleValue] != 0 || [string isEqualToString:@"0"];
}

@end
