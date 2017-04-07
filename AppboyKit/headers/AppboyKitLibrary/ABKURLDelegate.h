#import <Foundation/Foundation.h>

/*
 * Appboy Public API: ABKURLDelegate
 */
NS_ASSUME_NONNULL_BEGIN


/*
 * The ABKChannel defines the messaging channel from which a URL was served.
 *  ABKPushNotificationChannel - The URL came from a clicked push notification.
 *  ABKInAppMessageChannel - The URL came from a click on the body or button of an in-app message. See ABKInAppMessage or ABKInAppMessageButton.
 *  ABKNewsFeedChannel - The URL came from a clicked News Feed card. See ABKCard.
 */
typedef NS_ENUM(NSInteger, ABKChannel) {
  ABKPushNotificationChannel,
  ABKInAppMessageChannel,
  ABKNewsFeedChannel
};

@protocol ABKURLDelegate <NSObject>

/*!
 * @param url The deep link or web URL being offered to the delegate method.
 * @param channel An enum representing the URL's associated messaging channel.
 * @param extras The extras dictionary associated with the campaign or messaging object that the URL originated from.
                 Extras may be specified as key-value pairs on the Appboy dashboard.
 * @return Boolean value which controls whether or not Appboy will handle opening the URL. Returning YES will
 *         prevent Appboy from opening the URL. Returning NO will cause Appboy to handle opening the URL.
 *
 * This delegate method is fired whenever the user attempts to open a URL sent by Appboy. You can use this delegate
 * to customize Appboy's URL handling.
 */
- (BOOL)handleAppboyURL:(NSURL *)url fromChannel:(ABKChannel)channel withExtras:(NSDictionary *)extras;

@end
NS_ASSUME_NONNULL_END
