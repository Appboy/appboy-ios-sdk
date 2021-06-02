#import "ABKBaseContentCardCell.h"
#import "ABKBannerContentCard.h"

@interface ABKBannerContentCardCell : ABKBaseContentCardCell

@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;

- (void)applyCard:(ABKBannerContentCard *)bannerCard;

- (void)updateImageConstraintsWithRatio:(CGFloat)newRatio;

/*!
 * @discussion specific view property initialization that is in place of Storyboard or XIB initialization.
 *  Called by the ABKBaseContentCardCell setUpUI method and is exposed here to allow overriding.
 */
- (void)setUpBannerImageView;

@end
