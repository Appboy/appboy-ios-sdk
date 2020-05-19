#import "StopwatchButton.h"
#import "ColorUtils.h"

@implementation StopwatchButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.backgroundColor = [ColorUtils stopwatchBlueColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
  }
  return self;
}

@end
