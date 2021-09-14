#import <Foundation/Foundation.h>

@interface UserSubscriptionGroup : NSObject

@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *status;

- (instancetype)initWithGroupId:(NSString *)groupId status:(NSString *)status;

@end
