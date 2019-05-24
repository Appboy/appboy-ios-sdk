#import "EventsViewController.h"
#import <AppboyKit.h>
#import "AlertControllerUtils.h"
#import "UserCells.h"

/*
 * We use the number 44 here because the height of a table view cell is 44.
 */
static const int TableViewTopY = 44;

@implementation EventsViewController

static NSString *const LogEvent = @"Log Custom Event";
static NSString *const LogPurchase = @"Log Purchase";
static NSString *const EventSwitch = @"Event Property";
static NSString *const PurchaseSwitch = @"Purchase Property";
static NSString *const Name = @"Event Name";
static NSString *const ProductId = @"Product ID";
static NSString *const CurrencyCode = @"Currency Code";
static NSString *const Price = @"Price";
static NSString *const Quantity = @"Quantity";
static NSString *const EventPropertyKey = @"Event Key";
static NSString *const EventPropertyValue = @"Event Value";
static NSString *const PurchasePropertyKey = @"Purchase Key";
static NSString *const PurchasePropertyValue = @"Purchase Value";
static NSString *const CustomEventPropertyType = @"Custom Event Property Type";
static NSString *const PurchasePropertyType = @"Purchase Property Type";
static NSString *const ButtonCell = @"button cell";
static NSString *const TextFieldCell = @"text field cell";
static NSString *const SegmentedControlCell = @"segmented control cell";
static NSString *const SwitchCell = @"switch cell";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.eventPropertyType = 0;
  self.purchasePropertyType = 0;
  
  self.labelsArraySection1 = [NSMutableArray arrayWithArray:@[Name,
                                                              EventSwitch,
                                                              LogEvent]];
  
  self.labelsArraySection2 = [NSMutableArray arrayWithArray:@[ProductId,
                                                              CurrencyCode,
                                                              Price,
                                                              Quantity,
                                                              PurchaseSwitch,
                                                              LogPurchase]];
  
  self.valuesDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                          Name : @"",
                                                                          EventSwitch : @(NO),
                                                                          ProductId : @"",
                                                                          CurrencyCode : @"USD",
                                                                          Price: @"5",
                                                                          Quantity : @"1",
                                                                          PurchaseSwitch : @(NO),
                                                                          EventPropertyKey : @"",
                                                                          EventPropertyValue : @"",
                                                                          PurchasePropertyKey : @"",
                                                                          PurchasePropertyValue : @""
                                                                          }];
}

- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  CGFloat keyboardHeight = keyboardSize.height < keyboardSize.width ? keyboardSize.height : keyboardSize.width;
  CGRect aRect = self.tableView.frame;
  aRect.size.height = self.view.bounds.size.height - keyboardHeight + TableViewTopY;
  self.tableView.frame = aRect;
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self.tableView setNeedsUpdateConstraints];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *label = [self labelForIndexPath:indexPath];
  NSInteger row = indexPath.row;
  UITableViewCell *cell = nil;
  if ([label isEqualToString:LogEvent] || [label isEqualToString:LogPurchase]) {
    // EventButtonCell
    cell = [self createCellWithIdentifier:ButtonCell withClass:[EventButtonCell class]];
    EventButtonCell *buttonCell = (EventButtonCell *)cell;
    [buttonCell.eventButton setTitle:label forState:UIControlStateNormal];
  } else if ([label isEqualToString:Name]
             || [label isEqualToString:ProductId]
             || [label isEqualToString:CurrencyCode]
             || [label isEqualToString:Price]
             || [label isEqualToString:Quantity]
             || [label isEqualToString:EventPropertyKey]
             || [label isEqualToString:EventPropertyValue]
             || [label isEqualToString:PurchasePropertyKey]
             || [label isEqualToString:PurchasePropertyValue]) {
    // EventTextFieldCell
    cell = [self createCellWithIdentifier:TextFieldCell withClass:[EventTextFieldCell class]];
    ((EventTextFieldCell *)cell).eventLabel.text = label;
    if (indexPath.section == 0) {
      ((EventTextFieldCell *)cell).eventTextField.text = self.valuesDictionary[self.labelsArraySection1[row]];
    } else if (indexPath.section == 1) {
      ((EventTextFieldCell *)cell).eventTextField.text = self.valuesDictionary[self.labelsArraySection2[row]];
    }
  } else if ([label isEqualToString:CustomEventPropertyType] || [label isEqualToString:PurchasePropertyType]) {
    // EventSegmentedControlCell
    cell = [self createCellWithIdentifier:SegmentedControlCell withClass:[EventSegmentedControlCell class]];
    if (indexPath.section == 0) {
      ((EventSegmentedControlCell *)cell).customEventPropertyTypeSegment.selectedSegmentIndex = self.eventPropertyType;
    } else if (indexPath.section == 1) {
      ((EventSegmentedControlCell *)cell).customEventPropertyTypeSegment.selectedSegmentIndex = self.purchasePropertyType;
    }
  } else {
    // EventSwitchCell
    cell = [self createCellWithIdentifier:SwitchCell withClass:[EventSwitchCell class]];
    ((EventSwitchCell *)cell).eventLabel.text = label;
    if (indexPath.section == 0) {
      ((EventSwitchCell *)cell).eventPropertySwitch.on = [self.valuesDictionary[self.labelsArraySection1[row]] boolValue];
    } else if (indexPath.section == 1) {
      ((EventSwitchCell *)cell).eventPropertySwitch.on = [self.valuesDictionary[self.labelsArraySection2[row]] boolValue];
    }
  }
  return cell;
}

- (UITableViewCell *)createCellWithIdentifier:(NSString *)identifier withClass:(Class)class {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.labelsArraySection1.count;
  } else {
    return self.labelsArraySection2.count;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *label = [self labelForIndexPath:indexPath];
  if ([label isEqualToString:LogEvent] ||
      [label isEqualToString:LogPurchase]) {
    return TableViewTopY + 22.0;
  } else if ([label isEqualToString:Name] ||
             [label isEqualToString:ProductId] ||
             [label isEqualToString:CurrencyCode] ||
             [label isEqualToString:Price] ||
             [label isEqualToString:Quantity]) {
    return TableViewTopY + 6.0;
  }
  return TableViewTopY;
}

- (NSString *)labelForIndexPath:(NSIndexPath *)indexPath {
  NSString *label = @"";
  if (indexPath.section == 0) {
    label = self.labelsArraySection1[indexPath.row];
  } else if (indexPath.section == 1) {
    label = self.labelsArraySection2[indexPath.row];
  }
  return label;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  // Need to know index path to know which section this text field is in
  UITableViewCell *cell = ((UITableViewCell *)[[((UIView *)textField) superview] superview]); // Get UITextField's parent UITableViewCell
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  
  // Check if the text field being edited is the event value or purchase value so we can implement the date picker if
  // the user wants to input a date value
  if ((indexPath.section == 0 && self.eventPropertyType == 3 && [self.labelsArraySection1[indexPath.row] isEqualToString:EventPropertyValue]) ||
          (indexPath.section == 1 && self.purchasePropertyType == 3 && [self.labelsArraySection2[indexPath.row] isEqualToString:PurchasePropertyValue])) {
    self.currentTextField = textField;
    textField.text = nil;
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor clearColor];
    textField.inputView = datePicker;
    if (textField.text && textField.text.length > 0) {
      datePicker.date = [self getDateFromString:textField.text];
    } else {
      textField.text = [self getStringFromDate:datePicker.date];
    }
  }
  
  if (indexPath.section == 0) {
    if ([self.labelsArraySection1[indexPath.row] isEqualToString:Name]
        || [self.labelsArraySection1[indexPath.row] isEqualToString:EventPropertyKey]) {
      [self setUpTextField:textField withKeyboardType:UIKeyboardTypeDefault];
    }
  } else if (indexPath.section == 1) {
    if ([self.labelsArraySection2[indexPath.row] isEqualToString:ProductId]
        || [self.labelsArraySection2[indexPath.row] isEqualToString:PurchasePropertyKey]
        || [self.labelsArraySection2[indexPath.row] isEqualToString:CurrencyCode]) {
      [self setUpTextField:textField withKeyboardType:UIKeyboardTypeDefault];
    } else if ([self.labelsArraySection2[indexPath.row] isEqualToString:Price]
               || [self.labelsArraySection2[indexPath.row] isEqualToString:Quantity]) {
      [self setUpTextField:textField withKeyboardType:UIKeyboardTypeNumberPad];
    }
  }
  
  return YES;
}

