#import "ABKCard.h"

/*
 * Appboy Public API: ABKClassicCard
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKClassicCard : ABKCard <NSCoding>

/*
 * This property is the URL of the card's image.
 */
@property (copy, nullable) NSString *image;
/*
 * The description text for the card.
 */
@property (copy) NSString *cardDescription;

//Optional:
/*
 * The URL that will be opened after the card is clicked on. It can be a http(s) URL or a protocol URL.
 */
@property (copy, nullable) NSString *url;
/*
 * The news title text for the card.
 */
@property (copy, nullable) NSString *title;
/*
 * The link text for the property url, like @"blog.appboy.com". It can be displayed on the card's
 * UI to indicate the action/direction of clicking on the card.
 */
@property (copy, nullable) NSString *domain;

@end
NS_ASSUME_NONNULL_END
