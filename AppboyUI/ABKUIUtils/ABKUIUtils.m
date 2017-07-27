#import "ABKUIUtils.h"

static NSString *const LocalizedAppboyStringNotFound = @"not found";

@implementation ABKUIUtils

+ (NSString *)getLocalizedString:(NSString *)key inAppboyBundle:(NSBundle *)appboyBundle table:(NSString *)table {
  // Check if the app has a customized localization for the given key
  NSString *localizedString = [[NSBundle mainBundle] localizedStringForKey:key
                                                                     value:LocalizedAppboyStringNotFound
                                                                     table:nil];
  if ([localizedString isEqualToString:LocalizedAppboyStringNotFound]) {
    // Check Appboy's localization in the given bundle
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
      // Couldn't find Appboy's localization for the given key, fetch the default value for the key
      // from Base.lproj.
      NSBundle *appboyBaseBundle = [NSBundle bundleWithPath:[appboyBundle pathForResource:@"Base" ofType:@"lproj"]];
      localizedString = [appboyBaseBundle localizedStringForKey:key
                                                          value:LocalizedAppboyStringNotFound
                                                          table:table];
    }
  }
  return localizedString;
}

@end
