#import "UserCustomAttributeCell.h"

static NSInteger const TextFieldTagNumber = 2000;

@implementation UserCustomAttributeCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.keyTextField.tag = TextFieldTagNumber;
  self.valueTextField.tag = TextFieldTagNumber + 1;
}

- (void)setUserCustomAttribute:(UserCustomAttribute *)customAttribute selectNextCellBlock:(SelectNextCellBlock)nextCellBlock textFieldShouldBeginEditingBlock:(TextFieldShouldBeginEditingBlock)textFieldBlock {
  self.customAttibute = customAttribute;
  self.keyTextField.text = customAttribute.attributeKey;
  self.valueTextField.text = customAttribute.attributeValue;
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
  if (textField == self.keyTextField) {
    self.customAttibute.attributeKey = text;
  } else if (textField == self.valueTextField) {
    self.customAttibute.attributeValue = text;
  }
  return YES;
}


@end
