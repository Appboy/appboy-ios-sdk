#import <Foundation/Foundation.h>
#import "ABKFeedController.h"

@interface ABKCard : NSObject <NSCopying, NSCoding>
/*
 * Card's ID.
 */
@property (nonatomic, readonly) NSString *idString;

/*
 * This property reflects if the card is read or unread by the user.
 */
@property (nonatomic, assign) BOOL viewed;

/*
 * The property is the unix timestamp of the card's creation time from Appboy dashboard.
 */
@property (nonatomic, assign, readonly) double created;

/*
 * The property is the unix timestamp of the card's latest update time from Appboy dashboard.
 */
@property (nonatomic, assign, readonly) double updated;

@property (nonatomic, assign) ABKCardCategory categories;

- (BOOL) hasSameId:(ABKCard *)card;

/*
 * Serializes the card to binary data for use by wrappers such as Appboy's Unity SDK for iOS.
 */
- (NSData *) serializeToData;

- (void) logCardImpression;
- (void) logCardClicked;
@end
