#import "ABKCard.h"

/*
 * Appboy Public API: ABKBannerCard
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKBannerCard : ABKCard <NSCoding>

/* 
 * This property is the URL of the card's image.
 */
@property (copy) NSString *image;

//Optional:
/*
 * The URL that will be opened after the card is clicked on. It can be a http(s) URL or a protocol URL.
 */
@property (copy, nullable) NSString *url;

/*
 * The link text for the property url, like @"blog.appboy.com". It can be displayed on the card's
 * UI to indicate the action/direction of clicking on the card.
 */
@property (copy, nullable) NSString *domain;

/*
 * This property is the aspect ratio of the card's image.
 */
@property float imageAspectRatio;

@end
NS_ASSUME_NONNULL_END
