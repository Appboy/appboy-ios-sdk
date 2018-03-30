#import <Foundation/Foundation.h>
#import "ABKInAppMessage.h"

/*
 * Braze Public API: ABKInAppMessageHTML
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageHTML : ABKInAppMessage
/*!
 * This property is the remote URL of the assets zip file.
 */
@property (strong, nullable) NSURL *assetsZipRemoteUrl;

/*!
 * This is the local URL of the assets directory for the HTML in-app message. Please note that the
 * value of this property can be overridden by Braze at the time of displaying, so please don't set
 * it as the value will be discarded.
 */
@property NSURL *assetsLocalDirectoryPath;

/*!
 * Log a click on the in-app message with a buttonId. Clicks may only be logged once per in-app message.
 *
 * @param buttonId the id of the click
 */
- (void)logInAppMessageHTMLClickWithButtonID:(NSString *)buttonId;

@end
NS_ASSUME_NONNULL_END
