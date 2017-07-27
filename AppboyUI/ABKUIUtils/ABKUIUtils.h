#import <Foundation/Foundation.h>

@interface ABKUIUtils : NSObject

+ (NSString *)getLocalizedString:(NSString *)key inAppboyBundle:(NSBundle *)appboyBundle table:(NSString *)table;

@end
