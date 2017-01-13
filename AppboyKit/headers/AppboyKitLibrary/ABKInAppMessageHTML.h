#import <Foundation/Foundation.h>
#import "ABKInAppMessage.h"

/*
 * Appboy Public API: ABKInAppMessageHTML
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageHTML : ABKInAppMessage
/*!
 * This property is the remote URL of the assets zip file.
 */
@property (strong, nullable) NSURL *assetsZipRemoteUrl;

/*!
 * Log a click on the in-app message with a buttonId. Clicks may only be logged once per in-app message.
 *
 * @param buttonId the id of the click
 */
- (void)logInAppMessageHTMLClickWithButtonID:(NSString *)buttonId;

@end
NS_ASSUME_NONNULL_END
