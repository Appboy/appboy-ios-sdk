#import "ABKUIUtils.h"
#import "ABKSDWebImageProxy.h"

static NSString *const LocalizedAppboyStringNotFound = @"not found";
static NSUInteger const iPhoneXHeight = 2436.0;
static NSUInteger const iPhoneXRHeight = 1792.0;
static NSUInteger const iPhoneXSMaxHeight = 2688.0;
static NSUInteger const iPhoneXRScaledHeight = 1624.0;

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

+ (BOOL)isNotchedPhone {
  return ([[UIScreen mainScreen] nativeBounds].size.height == iPhoneXHeight ||
          [[UIScreen mainScreen] nativeBounds].size.height == iPhoneXRHeight ||
          [[UIScreen mainScreen] nativeBounds].size.height == iPhoneXSMaxHeight ||
          [[UIScreen mainScreen] nativeBounds].size.height == iPhoneXRScaledHeight);
}

+ (UIImage *)getImageWithName:(NSString *)name
                         type:(NSString *)type
               inAppboyBundle:(NSBundle *)appboyBundle {
  NSString *imagePath = [appboyBundle pathForResource:name ofType:type];
  UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
  return image;
}

@end