- (void)setUpTextField:(UITextField *)textField withKeyboardType:(UIKeyboardType)keyboardType {
  textField.inputView = nil;
  [textField reloadInputViews];
  textField.keyboardType = keyboardType;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  // Need to know index path to know which section this text field is in
  UITableViewCell *cell = ((UITableViewCell *)[[((UIView *)textField) superview] superview]); // Get UITextField's parent UITableViewCell
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  if (indexPath.section == 0) {
    self.valuesDictionary[self.labelsArraySection1[indexPath.row]] = textField.text;
  } else if (indexPath.section == 1) {
    self.valuesDictionary[self.labelsArraySection2[indexPath.row]] = textField.text;
  }
  self.currentTextField = nil;
}

- (IBAction)hideKeyboard:(UITextField*)textField {
  [self.view endEditing:YES];
}

- (void)setUpPropertyKeyTextFieldWithSwitchIndexPath:(NSIndexPath *)indexPath {
  NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
  EventTextFieldCell *textFieldCell = [self.tableView cellForRowAtIndexPath:newIndexPath];
  UITextField *textField = textFieldCell.eventTextField;
  textField.keyboardType = UIKeyboardTypeDefault;
  textField.text = nil;
}

- (IBAction)switchChangedValue:(UISwitch *)sender {
  [self.view endEditing:YES];
  
  // Need to know index path to know which section this switch is in
  UITableViewCell *cell = ((UITableViewCell *)[[((UIView *)sender) superview] superview]); // Get UISwitch's parent UITableViewCell
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  
  if (indexPath.section == 0) {
    self.valuesDictionary[self.labelsArraySection1[indexPath.row]] = @(sender.on);
    if (sender.on) {
      // Add Key and Value to labelsArray
      [self.labelsArraySection1 insertObject:EventPropertyKey atIndex:indexPath.row + 1];
      [self.labelsArraySection1 insertObject:CustomEventPropertyType atIndex:indexPath.row + 2];
      [self.labelsArraySection1 insertObject:EventPropertyValue atIndex:indexPath.row + 3];
    
      [self setUpPropertyKeyTextFieldWithSwitchIndexPath:indexPath];
      self.eventPropertyType = 0;
    } else {
      // Remove Key and Value from labelsArray
      NSRange indexRange = NSMakeRange(indexPath.row + 1, 3);
      [self.labelsArraySection1 removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
    }
  } else if (indexPath.section == 1) {
    self.valuesDictionary[self.labelsArraySection2[indexPath.row]] = @(sender.on);
    if (sender.on) {
      // Add Key and Value to labelsArray
      [self.labelsArraySection2 insertObject:PurchasePropertyKey atIndex:indexPath.row + 1];
      [self.labelsArraySection2 insertObject:PurchasePropertyType atIndex:indexPath.row + 2];
      [self.labelsArraySection2 insertObject:PurchasePropertyValue atIndex:indexPath.row + 3];
      
      [self setUpPropertyKeyTextFieldWithSwitchIndexPath:indexPath];
      self.purchasePropertyType = 0;
    } else {
      // Remove Key and Value from labelsArray
      NSRange indexRange = NSMakeRange(indexPath.row + 1, 3);
      [self.labelsArraySection2 removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
    }
  }
  
  [self.tableView reloadData];
}

- (void)showAlertWithMessage:(NSString *)message {
  [AlertControllerUtils presentTemporaryAlertWithTitle:nil
                                                 message:message
                                            presentingVC:self];
}

- (BOOL)checkIfFieldIsEmpty:(NSString *)field {
  NSString *string = self.valuesDictionary[field];
  if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0) {
    NSString *message = [NSString localizedStringWithFormat:@"Cannot have blank %@", field];
    [self showAlertWithMessage:message];
    return NO;
  }
  return YES;
}

- (BOOL)validateIntegerForField:(NSString *)field {
  // Check if it's a string because if you click "Log Custom Event" or "Log Purchase", the value becomes an integer in
  // the dictionary so then if you click the button again without changing the value, it'll try to read it as a string and
  // throw an exception.
  if ([self.valuesDictionary[field] isKindOfClass:[NSString class]]) {
    NSString *string = self.valuesDictionary[field];
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0
        || [string integerValue] == 0) {
      NSString *message = [NSString localizedStringWithFormat:@"%@ is an invalid number", field];
      [self showAlertWithMessage:message];
      return NO;
    }
  }
  return YES;
}

