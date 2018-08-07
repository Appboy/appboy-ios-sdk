#import "ABKClassicImageContentCardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ABKClassicImageContentCardCell

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.classicImageView sd_cancelCurrentAnimationImagesLoad];
}

- (void)applyCard:(ABKClassicContentCard *)card {
  if (![card isKindOfClass:[ABKClassicContentCard class]]) {
    return;
  }
  [super applyCard:card];
  [self.classicImageView sd_setImageWithURL:[NSURL URLWithString:card.image]
                           placeholderImage:[self getPlaceHolderImage]
                                    options:(SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync)];
}

@end
