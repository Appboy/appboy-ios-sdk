#import "CustomCaptionedImageContentCardCell.h"

@implementation CustomCaptionedImageContentCardCell

- (void)setUpUI {
  [super setUpUI];
  self.rootView.backgroundColor = [UIColor lightGrayColor];
  self.rootView.layer.borderColor = [UIColor purpleColor].CGColor;
  self.unviewedLineView.backgroundColor = [UIColor redColor];
  self.titleBackgroundView.backgroundColor = [UIColor darkGrayColor];
  self.titleLabel.textColor = [UIColor brownColor];
  self.titleLabel.font = [UIFont italicSystemFontOfSize:20];
}

@end
