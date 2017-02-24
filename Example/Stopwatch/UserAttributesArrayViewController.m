#import "UserAttributesArrayViewController.h"
#import "UserCells.h"
#import <AppboyKit.h>

@implementation UserAttributesArrayViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customizeRemoveValuesButton];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.setValuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"attributeValueCell";
  UserAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[UserAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.attributeNameLabel.text = @"Value";
  cell.attributeTextField.text = self.setValuesArray[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  // if a cell is deleted, remove data from setValuesArray and cell from tableView
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.setValuesArray removeObjectAtIndex:indexPath.row];
    UserAttributeCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.attributeTextField.text = @"";
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (self.setValuesArray.count == 0) {
      [self exitEditingMode];
    }
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  self.currentTextField = textField;
  return YES;
}

// Add text field value to array at tableView row index
- (IBAction)addValue:(id)sender {
  id cell = [[((UIView *)sender) superview] superview]; // Get UITextField's parent UITableViewCell
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  NSInteger row = [indexPath row];
  self.setValuesArray[row] = ((UITextField *)sender).text;
}

- (void)customizeRemoveValuesButton {
  [self.removeValuesButton setTitle:@"Edit" forState:UIControlStateNormal];
  [self.removeValuesButton setTitle:@"Done" forState:UIControlStateSelected];
  self.removeValuesButton.selected = NO;
}

- (IBAction)setToSegmentedControlChanged:(id)sender {
  if (self.setToSegmentedControl.selectedSegmentIndex == 1) {
    // if set to nil is selected, hide tableView
    self.tableView.hidden = YES;
    self.addValuesButton.hidden = YES;
    self.removeValuesButton.hidden = YES;
  } else {
    self.tableView.hidden = NO;
    self.addValuesButton.hidden = NO;
    self.removeValuesButton.hidden = NO;

  }
}

- (IBAction)hideKeyboard:(id)sender {
  [self.currentTextField resignFirstResponder];
}

- (void)sendAlertWithMessage:(NSString*)message {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  alertView = nil;
}

- (BOOL)stringIsNotEmpty:(NSString *)string {
  return (string && [string length] > 0);
}

// Returns appropriate error message if input(s) are invalid
- (BOOL)inputIsValid:(BOOL)isValid forKeyOrValue:(NSString *)keyOrValue {
  if (!isValid) {
    if ([keyOrValue isEqualToString:@"k"]) {
      [self sendAlertWithMessage:NSLocalizedString(@"Appboy.Stopwatch.user-attributes-array.missing-key", nil)];
    } else if ([keyOrValue isEqualToString:@"v"]) {
      [self sendAlertWithMessage:NSLocalizedString(@"Appboy.Stopwatch.user-attributes-array.missing-value", nil)];
    } else if ([keyOrValue isEqualToString:@"vs"]) {
      [self sendAlertWithMessage:NSLocalizedString(@"Appboy.Stopwatch.user-attributes-array.missing-values", nil)];
    }
  }
  return isValid;
}

// Exit tableView editing mode
- (void)exitEditingMode {
  [self.tableView setEditing:NO animated:YES];
  self.isEditing = NO;
  self.removeValuesButton.selected = NO;
}

// Enable removal of tableView rows
- (IBAction)removeArrayValueRows:(id)sender {
  if (self.isEditing) {
    // Disable removal
    [self exitEditingMode];
  } else if (self.setValuesArray.count > 0) {
    // Enable removal
    [self.tableView setEditing:YES animated:YES];
    self.isEditing = YES;
    self.removeValuesButton.selected = YES;
  }
}

// Add rows to tableView for setting array values
- (IBAction)addObject:(id)sender {
  if (!self.setValuesArray) {
    self.setValuesArray = [[NSMutableArray alloc] init];
  }
  NSInteger valuesArrayIndex = self.setValuesArray.count;
  [self.setValuesArray insertObject: [NSString string] atIndex:valuesArrayIndex];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:valuesArrayIndex inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// "Add" button tapped
- (IBAction)addArrayValue:(id)sender {
  [self addOrRemoveFromArray:@"add"];
}

// "Remove" button tapped
- (IBAction)removeArrayValue:(id)sender {
  [self addOrRemoveFromArray:@"remove"];
  
}

// Tell Appboy to add or remove values from array
- (void)addOrRemoveFromArray:(NSString *)addOrRemove {
  BOOL keyIsValid = [self stringIsNotEmpty:self.attributeKeyTextField.text];
  BOOL valueIsValid = [self stringIsNotEmpty:self.attributeValueTextField.text];
  
  if ([self inputIsValid:keyIsValid forKeyOrValue:@"k"] && [self inputIsValid:valueIsValid forKeyOrValue:@"v"]) {
    if ([addOrRemove isEqualToString:@"add"]) {
      [[Appboy sharedInstance].user addToCustomAttributeArrayWithKey:self.attributeKeyTextField.text value:self.attributeValueTextField.text];
      [self sendAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Added %@ to array", nil), self.attributeValueTextField.text]];
    } else if ([addOrRemove isEqualToString:@"remove"]) {
      [[Appboy sharedInstance].user removeFromCustomAttributeArrayWithKey:self.attributeKeyTextField.text value:self.attributeValueTextField.text];
      [self sendAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Removed %@ from array", nil), self.attributeValueTextField.text]];
    }
  }
}

// Tell Appboy to set array values
- (IBAction)setArrayValues:(id)sender {
  BOOL keyIsValid = [self stringIsNotEmpty:self.attributeKeyTextField.text];
  
  if ([self inputIsValid:keyIsValid forKeyOrValue:@"k"]) {
    if (self.setToSegmentedControl.selectedSegmentIndex == 1) {
      // Set array to nil
      [[Appboy sharedInstance].user setCustomAttributeArrayWithKey:self.attributeKeyTextField.text array:nil];
      [self sendAlertWithMessage:NSLocalizedString(@"Set array to nil", nil)];
    } else {
      // Set array to setValuesArray
      BOOL valuesAreValid = self.setValuesArray.count > 0;
      for (NSString* value in self.setValuesArray) {
        valuesAreValid = valuesAreValid && [self stringIsNotEmpty:value];
      }
      
      if ([self inputIsValid:valuesAreValid forKeyOrValue:@"vs"]) {
        [[Appboy sharedInstance].user setCustomAttributeArrayWithKey:self.attributeKeyTextField.text array:self.setValuesArray];
        [self sendAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Set array to values %@", nil), self.setValuesArray]];
      }
    }
  }
}

@end
