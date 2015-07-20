#import <Foundation/Foundation.h>
/*
 * This ABWKUser class is parallel with the ABKUser in the Appboy iOS SDK.
 *
 * NOTE: Make sure you DO NOT pass a nil as a parameter, otherwise the watch SDK will throw an exception
 * when trying to parse the data into a dictionary.
 */
@interface ABWKUser : NSObject

+ (void) setFirstName:(NSString *)firstName;

+ (void) setLastName:(NSString *)lastName;

+ (void) setEmail:(NSString *)email;

+ (void) setDateOfBirth:(NSDate *)dateOfBirth;

+ (void) setCountry:(NSString *)country;

+ (void) setHomeCity:(NSString *)homeCity;

+ (void) setBio:(NSString *)bio;

+ (void) setPhone:(NSString *)phone;

+ (void) setAvatarImageURL:(NSString *)avatarImageURL;

+ (void) setCustomAttributeWithKey:(NSString *)key andBOOLValue:(BOOL)value;

+ (void) setCustomAttributeWithKey:(NSString *)key andIntegerValue:(NSInteger)value;

+ (void) setCustomAttributeWithKey:(NSString *)key andDoubleValue:(double)value;

+ (void) setCustomAttributeWithKey:(NSString *)key andStringValue:(NSString *)value;

+ (void) setCustomAttributeWithKey:(NSString *)key andDateValue:(NSDate *)value;

+ (void) unsetCustomAttributeWithKey:(NSString *)key;

+ (void) incrementCustomUserAttribute:(NSString *)key;

+ (void) incrementCustomUserAttribute:(NSString *)key by:(NSInteger)incrementValue;

+ (void) addToCustomAttributeArrayWithKey:(NSString *)key value:(NSString *)value;

+ (void) removeFromCustomAttributeArrayWithKey:(NSString *)key value:(NSString *)value;

+ (void) setCustomAttributeArrayWithKey:(NSString *)key array:(NSArray *)valueArray;

+ (void) setLastKnownLocationWithLatitude:(double)latitude longitude:(double)longitude horizontalAccuracy:(double)horizontalAccuracy;

+ (void) setLastKnownLocationWithLatitude:(double)latitude
                                longitude:(double)longitude
                       horizontalAccuracy:(double)horizontalAccuracy
                                 altitude:(double)altitude
                         verticalAccuracy:(double)verticalAccuracy;

@end
