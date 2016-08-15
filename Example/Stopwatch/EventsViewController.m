#import "EventsViewController.h"
#import <AppboyKit.h>
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
static NSString *const ProductID = @"Product ID";
static NSString *const CurrencyCode = @"Currency Code";
static NSString *const Price = @"Price";
static NSString *const Quantity = @"Quantity";
static NSString *const EventKey = @"Event Key";
static NSString *const EventValue = @"Event Value";
static NSString *const PurchaseKey = @"Purchase Key";
static NSString *const PurchaseValue = @"Purchase Value";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.labelsArray = [NSMutableArray arrayWithArray:@[LogEvent,
                                                      Name,
                                                      EventSwitch,
                                                      LogPurchase,
                                                      ProductID,
                                                      CurrencyCode,
                                                      Price,
                                                      Quantity,
                                                      PurchaseSwitch]];
  
  self.valuesDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                          Name : @"",
                                                                          EventSwitch : @(NO),
                                                                          ProductID : @"",
                                                                          CurrencyCode : @"USD",
                                                                          Price: @"5",
                                                                          Quantity : @"1",
                                                                          PurchaseSwitch : @(NO),
                                                                          EventKey : @"",
                                                                          EventValue : @"",
                                                                          PurchaseKey : @"",
                                                                          PurchaseValue : @""
                                                                          }];
}

- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = indexPath.row;
  NSString *label = self.labelsArray[row];
  
  UITableViewCell *cell = nil;
  if ([label isEqualToString:LogEvent] || [label isEqualToString:LogPurchase]) {
    // EventButtonCell
    cell = [self createCellWithIdentifier:@"button cell" withClass:[EventButtonCell class]];
    [((EventButtonCell*) cell).eventButton setTitle:label forState:UIControlStateNormal];
  } else if ([label isEqualToString:Name]
             || [label isEqualToString:ProductID]
             || [label isEqualToString:CurrencyCode]
             || [label isEqualToString:Price]
             || [label isEqualToString:Quantity]
             || [label isEqualToString:EventKey]
             || [label isEqualToString:EventValue]
             || [label isEqualToString:PurchaseKey]
             || [label isEqualToString:PurchaseValue]) {
    // EventTextFieldCell
    cell = [self createCellWithIdentifier:@"text field cell" withClass:[EventTextFieldCell class]];
    ((EventTextFieldCell *)cell).eventLabel.text = label;
    ((EventTextFieldCell *)cell).eventTextField.tag = row;
    ((EventTextFieldCell *)cell).eventTextField.text = self.valuesDictionary[self.labelsArray[row]];
    if ([label isEqualToString:Price] || [label isEqualToString:Quantity]) {
      ((EventTextFieldCell *)cell).eventTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
  } else {
    // EventSwitchCell
    cell = [self createCellWithIdentifier:@"switch cell" withClass:[EventSwitchCell class]];
    ((EventSwitchCell *)cell).eventLabel.text = label;
    ((EventSwitchCell *)cell).eventPropertySwitch.tag = row;
    ((EventSwitchCell *)cell).eventPropertySwitch.on = [self.valuesDictionary[self.labelsArray[row]] boolValue];
  }
  return cell;
}

- (UITableViewCell *)createCellWithIdentifier:(NSString *)identifier withClass:(Class)class {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil && [class isKindOfClass:[UITableViewCell class]]) {
    cell = (UITableViewCell *)[[class alloc] init];
  }
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.labelsArray count];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.valuesDictionary[self.labelsArray[textField.tag]] = textField.text;
  self.currentTextField = nil;
}

- (IBAction)hideKeyboard:(UITextField*)textField {
  [textField resignFirstResponder];
}

