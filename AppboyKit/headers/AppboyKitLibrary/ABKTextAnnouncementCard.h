#import "ABKCard.h"

/*
 * Appboy Public API: ABKTextAnnouncementCard
 */
@interface ABKTextAnnouncementCard : ABKCard <NSCoding>

/*
 * The title text for the card.
 */
@property (nonatomic, copy) NSString *title;
/*
 * The description text for the card.
 */
@property (nonatomic, copy) NSString *cardDescription;

//Optional:
/*
 * The URL that will be opened after the card is clicked on. It can be a http(s) URL or a protocol URL.
 */
@property (nonatomic, copy) NSString *url;
/*
 * The link text for the property url, like @"blog.appboy.com". It can be displayed on the card's
 * UI to indicate the action/direction of clicking on the card.
 */
@property (nonatomic, copy) NSString *domain;

@end
