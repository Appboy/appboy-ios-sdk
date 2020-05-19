#import "StopwatchSegmentedControl.h"
#import "ColorUtils.h"

@implementation StopwatchSegmentedControl

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.tintColor = [ColorUtils stopwatchBlueColor];
  }
  return self;
}

@end
