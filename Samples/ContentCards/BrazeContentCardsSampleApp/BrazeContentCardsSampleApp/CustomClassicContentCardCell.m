#import "CustomClassicContentCardCell.h"

@implementation CustomClassicContentCardCell

- (void)setUpUI {
  [super setUpUI];
  self.rootView.backgroundColor = [UIColor lightGrayColor];
  self.rootView.layer.borderColor = [UIColor purpleColor].CGColor;
  self.unviewedLineView.backgroundColor = [UIColor redColor];
  self.titleLabel.font = [UIFont italicSystemFontOfSize:20];
}

@end
