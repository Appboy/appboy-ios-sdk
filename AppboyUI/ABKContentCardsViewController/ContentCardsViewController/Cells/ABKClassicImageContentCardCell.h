#import "ABKClassicContentCardCell.h"

/*!
 * The ABKClassicContentCard has an optional image property.
 * Use this view controller for a classic card with an image and ABKClassicContentCardCell for a
 * classic card without an image.
 */
@interface ABKClassicImageContentCardCell : ABKClassicContentCardCell

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *classicImageView;

- (void)applyCard:(ABKClassicContentCard *)classicCard;

@end