- (IBAction)switchChangedValue:(UISwitch *)sender {
  [self.currentTextField resignFirstResponder];
  self.valuesDictionary[self.labelsArray[sender.tag]] = @(sender.on);
  
  if (sender.on) {
    if ([self.labelsArray[sender.tag] isEqualToString:EventSwitch]) {
      // Add Key and Value to labelsArray
      [self.labelsArray insertObject:EventKey atIndex:sender.tag + 1];
      [self.labelsArray insertObject:EventValue atIndex:sender.tag + 2];
    } else {
      [self.labelsArray insertObject:PurchaseKey atIndex:sender.tag + 1];
      [self.labelsArray insertObject:PurchaseValue atIndex:sender.tag + 2];
    }
  } else {
    // Remove Key and Value from labelsArray
    NSRange indexRange = NSMakeRange(sender.tag + 1, 2);
    [self.labelsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
  }
  [self.tableView reloadData];
}

- (void)showAlertWithMessage:(NSString *)message {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  alertView = nil;
}

- (BOOL)validateTextForField:(NSString *)field {
  NSString *string = self.valuesDictionary[field];
  if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0) {
    NSString *message = [NSString localizedStringWithFormat:@"Cannot have blank %@", field];
    [self showAlertWithMessage:message];
    return NO;
  }
  return YES;
}

- (BOOL)validateDecimalForField:(NSString *)field {
  NSString *string = self.valuesDictionary[field];
  if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0
      && [[NSDecimalNumber decimalNumberWithString:string] isEqualToNumber:[NSDecimalNumber notANumber]]) {
    NSString *message = [NSString localizedStringWithFormat:@"%@ must be a number", field];
    [self showAlertWithMessage:message];
    return NO;
  }
  return YES;
}

- (BOOL)validateIntegerForField:(NSString *)field {
  NSString *string = self.valuesDictionary[field];
  if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0
      && [string integerValue] == 0) {
    NSString *message = [NSString localizedStringWithFormat:@"%@ is an invalid number", field];
    [self showAlertWithMessage:message];
    return NO;
  }
  return YES;
}

- (IBAction)logEventOrPurchase:(UIButton *)sender {
  [self.currentTextField resignFirstResponder];

  // Custom Event
  if ([sender.titleLabel.text isEqualToString:LogEvent] && [self validateTextForField:Name]) {
    NSString *eventName = self.valuesDictionary[Name];
    if (![self.valuesDictionary[EventSwitch] boolValue]) {
      // Log Event
      [[Appboy sharedInstance] logCustomEvent:eventName];
      [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ logged", eventName]];
    } else {
      // Log Event with Properties
      if ([self validateTextForField:EventKey] && [self validateTextForField:EventValue]) {
        NSDictionary *properties = @{self.valuesDictionary[EventKey] : self.valuesDictionary[EventValue]};
        [[Appboy sharedInstance] logCustomEvent:eventName withProperties:properties];
        [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ logged with properties %@", eventName, properties]];
      }
    }
  }
  // Purchase Event
  else if ([sender.titleLabel.text isEqualToString:LogPurchase]
             && [self validateTextForField:ProductID]
             && [self validateTextForField:CurrencyCode]
             && [self validateDecimalForField:Price]
             && [self validateIntegerForField:Quantity]){
    NSString *productID = self.valuesDictionary[ProductID];
    NSString *currencyCode = self.valuesDictionary[CurrencyCode];
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.valuesDictionary[Price]];
    NSUInteger quantity = (NSUInteger)[self.valuesDictionary[Quantity] integerValue];
    if (![self.valuesDictionary[PurchaseSwitch] boolValue]) {
      // Log Purchase
      [[Appboy sharedInstance] logPurchase:productID inCurrency:currencyCode atPrice:price withQuantity:quantity];
      [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ purchased", productID]];
    } else if ([self validateTextForField:PurchaseKey] && [self validateTextForField:PurchaseValue]) {
      // Log Purchase with Properties
      NSDictionary *properties = @{self.valuesDictionary[PurchaseKey] : self.valuesDictionary[PurchaseValue]};
      [[Appboy sharedInstance] logPurchase:productID inCurrency:currencyCode atPrice:price withQuantity:quantity andProperties:properties];
      [self showAlertWithMessage:[NSString localizedStringWithFormat:@"%@ purchased with properties %@", productID, properties]];
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
