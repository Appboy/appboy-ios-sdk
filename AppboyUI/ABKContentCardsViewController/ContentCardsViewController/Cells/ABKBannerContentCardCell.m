#import "ABKBannerContentCardCell.h"
#import "ABKBannerCard.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ABKBannerContentCardCell

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.bannerImageView sd_cancelCurrentAnimationImagesLoad];
}

- (void)applyCard:(ABKBannerContentCard *)card {
  if (![card isKindOfClass:[ABKBannerContentCard class]]) {
    return;
  }
  
  [super applyCard:card];
  [self updateImageConstraintsWithRatio:card.imageAspectRatio];
  
  typeof(self) __weak weakSelf = self;
  [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:card.image] placeholderImage:nil options:(SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    if (weakSelf == nil) {
      return;
    }
    if (image && image.size.height > 0.0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat newRatio = image.size.width / image.size.height;
        [weakSelf updateImageConstraintsWithRatio:newRatio];
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.bannerImageView.image = [weakSelf getPlaceHolderImage];
      });
    }
  }];
}

- (void)updateImageConstraintsWithRatio:(CGFloat)newRatio {
  if (self.imageRatioConstraint && fabs(newRatio - self.imageRatioConstraint.multiplier) < 0.1f) {
    // constraint already installed with correct multiplier
    return;
  }
  
  if (self.imageRatioConstraint) {
    self.imageRatioConstraint.active = NO;
  }
  self.imageRatioConstraint = [NSLayoutConstraint constraintWithItem:self.bannerImageView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.bannerImageView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:newRatio
                                                            constant:0];
  self.imageRatioConstraint.active = YES;
  [self setNeedsLayout];
}

@end
