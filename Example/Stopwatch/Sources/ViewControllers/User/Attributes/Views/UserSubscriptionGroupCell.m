#import "UserSubscriptionGroupCell.h"

static NSInteger const TextFieldTagNumber = 4000;

@implementation UserSubscriptionGroupCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.groupIdTextField.tag = TextFieldTagNumber;
  self.statusSegmentControl.tag = TextFieldTagNumber + 1;
}

- (void)setUserSubscriptionGroup:(UserSubscriptionGroup *)subscriptionGroup
             selectNextCellBlock:(SelectNextCellBlock)nextCellBlock
textFieldShouldBeginEditingBlock:(TextFieldShouldBeginEditingBlock)textFieldBlock {
  self.subscriptionGroup = subscriptionGroup;
  self.groupIdTextField.text = subscriptionGroup.groupId;
  
  if ([subscriptionGroup.status isEqualToString:@"s"]) {
    self.statusSegmentControl.selectedSegmentIndex = 0;
  } else if ([subscriptionGroup.status isEqualToString:@"u"]) {
    self.statusSegmentControl.selectedSegmentIndex = 1;
  } else {
    self.statusSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
  }
  
  self.selectNextCellBlock = nextCellBlock;
  self.textFieldShouldBeginEditingBlock = textFieldBlock;
}

#pragma mark: - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField.tag != TextFieldTagNumber && self.selectNextCellBlock) {
    // next cell should be called
    self.selectNextCellBlock(self);
    return YES;
  }
  NSInteger nextTag = textField.tag + 1;
  UIResponder *nextResponder = [self.contentView viewWithTag:nextTag];
  [nextResponder becomeFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if (self.textFieldShouldBeginEditingBlock) {
    self.textFieldShouldBeginEditingBlock(self);
  }
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (textField == self.groupIdTextField) {
    self.subscriptionGroup.groupId = text;
  }
  return YES;
}

- (IBAction)statusSegmentControlSelectionDidChange:(UISegmentedControl *)sender {
  NSString *newStatus = @"";
  switch (sender.selectedSegmentIndex) {
    case 0:
      newStatus = @"s";
      break;
      
    case 1:
      newStatus = @"u";
      break;
      
    default:
      break;
  }
  self.subscriptionGroup.status = newStatus;
}

@end
