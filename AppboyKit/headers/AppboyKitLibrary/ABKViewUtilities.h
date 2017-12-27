#import <UIKit/UIKit.h>

@interface ABKViewUtilities : NSObject

+ (void)setViewOriginY:(UIView *)view originY:(CGFloat)originY;
+ (void)setViewOriginX:(UIView *)view originX:(CGFloat)originX;
+ (void)setViewHeight:(UIView *)view height:(CGFloat)aHeight;
+ (void)setViewWidth:(UIView *)view width:(CGFloat)aWidth;
+ (void)setViewCenterY:(UIView *)view centerY:(CGFloat)centerY;
+ (void)setViewCenterX:(UIView *)view centerX:(CGFloat)centerX;
+ (void)stackViews:(NSArray *)views
    startYPosition:(CGFloat)startYPosition
           padding:(CGFloat)padding
           spacing:(CGFloat)spacing
    maxTotalHeight:(CGFloat)maxTotalHeight;
+ (UIImage *)fetchImageIfCached:(NSString *)imageUrlString;
@end
