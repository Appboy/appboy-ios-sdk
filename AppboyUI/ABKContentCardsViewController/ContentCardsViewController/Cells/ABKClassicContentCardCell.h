#import "ABKBaseContentCardCell.h"
#import "ABKClassicContentCard.h"

@interface ABKClassicContentCardCell : ABKBaseContentCardCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

- (void)applyCard:(ABKClassicContentCard *)classicCard;

@end
