#import "UserCustomAttribute.h"

@implementation UserCustomAttribute

- (instancetype)init {
  self = [super init];
  if (self) {
    self.attributeKey = @"";
    self.attributeValue = @"";
  }
  return self;
}

- (instancetype)initWithKey:(NSString *)attributeKey value:(NSString *)attributeValue {
  self = [super init];
  if (self) {
    self.attributeKey = attributeKey;
    self.attributeValue = attributeValue;
  }
  return self;
}

@end
