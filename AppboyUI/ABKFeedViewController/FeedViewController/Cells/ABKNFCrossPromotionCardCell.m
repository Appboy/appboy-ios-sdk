#import "ABKNFCrossPromotionCardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ABKUIUtils.h"

@implementation ABKNFCrossPromotionCardCell

static CGFloat const ImageCornerRadius = 6.0;
static const NSInteger FirstStarViewTag = 100;
static const NSInteger LastStarViewTag = 104;

static NSString *const EmptyStarImage = @"img-star-empty";
static NSString *const HalfStarImage = @"img-star-half";
static NSString *const FilledStarImage = @"img-star-filled";
static NSString *const StarImageType = @"png";

- (void)awakeFromNib {
  [super awakeFromNib];
  self.crossPromotionImageView.layer.cornerRadius = ImageCornerRadius;
  self.crossPromotionImageView.layer.masksToBounds = YES;

}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.crossPromotionImageView sd_cancelCurrentAnimationImagesLoad];
}

- (IBAction)priceButtonClicked:(id)sender {
  [self.crossPromotionCard logCardClicked];
  [self.actionDelegate performSelector:@selector(openItunesStoreProductWithId:url:)
                            withObject:@(self.crossPromotionCard.iTunesId)
                            withObject:[NSURL URLWithString:self.crossPromotionCard.urlString]];
}

- (void)applyCard:(ABKCard *)card {
  [super applyCard:card];
  if (![card isKindOfClass:[ABKCrossPromotionCard class]]) {
    return;
  }
  ABKCrossPromotionCard *crossPromotionCard = (ABKCrossPromotionCard *)card;
  self.crossPromotionCard = crossPromotionCard;
  self.titleLabel.text = crossPromotionCard.title;
  self.subtitleLabel.text = crossPromotionCard.subtitle;
  self.reviewsLabel.text = [NSString stringWithFormat:@"(%d)", crossPromotionCard.reviews];
  NSString *priceString = [ABKUIUtils getLocalizedString:@"Appboy.feed.card.cross-promotion.price.free"
                                          inAppboyBundle:[NSBundle bundleForClass:[ABKNFCrossPromotionCardCell class]]
                                                   table:@"AppboyFeedLocalizable"];
  if (crossPromotionCard.price != 0.0) {
    NSString *priceFormat = [ABKUIUtils getLocalizedString:@"Appboy.feed.card.cross-promotion.price.format"
                                            inAppboyBundle:[NSBundle bundleForClass:[ABKNFCrossPromotionCardCell class]]
                                                     table:@"AppboyFeedLocalizable"];
    priceString = [NSString stringWithFormat:priceFormat, crossPromotionCard.price];
  }
  [self.priceButton setTitle:priceString forState:UIControlStateNormal];
  [self updateRatingUI:crossPromotionCard.rating];
  [self.crossPromotionImageView sd_setImageWithURL:[NSURL URLWithString:crossPromotionCard.image]
                                  placeholderImage:[self getPlaceHolderImage]
                                           options:(SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync)];
}

- (void)updateRatingUI:(CGFloat)rating {
  NSInteger ratingRoundedDown = (NSInteger)floor(rating);
  NSInteger ratingRoundedUp = (NSInteger) ceil(rating);
  
  for (NSInteger starTag = FirstStarViewTag; starTag < FirstStarViewTag + ratingRoundedDown; starTag ++) {
    [(UIImageView *)[self viewWithTag:starTag] setImage:[self filledStar]];
  }
  for (NSInteger starTag = ratingRoundedUp + FirstStarViewTag; starTag <= LastStarViewTag; starTag ++) {
    [(UIImageView *)[self viewWithTag:starTag] setImage:[self emptyStar]];
  }
  
  // Processing the remainder. A remainder between [0.25, 0.75) will be displayed as a half star.
  // Otherwise, it be rounded up/down to the nearest whole star.
  float remainder = rating - (float)ratingRoundedDown;
  if (remainder > 0.0f) {
    if (remainder < 0.25f) {
      [(UIImageView *)[self viewWithTag:ratingRoundedDown + FirstStarViewTag] setImage:[self emptyStar]];
    } else if (remainder < 0.75f) {
      [(UIImageView *)[self viewWithTag:ratingRoundedDown + FirstStarViewTag] setImage:[self halfStar]];
    } else {
      [(UIImageView *)[self viewWithTag:ratingRoundedDown + FirstStarViewTag] setImage:[self filledStar]];
    }
  }
}

- (UIImage *)filledStar {
  return [ABKUIUtils getImageWithName:FilledStarImage
                                 type:StarImageType
                       inAppboyBundle:[NSBundle bundleForClass:[ABKNFCrossPromotionCardCell class]]];
}

- (UIImage *)halfStar {
  return [ABKUIUtils getImageWithName:HalfStarImage
                                 type:StarImageType
                       inAppboyBundle:[NSBundle bundleForClass:[ABKNFCrossPromotionCardCell class]]];
}

- (UIImage *)emptyStar {
  return [ABKUIUtils getImageWithName:EmptyStarImage
                                 type:StarImageType
                       inAppboyBundle:[NSBundle bundleForClass:[ABKNFCrossPromotionCardCell class]]];
}

@end
