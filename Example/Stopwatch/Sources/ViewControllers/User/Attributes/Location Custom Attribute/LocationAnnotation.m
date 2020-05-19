#import "LocationAnnotation.h"

@implementation LocationAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
  self = [super init];
  if (self) {
    _coordinate = coordinate;
  }
  return self;
}

- (NSString *)title {
  return NSLocalizedString(@"Picked Location", @"");
}

- (NSString *)subtitle {
  return [NSString stringWithFormat:@"%@: %lf, %@: %lf", NSLocalizedString(@"Latitude", @""),
          self.coordinate.latitude, NSLocalizedString(@"longitude", @""), self.coordinate.longitude];
}

@end