- (IBAction)logEventOrPurchase:(UIButton *)sender {
  [self.view endEditing:YES];

  // Custom Event
  if ([sender.titleLabel.text isEqualToString:LogEvent] && [self checkIfFieldIsEmpty:Name]) {
    NSString *eventName = self.valuesDictionary[Name];
    if (![self.valuesDictionary[EventSwitch] boolValue]) {
      // Log Event
      [[Appboy sharedInstance] logCustomEvent:eventName];
      [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ logged", eventName]];
    } else {
      // Log Event with Properties
      if ([self validateAndStorePropertyWithKey:EventPropertyKey andValue:EventPropertyValue withPropertyType:self.eventPropertyType]) {
        NSDictionary *properties = @{self.valuesDictionary[EventPropertyKey] : self.valuesDictionary[EventPropertyValue]};
        [[Appboy sharedInstance] logCustomEvent:eventName withProperties:properties];
        if ([self.valuesDictionary[EventPropertyValue] isKindOfClass:[NSDate class]]) {
          [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ logged with properties {\n%@ = %@\n}", eventName, self.valuesDictionary[EventPropertyKey], [self getStringFromDate:self.valuesDictionary[EventPropertyValue]]]];
        } else {
          [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ logged with properties %@", eventName, properties]];
        }
      }
    }
  }
  // Purchase Event
  else if ([sender.titleLabel.text isEqualToString:LogPurchase]
             && [self checkIfFieldIsEmpty:ProductId]
             && [self checkIfFieldIsEmpty:CurrencyCode]
             && [self checkIfFieldIsEmpty:Price]
             && [self validateIntegerForField:Quantity]){
    NSString *productId = self.valuesDictionary[ProductId];
    NSString *currencyCode = self.valuesDictionary[CurrencyCode];
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.valuesDictionary[Price]];
    NSUInteger quantity = (NSUInteger)[self.valuesDictionary[Quantity] integerValue];
    if (![self.valuesDictionary[PurchaseSwitch] boolValue]) {
      // Log Purchase
      [[Appboy sharedInstance] logPurchase:productId inCurrency:currencyCode atPrice:price withQuantity:quantity];
      [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ purchased", productId]];
    } else {
      // Log Purchase with Properties
      if ([self validateAndStorePropertyWithKey:PurchasePropertyKey andValue:PurchasePropertyValue withPropertyType:self.purchasePropertyType]) {
        NSDictionary *properties = @{self.valuesDictionary[PurchasePropertyKey] : self.valuesDictionary[PurchasePropertyValue]};
        [[Appboy sharedInstance] logPurchase:productId inCurrency:currencyCode atPrice:price withQuantity:quantity andProperties:properties];
        if ([self.valuesDictionary[PurchasePropertyValue] isKindOfClass:[NSDate class]]) {
          [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ purchased with properties {\n%@ = %@\n}", productId, self.valuesDictionary[PurchasePropertyKey], [self getStringFromDate:self.valuesDictionary[PurchasePropertyValue]]]];
        } else {
          [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ purchased with properties %@", productId, properties]];
        }
      }
    }
  }
  // restoring NSNumber/NSDate values back to NSString
  NSMutableDictionary *updatedValues = [NSMutableDictionary dictionary];
  for (NSString *key in self.valuesDictionary) {
    id value = self.valuesDictionary[key];
    if ([value isKindOfClass:[NSNumber class]]) {
      updatedValues[key] = [NSString stringWithFormat:@"%@", value];
    } else if ([value isKindOfClass:[NSDate class]]) {
      updatedValues[key] = [self getStringFromDate:value];
    }
  }
  [self.valuesDictionary addEntriesFromDictionary:updatedValues];
}

- (BOOL)validateAndStorePropertyWithKey: (NSString *)key andValue:(NSString *)value withPropertyType:(NSInteger)propertyType {
  if (![self checkIfFieldIsEmpty:key]) {
    return NO;
  }
  switch (propertyType) {
    case 0:
      if (![self checkIfFieldIsEmpty:value]) {
        return NO;
      }
      break;
    case 1:
      if (![self checkIfFieldIsEmpty:value]) {
        return NO;
      }
      self.valuesDictionary[value] = @([self.valuesDictionary[value] integerValue]);
      break;
    case 2:
      if (![self checkIfFieldIsEmpty:value]) {
        return NO;
      }
      self.valuesDictionary[value] = @([self.valuesDictionary[value] doubleValue]);
      break;
    case 3:
      if (![self.valuesDictionary[value] isKindOfClass:[NSDate class]]) {
        self.valuesDictionary[value] = [self getDateFromString:self.valuesDictionary[value]];
      }
      break;
  }
  return YES;
}

- (IBAction)customEventPropertyTypeChanged:(UISegmentedControl *)sender {
  [self.view endEditing:YES];
  // Need to know index path to know which section this text field is in
  UITableViewCell *cell = ((UITableViewCell *)[[((UIView *)sender) superview] superview]); // Get UISegmentedControl's parent UITableViewCell
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  if(indexPath.section == 0) {
    self.eventPropertyType = sender.selectedSegmentIndex;
    self.valuesDictionary[EventPropertyValue] = @"";
  } else if (indexPath.section == 1) {
    self.purchasePropertyType = sender.selectedSegmentIndex;
    self.valuesDictionary[PurchasePropertyValue] = @"";
  }
  
  NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
  EventTextFieldCell *textFieldCell = [self.tableView cellForRowAtIndexPath:newIndexPath];
  UITextField *textField = textFieldCell.eventTextField;
  textField.text = nil;
  
  switch(sender.selectedSegmentIndex) {
    case 0:
      [self setUpTextField:textField withKeyboardType:UIKeyboardTypeDefault];
      break;
    case 1:
      [self setUpTextField:textField withKeyboardType:UIKeyboardTypeNumberPad];
      break;
    case 2:
      [self setUpTextField:textField withKeyboardType:UIKeyboardTypeDecimalPad];
      break;
    case 3:
      break;
  }
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
  self.currentTextField.text = [self getStringFromDate:sender.date];
}

- (NSString *)getStringFromDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSString *dateString = [dateFormatter stringFromDate:date];
  return dateString;
}

- (NSDate *)getDateFromString:(NSString *)birthdayString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSDate *date = [dateFormatter dateFromString:birthdayString];
  return date;
}

@end
