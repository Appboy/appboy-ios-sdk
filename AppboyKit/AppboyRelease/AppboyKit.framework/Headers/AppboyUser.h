#import <Foundation/Foundation.h>

@interface AppboyUser : NSObject

/*!
 * The User's first name (String)
 */
@property (nonatomic, copy) NSString *firstName;

/*!
 * The User's last name (String)
 */
@property (nonatomic, copy) NSString *lastName;

/*!
 * The User's email (String)
 */
@property (nonatomic, copy) NSString *email;

/*!
 * The User's date of birth (NSDate)
 */
@property (nonatomic, copy) NSDate *dateOfBirth;

/*!
 * The User's country (String)
 */
@property (nonatomic, copy) NSString *country;

/*!
 * The User's home city (String)
 */
@property (nonatomic, copy) NSString *homeCity;

/*!
 * The User's bio (String)
 */
@property (nonatomic, copy) NSString *bio;

/*!
 * The User's gender (String)
 */
@property (nonatomic, copy) NSString *gender;

/*!
 * The User's phone number (String)
 */
@property (nonatomic, copy) NSString *phone;

/*!
 * @param subscribed Whether or not this user should be subscribed to emails
 */
- (void) setIsSubscribedToEmails:(BOOL)subscribed;

/*!
 * @param key The String name of the custom user attribute
 * @param value A boolean value to set as a custom attribute
 */
- (void) setCustomAttributeWithKey:(NSString *)key andBOOLValue:(BOOL)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value An integer value to set as a custom attribute
 */
- (void) setCustomAttributeWithKey:(NSString *)key andIntegerValue:(NSInteger)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value A double value to set as a custom attribute
 */
- (void) setCustomAttributeWithKey:(NSString *)key andDoubleValue:(double)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value An NSString value to set as a custom attribute
 */
- (void) setCustomAttributeWithKey:(NSString *)key andStringValue:(NSString *)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value An NSDate value to set as a custom attribute
 */
- (void) setCustomAttributeWithKey:(NSString *)key andDateValue:(NSDate *)value;

/*!
 * @param key The String name of the custom user attribute to unset
 */
- (void) unsetCustomAttributeWithKey:(NSString *)key;
@end
