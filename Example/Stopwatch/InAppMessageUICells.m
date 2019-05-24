#import "InAppMessageUICells.h"

@implementation SegmentCell

- (void)setUpWithItem:(NSString *)item {
  self.titleLabel.text = item;
  NSDictionary *segmentDictionary = @{ItemIcon : @[@"None", @"Badge", @"URL"],
                                      ItemClickAction : @[@"Feed", @"None", @"URL"],
                                      ItemDismissType : @[@"Auto", @"Swipe"],
                                      ItemAnimatedFrom : @[@"Bottom", @"Top"],
                                      ItemOrientation : @[@"Any", @"Por", @"Landscape"],
                                      ItemButtonNumber : @[@"None", @"One", @"Two"],
                                      ItemMessageAlignment : @[@"Center", @"Start", @"End"],
                                      ItemHeaderAlignment : @[@"Center", @"Start", @"End"],
                                      ItemImageContentMode : @[@"Fit", @"Fill"]};
  NSArray *segmentList = segmentDictionary[item];
  [self.segmentControl removeAllSegments];
  for (int i = 0; i < segmentList.count; i ++) {
    [self.segmentControl insertSegmentWithTitle:segmentList[i] atIndex:i animated:NO];
  }
}
@end

@implementation TextFieldCell

@end

@implementation ButtonLabelCell

+ (NSDictionary *)imageDictionary {
  return @{@"956x400" : @"https://www.dropbox.com/s/aug2ym2ve6l93ot/wow956x400.png?dl=1",
           @"(graphic modal)1000x1000" : @"https://www.dropbox.com/s/vp8xic22wuo20c9/wow1000x1000.png?dl=1",
           @"(full - portrait)1000x800" : @"https://www.dropbox.com/s/rnfxchj8zn6vf2b/wow1000x800.png?dl=1",
           @"(graphic full - portrait)1000x1600" : @"https://www.dropbox.com/s/04sh1u47vf02ayt/wow1000x1600.png?dl=1",
           @"(graphic full - landscape)1600x1000" : @"https://www.dropbox.com/s/uarvtlcrpro6dpy/wow1600x1000.png?dl=1",
           @"(full - landscape)1600x500" : @"https://www.dropbox.com/s/baam4syqx4ig42z/wow1600x500.png?dl=1",
           @"(modal)1160x400" : @"https://www.dropbox.com/s/r3uj7t7qx6jgzyy/wow1160x400.png?dl=1",
           @"No Image" : [NSNull null]};
}

+ (NSDictionary *)headerDictionary {
  return @{@"None" : @"",
           @"10 Chars" : @"Hey there#",
           @"20 Chars" : @"Hey hey from Braze!#",
           @"30 Chars" : @"Good morning from us @ Braze!#",
           @"80 Chars" : @"Hello from Braze!! Have a fun day okay. Hello from Braze!! Have a fun day today#"};
}

+ (NSDictionary *)messageDictionary {
  return @{@"20 Chars" : @"Hey hey from Braze!#",
           @"40 Chars" : @"Hello there!  This is an in-app message#",
           @"70 Chars" : @"Hello there! This is an in-app message. Yo, this is an in-app message#",
           @"90 Chars" : @"Hello there! This is an in-app message.  Hello again!  Anyways, this is an in-app message#",
           @"140 Chars" : @"Welcome to Braze!! Braze! is Marketing Automation for Apps. This is an in-app message - this message is exactly one hundred and forty chars#",
           @"240 Chars" : @"Welcome to Braze!! Braze! is Marketing Automation for Apps. This is an in-app message - this message is exactly two hundred and forty chars!  We don\'t recommend making in-app messages longer than 140 characters due to variations in screens#",
           @"640 Chars" : @"Welcome to Braze!! Braze! is Marketing Automation for Apps. This is an in-app message - this message is exactly six hundred and forty chars!  We don\'t recommend making in-app messages longer than 140 characters due to variations in screens.  This is an in-app message - this message is exactly six hundred and forty chars!  We don\'t recommend making in-app messages longer than 140 characters due to variations in screens.  This is an in-app message - this message is exactly six hundred and forty chars!  We don\'t recommend making in-app messages longer than 140 characters due to variations in screens.  This is a waaaay too long message#"};
}

- (UIAlertController *)getAlertControllerWithInAppMessageDictionary:(NSMutableDictionary *)dictionary {
  NSString *buttonTitle = self.titleButton.titleLabel.text;
  NSDictionary *optionDictionary;
  if ([buttonTitle isEqualToString:ItemImageURL]) {
    optionDictionary = [ButtonLabelCell imageDictionary];
  } else if ([buttonTitle isEqualToString:ItemMessage]) {
    optionDictionary = [ButtonLabelCell messageDictionary];
  } else if ([buttonTitle isEqualToString:ItemHeader]) {
    optionDictionary = [ButtonLabelCell headerDictionary];
  }
  
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:buttonTitle
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
  
  for (NSString *title in [optionDictionary allKeys]) {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      if (optionDictionary[action.title] != [NSNull null]) {
        self.textField.text  = optionDictionary[action.title];
      } else {
        self.textField.text  = @"";
      }
      dictionary[buttonTitle] = self.textField.text;
    }];
    [actionSheet addAction:action];
  }
  [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
  return actionSheet;
}

- (UIActionSheet *)getActionSheetWithInAppMessageDictionary:(NSMutableDictionary *)dictionary {
  NSString *buttonTitle = self.titleButton.titleLabel.text;
  NSDictionary *optionDictionary;
  if ([buttonTitle isEqualToString:ItemImageURL]) {
    optionDictionary = [ButtonLabelCell imageDictionary];
  } else if ([buttonTitle isEqualToString:ItemMessage]) {
    optionDictionary = [ButtonLabelCell messageDictionary];
  } else if ([buttonTitle isEqualToString:ItemHeader]) {
    optionDictionary = [ButtonLabelCell headerDictionary];
  }
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:buttonTitle
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
  
  for (NSString *title in [optionDictionary allKeys]) {
    [actionSheet addButtonWithTitle:title];
  }
  self.inAppMessageDictionary = dictionary;
  return actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSDictionary *optionDictionary;
  if ([actionSheet.title isEqualToString:ItemImageURL]) {
    optionDictionary = [ButtonLabelCell imageDictionary];
  } else if ([actionSheet.title isEqualToString:ItemMessage]) {
    optionDictionary = [ButtonLabelCell messageDictionary];
  } else if ([actionSheet.title isEqualToString:ItemHeader]) {
    optionDictionary = [ButtonLabelCell headerDictionary];
  }
  
  NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
  if (optionDictionary[buttonTitle] != [NSNull null]) {
    self.textField.text  = optionDictionary[buttonTitle];
  } else {
    self.textField.text  = @"";
  }
  self.inAppMessageDictionary[buttonTitle] = self.textField.text;
}

@end

@implementation ColorCell

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

@implementation SwitchCell

@end

@implementation InAppMessageButtonCell

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
