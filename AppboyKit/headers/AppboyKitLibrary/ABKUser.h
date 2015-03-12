//
//  ABKUser.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

#import <Foundation/Foundation.h>

@class ABKFacebookUser;

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
 *      image_url
 *      push_subscribe
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

@property (nonatomic, copy, readonly) NSString *userID;

/*!
 * The User's avatar image URL. This URL will be processed by the server and used in their user profile on the
 * dashboard. (String)
 */
@property (nonatomic, copy) NSString *avatarImageURL;

/*!
 * The Twitter account identifier for this user. If set, Appboy will only attempt to obtain Twitter data from the
 * Accounts framework if the account with the specified identifier is available. See the
 * ABKSocialAccountAcquisitionPolicy documentation in Appboy.h for more information.
 */
@property (nonatomic, copy) NSString *twitterAccountIdentifier;

/*!
 * This property is for when a user's twitter account with the given identifier isn't available, should Appboy also
 * delete the saved twitter account in the server of that user.
 *
 * The default value of this property is NO. If the property is set to YES, when the twitter account data with the given
 * twitter identifier(defined in the ABKUser's twitterAccountIdentifier property) isn't available, Appboy will also delete
 * Appboy will delete the saved twitter account data of that user in Appboy's database.
 *
 * This property is only used when in appboyOptions, ABKSocialAccountAcquisitionPolicyOptionKey is set to be
 * ABKAutomaticSocialAccountAcquisitionWithIdentifierOnly, and twitterAccountIdentifier property has a valid value.
 */
@property (nonatomic, assign) BOOL clearTwitterDataWhenNoDataOfTwitterIdentifier;

/*!
 * The User's Facebook account information. For more detail, please refer to ABKFacebookUser.h.
 */
@property (nonatomic, retain) ABKFacebookUser *facebookUser;

/* ------------------------------------------------------------------------------------------------------
 * Enums
 */

/*!
 * Values representing the gender recognized by the SDK.
 */
typedef NS_ENUM(NSInteger , ABKUserGenderType) {
  ABKUserGenderMale,
  ABKUserGenderFemale
};

/*!
* Convenience enum to represent notification status, for email and push notifications.
*
* OPTED_IN: subscribed, and explicitly opted in.
* SUBSCRIBED: subscribed, but not explicitly opted in.
* UNSUBSCRIBED: unsubscribed and/or explicitly opted out.
*/
typedef NS_ENUM(NSInteger, ABKNotificationSubscriptionType) {
  ABKOptedIn,
  ABKSubscribed,
  ABKUnsubscribed
};

/*!
 * @param gender ABKUserGender enum representing the user's gender.
 * @return YES if the user gender is set properly
 */
- (BOOL) setGender:(ABKUserGenderType)gender;


/*!
 * Deprecated: Use setEmailNotificationSubscriptionType instead.
 *
 * @param subscribed Whether or not this user should be subscribed to emails
 * @return YES if isSubscribedToEmail is set the same as parameter subscribed
 */
- (BOOL) setIsSubscribedToEmails:(BOOL)subscribed __deprecated;

/*!
 * Sets whether or not the user should be sent email campaigns. Setting it to unsubscribed opts the user out of
 * an email campaign that you create through the Appboy dashboard.
 *
 * @param emailNotificationSubscriptionType enum representing the user's email notifications subscription type.
 * @return YES if the field is set successfully, else NO.
 */
- (BOOL) setEmailNotificationSubscriptionType:(ABKNotificationSubscriptionType)emailNotificationSubscriptionType;

/*!
 * Sets the push notification subscription status of the user. Used to collect information about the user.
 *
 * @param pushNotificationSubscriptionType enum representing the user's push notifications subscription type.
 * @return YES if the field is set successfully, else NO.
 */
- (BOOL) setPushNotificationSubscriptionType:(ABKNotificationSubscriptionType)pushNotificationSubscriptionType;

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

/**
 * Adds the string value to a custom attribute string array specified by the key. If you add a key that has not
 * previously been set, a custom attribute string array will be created containing the value.
 *
 * @param key The custom attribute key
 * @param value A string to be added to the custom attribute string array
 * @return YES if the operation was successful
 */
- (BOOL) addToCustomAttributeArrayWithKey:(NSString *)key value:(NSString *)value;

/**
 * Removes the string value from a custom attribute string array specified by the key. If you remove a key that has not
 * previously been set, nothing will be changed.
 *
 * @param key The custom attribute key
 * @param value A string to be removed from the custom attribute string array
 * @return YES if the operation was successful
 */
- (BOOL) removeFromCustomAttributeArrayWithKey:(NSString *)key value:(NSString *)value;

/**
 * Sets a string array from a custom attribute specified by the key.
 *
 * @param key The custom attribute key
 * @param valueArray A string array to set as a custom attribute. If this value is nil, then Appboy will unset the custom
 *        attribute and remove the corresponding array if there is one.
 * @return YES if the operation was successful
 */
- (BOOL) setCustomAttributeArrayWithKey:(NSString *)key array:(NSArray *)valueArray;

/*!
* Sets the last known location for the user. Intended for use with ABKDisableLocationAutomaticTrackingOptionKey set to YES
* when starting Appboy, so that the only locations being set are by the integrating app.  Otherwise, calls to this
* method will be contending with automatic location update events.
*
* @param latitude The latitude of the User's location in degrees, the number should be in the range of [-90, 90]
* @param longitude The longitude of the User's location in degrees, the number should be in the range of [-180, 180]
* @param horizontalAccuracy The accuracy of the User's horizontal location in meters, the number should not be negative
*/
- (BOOL) setLastKnownLocationWithLatitude:(double)latitude longitude:(double)longitude horizontalAccuracy:(double)horizontalAccuracy;

/*!
* Sets the last known location for the user. Intended for use with ABKDisableLocationAutomaticTrackingOptionKey set to YES
* when starting Appboy, so that the only locations being set are by the integrating app.  Otherwise, calls to this
* method will be contending with automatic location update events.
*
* @param latitude The latitude of the User's location in degrees, the number should be in the range of [-90, 90]
* @param longitude The longitude of the User's location in degrees, the number should be in the range of [-180, 180]
* @param horizontalAccuracy The accuracy of the User's horizontal location in meters, the number should not be negative
* @param altitude The altitude of the User's location in meters
* @param verticalAccuracy The accuracy of the User's vertical location in meters, the number should not be negative
*/
- (BOOL) setLastKnownLocationWithLatitude:(double)latitude
                                longitude:(double)longitude
                       horizontalAccuracy:(double)horizontalAccuracy
                                 altitude:(double)altitude
                         verticalAccuracy:(double)verticalAccuracy;

@end
