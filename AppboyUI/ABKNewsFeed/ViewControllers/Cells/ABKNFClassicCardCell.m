#import "ABKNFClassicCardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ABKNFClassicCardCell

- (void)applyCard:(ABKCard *)card {
  [super applyCard:card];
  if (![card isKindOfClass:[ABKClassicCard class]]) {
    return;
  }
  ABKClassicCard *classicCard = (ABKClassicCard *)card;
  self.titleLabel.text = classicCard.title;
  self.descriptionLabel.text = classicCard.cardDescription;
  self.linkLabel.text = classicCard.domain;
  
  [self.classicImageView sd_setImageWithURL:[NSURL URLWithString:classicCard.image]
                           placeholderImage:[self getPlaceHolderImage]
                                    options:(SDWebImageQueryMemoryData | SDWebImageQueryDiskDataSync)];
}

@end
