#import "ABKNFBaseCardCell.h"
#import "ABKCrossPromotionCard.h"
#import "ABKNFCrossPromotionCardActionDelegate.h"

@interface ABKNFCrossPromotionCardCell : ABKNFBaseCardCell

@property (weak, nonatomic) IBOutlet UILabel *recommendedLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *crossPromotionImageView;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;

/*!
 * The cross promotion card the cell displays.
 */
@property (nonatomic) ABKCrossPromotionCard *crossPromotionCard;

/*!
 * The delegate which handles the cross promotion card click.
 */
@property (weak, nonatomic) id<ABKNFCrossPromotionCardActionDelegate> actionDelegate;

- (IBAction)priceButtonClicked:(id)sender;
- (void)applyCard:(ABKCrossPromotionCard *)crossPromotionCard;

@end
