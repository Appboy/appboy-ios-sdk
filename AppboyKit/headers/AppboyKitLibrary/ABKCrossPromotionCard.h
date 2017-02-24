#import "ABKCard.h"

/*
 * Appboy Public API: ABKCrossPromotionCard
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKCrossPromotionCard : ABKCard <NSCoding>

/*
 * This is the type of iTunes media. The possible values are:
 *     ItunesAlbum
 *     ItunesAudiobook
 *     ItunesCompilation
 *     ItunesEbook
 *     ItunesFeatureMovie
 *     ItunesPodcast
 *     ItunesSoftware
 *     ItunesSong
 *     ItunesTvEpisode
 *     ItunesTvSeason
 */
@property (copy) NSString *mediaType;

/*
 * The title text for the card. This will be the promoted item's name.
 */
@property (copy) NSString *title;

/*
 * The text of the category of the promoted item.
 */
@property (copy) NSString *subtitle;

/*
 * This property is the URL of the card's image.
 */
@property (copy) NSString *image;

/*
 * A localized display price string.
 */
@property (copy, nullable) NSString *displayPrice;

/*
 * The iTunes ID number of the promoted item.
 */
@property (nonatomic) long long iTunesId;

/*
 * The rating of the promoted app.
 * This property will be 0.0 unless the promoted item is an app, and the rating will be in the range
 * of [0.0, 5.0];
 */
@property (nonatomic) float rating;

/*
 * The price of the promoted item in Apple App Store.
 */
@property (nonatomic) float price;

/*
 * The number of reviews of the promoted app.
 * This property will be 0 unless the promoted item is an app.
 */
@property (nonatomic) int reviews;

/*
 * This property is the text that will be displayed in the tag on the top of the small cross promotion 
 * card.
 */
@property (copy) NSString *caption;

//Optional:
/*
 * This property indicates if the promoted item is universal or not.
 */
@property BOOL universal;

@end
NS_ASSUME_NONNULL_END
