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

/*
 * The categories assigned to the card.
 */
@property (nonatomic, assign) ABKCardCategory categories;

/*
 * @param cardDictionary The dictionary for card deserialization.
 *
 * Deserializes the dictionary to a card for use by wrappers such as Appboy's Unity SDK for iOS.
 * When the deserialization isn't successful, this method returns nil; otherwise, it returns the deserialized card.
 */
+ (ABKCard *) deserializeCardFromDictionary:(NSDictionary *)cardDictionary;

/*
 * Serializes the card to binary data for use by wrappers such as Appboy's Unity SDK for iOS.
 */
- (NSData *) serializeToData;

/*
 * Manually log an impression to Appboy for the card.
 * This should only be used for custom news feed view controller. ABKFeedViewController already has card impression logging.
 */
- (void) logCardImpression;

/*
 * Manually log a click to Appboy for the card.
 * * This should only be used for custom news feed view controller. ABKFeedViewController already has card click logging.
 */
- (void) logCardClicked;

- (BOOL) hasSameId:(ABKCard *)card;
@end
