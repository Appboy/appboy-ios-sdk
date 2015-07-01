#import "ABWKUser.h"
#import "AppboyWatchKit.h"
#import "AppboyWatchKitKeys.h"

@implementation ABWKUser

+ (void) setFirstName:(NSString *)firstName {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserFirstName infoArray:@[firstName]]];
}

+ (void) setLastName:(NSString *)lastName {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserLastName infoArray:@[lastName]]];
}

+ (void) setEmail:(NSString *)email {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserEmail infoArray:@[email]]];
}

+ (void) setDateOfBirth:(NSDate *)dateOfBirth {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserDateOfBirth infoArray:@[dateOfBirth]]];
}

+ (void) setCountry:(NSString *)country {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserCountry infoArray:@[country]]];
}

+ (void) setHomeCity:(NSString *)homeCity {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserHomeCity infoArray:@[homeCity]]];
}

+ (void) setBio:(NSString *)bio {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserBio infoArray:@[bio]]];
}

+ (void) setPhone:(NSString *)phone {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserPhone infoArray:@[phone]]];
}

+ (void) setAvatarImageURL:(NSString *)avatarImageURL {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserAvatarImageURL infoArray:@[avatarImageURL]]];
}

+ (void) setCustomAttributeWithKey:(NSString *)key andBOOLValue:(BOOL)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserCustomAttribute
                                                            infoArray:@[ABWKUserBoolCustomAttributeKey, key, @(value)]]];
}

+ (void) setCustomAttributeWithKey:(NSString *)key andIntegerValue:(NSInteger)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserCustomAttribute
                                                            infoArray:@[ABWKUserIntegerCustomAttributeKey, key, @(value)]]];
}

+ (void) setCustomAttributeWithKey:(NSString *)key andDoubleValue:(double)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserCustomAttribute
                                                            infoArray:@[ABWKUserDoubleCustomAttributeKey, key, @(value)]]];
}

+ (void) setCustomAttributeWithKey:(NSString *)key andStringValue:(NSString *)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserCustomAttribute
                                                            infoArray:@[ABWKUserStringCustomAttributeKey, key, value]]];
}

+ (void) setCustomAttributeWithKey:(NSString *)key andDateValue:(NSDate *)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserCustomAttribute
                                                            infoArray:@[ABWKUserDateCustomAttributeKey, key, value]]];
}

+ (void) unsetCustomAttributeWithKey:(NSString *)key {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserUnsetCustomAttribute infoArray:@[key]]];
}

+ (void) incrementCustomUserAttribute:(NSString *)key {
  [self incrementCustomUserAttribute:key by:1];
}

+ (void) incrementCustomUserAttribute:(NSString *)key by:(NSInteger)incrementValue {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserIncrementCustomAttribute infoArray:@[key, @(incrementValue)]]];
}

+ (void) addToCustomAttributeArrayWithKey:(NSString *)key value:(NSString *)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserAddToCustomArray infoArray:@[key, value]]];
}

+ (void) removeFromCustomAttributeArrayWithKey:(NSString *)key value:(NSString *)value {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserRemoveFromCustomArray infoArray:@[key, value]]];
}

+ (void) setCustomAttributeArrayWithKey:(NSString *)key array:(NSArray *)valueArray {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserSetCustomArray infoArray:@[key, valueArray]]];
}

+ (void) setLastKnownLocationWithLatitude:(double)latitude longitude:(double)longitude horizontalAccuracy:(double)horizontalAccuracy {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserLocation
                                                            infoArray:@[@(latitude), @(longitude), @(horizontalAccuracy)]]];
}

+ (void) setLastKnownLocationWithLatitude:(double)latitude
                                longitude:(double)longitude
                       horizontalAccuracy:(double)horizontalAccuracy
                                 altitude:(double)altitude
                         verticalAccuracy:(double)verticalAccuracy {
  [AppboyWatchKit sendToiOSApp:[self userDataDictionaryWithChangeType:ABWKUserLocation
                                                            infoArray:@[@(latitude), @(longitude), @(horizontalAccuracy), @(altitude), @(verticalAccuracy)]]];
}

+ (NSDictionary *) userDataDictionaryWithChangeType:(ABWKUserUpdateType)updateType
                                          infoArray:(NSArray *)array {
  return @{ABWKKUserKey : @{ABWKKUserUpdateTypeKey : @(updateType),
                            ABWKUserDataArrayKey : array}};
}

@end
