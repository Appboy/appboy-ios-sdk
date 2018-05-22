#import "ABKUIUtils.h"
#import "ABKSDWebImageProxy.h"

static NSString *const LocalizedAppboyStringNotFound = @"not found";
static NSUInteger const iPhoneXHeight = 2436.0;

@implementation ABKUIUtils

+ (NSString *)getLocalizedString:(NSString *)key inAppboyBundle:(NSBundle *)appboyBundle table:(NSString *)table {
  // Check if the app has a customized localization for the given key
  NSString *localizedString = [[NSBundle mainBundle] localizedStringForKey:key
                                                                     value:LocalizedAppboyStringNotFound
                                                                     table:nil];
  if ([localizedString isEqualToString:LocalizedAppboyStringNotFound]) {
    // Check Braze's localization in the given bundle
    for (NSString *language in [[NSBundle mainBundle] preferredLocalizations]) {
      if ([[appboyBundle localizations] containsObject:language]) {
        NSBundle *languageBundle = [NSBundle bundleWithPath:[appboyBundle pathForResource:language ofType:@"lproj"]];
        localizedString = [languageBundle localizedStringForKey:key
                                                          value:LocalizedAppboyStringNotFound
                                                          table:table];
        break;
      }
    }
    if ([localizedString isEqualToString:LocalizedAppboyStringNotFound]) {
      // Couldn't find Braze's localization for the given key, fetch the default value for the key
      // from Base.lproj.
      NSBundle *appboyBaseBundle = [NSBundle bundleWithPath:[appboyBundle pathForResource:@"Base" ofType:@"lproj"]];
      localizedString = [appboyBaseBundle localizedStringForKey:key
                                                          value:LocalizedAppboyStringNotFound
                                                          table:table];
    }
  }
  return localizedString;
}

+ (BOOL)objectIsValidAndNotEmpty:(id)object {
  if (object != nil && object != [NSNull null]) {
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSString class]]) {
      return ![object isEmpty];
    }
    if ([object isKindOfClass:[NSURL class]]) {
      NSString *string = [(NSURL *)object absoluteString];
      return [string length] != 0;
    }
    return YES;
  }
  return NO;
}

// This method casts the given color on the image
+ (UIImage *)maskImage:(UIImage *)image toColor:(UIColor*)color {
  CGRect bounds = CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale);
  UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);
  CGContextClipToMask(UIGraphicsGetCurrentContext(), bounds, image.CGImage);
  [color setFill];
  UIRectFill(bounds);
  [image drawInRect:bounds blendMode:kCGBlendModeMultiply alpha:CGColorGetAlpha(color.CGColor)];
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return tintedImage;
}

+ (Class)getSDWebImageProxyClass {
  Class SDWebImageProxyClass = NSClassFromString(@"ABKSDWebImageProxy");
  if (SDWebImageProxyClass == nil) {
    NSLog(CORE_VERSION_WARNING);
    return nil;
  }
  if (![SDWebImageProxyClass isSupportedSDWebImageVersion]) {
    NSLog(@"The SDWebImage version is unsupported.");
    return nil;
  }
  return SDWebImageProxyClass;
}

+ (Class)getModalFeedViewControllerClass {
  return NSClassFromString(@"ABKNewsFeedViewController");
}

+ (BOOL)isiPhoneX {
  return [[UIScreen mainScreen] nativeBounds].size.height == iPhoneXHeight;
}

+ (UIImage *)getImageWithName:(NSString *)name
                         type:(NSString *)type
               inAppboyBundle:(NSBundle *)appboyBundle {
  NSString *imagePath = [appboyBundle pathForResource:name ofType:type];
  UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
  return image;
}

@end
