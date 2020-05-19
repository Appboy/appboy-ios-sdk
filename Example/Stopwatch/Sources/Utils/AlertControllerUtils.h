#import <Foundation/Foundation.h>

@interface AlertControllerUtils : NSObject

// Alerts presented with this method will have a duration of 500ms.
+ (void)presentTemporaryAlertWithTitle:(NSString *)title
                                 message:(NSString *)message
                            presentingVC:(UIViewController *)presentingVC;

+ (void)presentAlertWithOKButtonForTitle:(NSString *)title
                                 message:(NSString *)message
                            presentingVC:(UIViewController *)presentingVC;

@end
