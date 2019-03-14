#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABKUIUtils : NSObject

+ (NSString *)getLocalizedString:(NSString *)key inAppboyBundle:(NSBundle *)appboyBundle table:(NSString *)table;
+ (BOOL)objectIsValidAndNotEmpty:(id)object;
+ (Class)getSDWebImageProxyClass;
+ (Class)getModalFeedViewControllerClass;
+ (BOOL)isNotchedPhone;
+ (UIImage *)getImageWithName:(NSString *)name
                         type:(NSString *)type
               inAppboyBundle:(NSBundle *)appboyBundle;

@end
