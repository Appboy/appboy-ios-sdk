#import <Foundation/Foundation.h>

@interface ABKUIUtils : NSObject

+ (NSString *)getLocalizedString:(NSString *)key inAppboyBundle:(NSBundle *)appboyBundle table:(NSString *)table;
+ (BOOL)objectIsValidAndNotEmpty:(id)object;
+ (UIImage *)maskImage:(UIImage *)image toColor:(UIColor*)color;
+ (Class)getSDWebImageProxyClass;
+ (Class)getModalFeedViewControllerClass;
+ (BOOL)isiPhoneX;
+ (UIImage *)getImageWithName:(NSString *)name
                         type:(NSString *)type
               inAppboyBundle:(NSBundle *)appboyBundle;

@end
