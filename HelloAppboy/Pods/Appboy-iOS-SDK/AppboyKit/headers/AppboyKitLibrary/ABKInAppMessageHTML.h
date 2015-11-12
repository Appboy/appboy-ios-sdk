#import <Foundation/Foundation.h>
#import "ABKInAppMessage.h"

/*
 * Appboy Public API: ABKInAppMessageHTML
 */
@interface ABKInAppMessageHTML : ABKInAppMessage
/*!
 * This property is the remote URL of the assets zip file.
 */
@property NSURL *assetsZipRemoteUrl;

/*!
 * Log a click on the in-app message with a buttonID. Clicks may only be logged once per in-app message.
 *
 * @param buttonId the id of the click
 */
- (void) logInAppMessageHTMLClickWithButtonID:(NSString *)buttonID;
@end
