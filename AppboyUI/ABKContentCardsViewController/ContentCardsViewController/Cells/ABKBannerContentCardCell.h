#import "ABKBaseContentCardCell.h"
#import "ABKBannerContentCard.h"

@interface ABKBannerContentCardCell : ABKBaseContentCardCell

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;

- (void)applyCard:(ABKBannerContentCard *)bannerCard;

- (void)updateImageConstraintsWithRatio:(CGFloat)newRatio;

@end
