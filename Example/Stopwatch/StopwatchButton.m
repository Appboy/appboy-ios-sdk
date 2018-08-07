#import "StopwatchButton.h"

@implementation StopwatchButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:(42.0/255.0) green:(128.0/255.0) blue:(185.0/255.0) alpha:1.0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
  }
  return self;
}

@end
