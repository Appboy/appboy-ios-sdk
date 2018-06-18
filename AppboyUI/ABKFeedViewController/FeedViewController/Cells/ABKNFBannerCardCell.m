#import "ABKNFBannerCardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ABKNFBannerCardCell

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.bannerImageView sd_cancelCurrentAnimationImagesLoad];
}

- (void)applyCard:(ABKCard *)card {
  if (![card isKindOfClass:[ABKBannerCard class]]) {
    return;
  }
  
  [super applyCard:card];
  ABKBannerCard *bannerCard = (ABKBannerCard *)card;
  
  [self updateImageRatioConstraintToRatio:bannerCard.imageAspectRatio];
  [self setNeedsUpdateConstraints];
  [self setNeedsDisplay];
  __weak typeof(self) weakSelf = self;
  [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerCard.image]
                          placeholderImage:nil
                                   options:(SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync) 
                                 completed:^(UIImage * _Nullable image, NSError * _Nullable error,
                                             SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   if (weakSelf == nil) {
                                     return;
                                   }
                                   if (image) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                       CGFloat newRatio = image.size.width / image.size.height;
                                       if (fabs(newRatio - weakSelf.imageRatioConstraint.multiplier) > 0.1f) {
                                         [weakSelf updateImageRatioConstraintToRatio:newRatio];
                                         [weakSelf setNeedsUpdateConstraints];
                                         [weakSelf setNeedsDisplay];
                                         if (weakSelf.onCellHeightUpdateBlock) {
                                           weakSelf.onCellHeightUpdateBlock();
                                         }
                                       }
                                     });
                                   } else {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                       weakSelf.bannerImageView.image = [weakSelf getPlaceHolderImage];
                                     });
                                   }
                                 }];
}

- (void)updateImageRatioConstraintToRatio:(CGFloat)newRatio {
  if (self.imageRatioConstraint) {
    [self.bannerImageView removeConstraint:self.imageRatioConstraint];
  }
  self.imageRatioConstraint = [NSLayoutConstraint constraintWithItem:self.bannerImageView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.bannerImageView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:newRatio
                                                            constant:0];
  [self.bannerImageView addConstraint:self.imageRatioConstraint];
}

@end
