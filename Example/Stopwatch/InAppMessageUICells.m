#import "InAppMessageUICells.h"

@implementation SegmentCell : UITableViewCell

- (void)setUpWithItem:(NSString *)item {
  self.titleLabel.text = item;
  NSDictionary *segmentDictionary = @{ItemIcon : @[@"None", @"Badge", @"URL"],
                                      ItemClickAction : @[@"Feed", @"None", @"URL"],
                                      ItemDismissType : @[@"Auto", @"Swipe"],
                                      ItemAnimatedFrom : @[@"Bottom", @"Top"],
                                      ItemButtonNumber : @[@"None", @"One", @"Two"]};
  NSArray *segmentList = segmentDictionary[item];
  [self.segmentControl removeAllSegments];
  for (int i = 0; i < segmentList.count; i ++) {
    [self.segmentControl insertSegmentWithTitle:segmentList[i] atIndex:i animated:NO];
  }
}
@end

@implementation TextFieldCell : UITableViewCell

@end

@implementation ColorCell : UITableViewCell

- (void)setColor:(UIColor *)color {
  if (color != nil) {
    self.colorButton.backgroundColor = color;
  } else {
    self.colorButton.backgroundColor = [UIColor lightGrayColor];
  }
}

- (UIColor *)color {
  return self.colorButton.backgroundColor;
}
@end

@implementation HideChevronCell : UITableViewCell

@end

@implementation InAppMessageButtonCell : UITableViewCell

- (void)setButton:(ABKInAppMessageButton *)button {
  _button = button;
  self.titleTextField.text = button.buttonText;
  if (button.buttonTextColor) {
    self.textColorButton.backgroundColor = button.buttonTextColor;
  }
  if (button.buttonBackgroundColor) {
    self.backgroundColorButton.backgroundColor = button.buttonBackgroundColor;
  }
  self.actionSegmentControl.selectedSegmentIndex = button.buttonClickActionType;
  self.URITextField.text = [button.buttonClickedURI absoluteString];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == self.titleTextField) {
    self.button.buttonText = textField.text;
  } else if (textField == self.URITextField) {
    self.buttonURL = [NSURL URLWithString:textField.text];
    if (self.actionSegmentControl.selectedSegmentIndex == 2) {
      [self.button setButtonClickAction:ABKInAppMessageRedirectToURI
                                withURI:self.buttonURL];
    }
  }
  return YES;
}

- (IBAction)changeColor:(UIButton *)sender {
  KKColorListViewController *colorListViewController = [[KKColorListViewController alloc] initWithSchemeType:KKColorsSchemeTypeCrayola];
  colorListViewController.delegate = self;
  sender.selected = YES;
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:colorListViewController animated:YES completion:nil];
}

- (void)colorListController:(KKColorListViewController *)controller didSelectColor:(KKColor *)color {
  if (self.textColorButton.selected) {
    self.textColorButton.backgroundColor = [color uiColor];
    self.button.buttonTextColor = self.textColorButton.backgroundColor;
    self.textColorButton.selected = NO;
  } else if (self.backgroundColorButton.selected) {
    self.backgroundColorButton.backgroundColor = [color uiColor];
    self.button.buttonBackgroundColor = self.backgroundColorButton.backgroundColor;
    self.backgroundColorButton.selected = NO;
  }
}

- (void)colorListPickerDidComplete:(KKColorListViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionChanged:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
      [self.button setButtonClickAction:ABKInAppMessageDisplayNewsFeed withURI:nil];
      break;
    case 1:
      [self.button setButtonClickAction:ABKInAppMessageNoneClickAction withURI:nil];
      break;
    case 2:
      [self.button setButtonClickAction:ABKInAppMessageRedirectToURI withURI:self.buttonURL];
      break;
    default:
      break;
  }
}

@end
