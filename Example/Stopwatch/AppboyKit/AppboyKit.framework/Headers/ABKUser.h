//
//  ABKUser.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

#import <Foundation/Foundation.h>

/*!
 * When setting the custom attributes with custom keys:
 *
 * 1. Attempting to set a custom attribute with the same key as one of our reserved keys is prohibited. To set values
 *    for reserved keys, please find and set the corresponding property in this class. The reserved key list is::
 *      email
 *      facebook
 *      twitter
 *      first_name
 *      last_name
 *      dob
 *      external_id
 *      country
 *      home_city
 *      bio
 *      gender
 *      phone
 *      email_subscribe
 *      foursquare_access_token
 *
 * 2. The maximum key length is 255 characters; longer keys are truncated.
 *
 * 3. The maximum length for a string value in a custom attribute is 255 characters; longer values are truncated.
 */

@interface ABKUser : NSObject

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
 * The User's phone number (String)
 */
@property (nonatomic, copy) NSString *phone;

/*!
 * The User's foursquare access token (String)
 */
@property (nonatomic, copy) NSString *foursquareAccessToken;

/*!
 * Values representing the gender recognized by the SDK.
 */
typedef enum {
  ABKUserGenderMale = 1 << 0,
  ABKUserGenderFemale = 1 << 1
}ABKUserGenderType;

/*!
 * @param gender ABKUserGender enum representing the user's gender.
 * @return YES if the user gender is set properly
 */
- (BOOL) setGender:(ABKUserGenderType)gender;


/*!
 * @param subscribed Whether or not this user should be subscribed to emails
 * @return YES if isSubscribedToEmail is set the same as parameter subscribed
 */
- (BOOL) setIsSubscribedToEmails:(BOOL)subscribed;

/*!
 * @param key The String name of the custom user attribute
 * @param value A boolean value to set as a custom attribute
 * @return whether or not the custom user attribute was set successfully; If not, your key might have been nil or empty,
 *         your value might have been invalid (either nil, or not of the correct type), or you tried to set a value for
 *         one of the reserved keys. Please check the log for more details about the specific failure you encountered.
 */
- (BOOL) setCustomAttributeWithKey:(NSString *)key andBOOLValue:(BOOL)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value An integer value to set as a custom attribute
 * @return whether or not the custom user attribute was set successfully; If not, your key might have been nil or empty,
 *         your value might have been invalid (either nil, or not of the correct type), or you tried to set a value for
 *         one of the reserved keys. Please check the log for more details about the specific failure you encountered.
 */
- (BOOL) setCustomAttributeWithKey:(NSString *)key andIntegerValue:(NSInteger)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value A double value to set as a custom attribute
 * @return whether or not the custom user attribute was set successfully; If not, your key might have been nil or empty,
 *         your value might have been invalid (either nil, or not of the correct type), or you tried to set a value for
 *         one of the reserved keys. Please check the log for more details about the specific failure you encountered.
 */
- (BOOL) setCustomAttributeWithKey:(NSString *)key andDoubleValue:(double)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value An NSString value to set as a custom attribute
 * @return whether or not the custom user attribute was set successfully; If not, your key might have been nil or empty,
 *         your value might have been invalid (either nil, or not of the correct type), or you tried to set a value for
 *         one of the reserved keys. Please check the log for more details about the specific failure you encountered.
 */
- (BOOL) setCustomAttributeWithKey:(NSString *)key andStringValue:(NSString *)value;

/*!
 * @param key The String name of the custom user attribute
 * @param value An NSDate value to set as a custom attribute
 * @return whether or not the custom user attribute was set successfully; If not, your key might have been nil or empty,
 *         your value might have been invalid (either nil, or not of the correct type), or you tried to set a value for
 *         one of the reserved keys. Please check the log for more details about the specific failure you encountered.
 */
- (BOOL) setCustomAttributeWithKey:(NSString *)key andDateValue:(NSDate *)value;

/*!
 * @param key The String name of the custom user attribute to unset
 * @return whether or not the custom user attribute was unset successfully
 */
- (BOOL) unsetCustomAttributeWithKey:(NSString *)key;

/**
   * Increments the value of an custom attribute by one. Only integer and long custom attributes can be incremented.
   * Attempting to increment a custom attribute that is not an integer or a long will be ignored. If you increment a
   * custom attribute that has not previously been set, a custom attribute will be created and assigned a value of one.
   *
   * @param key The identifier of the custom attribute
   * @return YES if the increment for the custom attribute of given key is saved
   */
- (BOOL) incrementCustomUserAttribute:(NSString *)key;

/**
 * Increments the value of an custom attribute by a given amount. Only integer and long custom attributes can be
 * incremented. Attempting to increment a custom attribute that is not an integer or a long will be ignored. If
 * you increment a custom attribute that has not previously been set, a custom attribute will be created and assigned
 * the value of incrementValue. To decrement the value of a custom attribute, use a negative incrementValue.
 *
 * @param key The identifier of the custom attribute
 * @param incrementValue The amount by which to increment the custom attribute
 * @return YES if the increment for the custom attribute of given key is saved
 */
- (BOOL) incrementCustomUserAttribute:(NSString *)key by:(NSInteger)incrementValue;
@end
