#import "UserSubscriptionGroup.h"

@implementation UserSubscriptionGroup

- (instancetype)init {
  self = [super init];
  if (self) {
    self.groupId = @"";
    self.status = @"";
  }
  return self;
}

- (instancetype)initWithGroupId:(NSString *)groupId status:(NSString *)status {
  self = [super init];
  if (self) {
    self.groupId = groupId;
    self.status = status;
  }
  return self;
}

@end
