#import <Foundation/Foundation.h>

@interface UserCustomAttribute : NSObject

@property (nonatomic, strong) NSString *attributeKey;
@property (nonatomic, strong) NSString *attributeValue;

- (instancetype)initWithKey:(NSString *)attributeKey value:(NSString *)attributeValue;

@end
