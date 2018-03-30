#import <Foundation/Foundation.h>

/*
 * Braze Public API: ABKPushURIDelegate
 */
NS_ASSUME_NONNULL_BEGIN
__deprecated_msg("Use ABKURLDelegate instead.")
@protocol ABKPushURIDelegate <NSObject>
/*!
 * @param URIString The URI string in the Braze push payload.
 * @param notificationInfo The push payload dictionary with the deep link.
 *
 * When there is a URI in a push payload sent by Braze, this method will be called right before
 * Braze SDK opens the URI. If you want Braze SDK to handle the URI, return NO. If
 * you return YES in the delegate method, Braze SDK won't open the URI.
 */
- (BOOL)handleAppboyPushURI:(NSString *)URIString withNotificationInfo:(NSDictionary *)notificationInfo;

@end
NS_ASSUME_NONNULL_END
