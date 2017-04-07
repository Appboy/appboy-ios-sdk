#import <Foundation/Foundation.h>

/*
 * Appboy Public API: ABKPushURIDelegate
 */
NS_ASSUME_NONNULL_BEGIN
__deprecated_msg("Use ABKURLDelegate instead.")
@protocol ABKPushURIDelegate <NSObject>
/*!
 * @param URIString The URI string in the Appboy push payload.
 * @param notificationInfo The push payload dictionary with the deep link.
 *
 * When there is a URI in a push payload sent by Appboy, this method will be called right before
 * Appboy SDK opens the URI. If you want Appboy SDK to handle the URI, return NO. If
 * you return YES in the delegate method, Appboy SDK won't open the URI.
 */
- (BOOL)handleAppboyPushURI:(NSString *)URIString withNotificationInfo:(NSDictionary *)notificationInfo;

@end
NS_ASSUME_NONNULL_END
