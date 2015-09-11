#import <Foundation/Foundation.h>

/*
 * Appboy Public API: ABKTwitterUser
 */
@interface ABKTwitterUser : NSObject

/*!
 * @param userDescription The value returned from twitter user API with key "description". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property (copy) NSString* userDescription;

/*
 * @param twitterName The value returned from twitter user API with key "name". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property (copy) NSString* twitterName;

/*
 * @param profileImageUrl The value returned from twitter user API with key "profile_image_url". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property (copy) NSString* profileImageUrl;

/*
 * @param screenName The value returned from twitter user API with key "screen_name". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property (copy) NSString* screenName;

/*
 * @param followersCount The value returned from twitter user API with key "followers_count". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property NSInteger followersCount;

/*
 * @param friendsCount The value returned from twitter user API with key "friends_count". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property NSInteger friendsCount;

/*
 * @param statusesCount The value returned from twitter user API with key "statuses_count". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property NSInteger statusesCount;

/*
 * @param twitterID The value returned from twitter user API with key "id". Please
 * refer to https://dev.twitter.com/overview/api/users for more information.
 */
@property NSInteger twitterID;

@end
