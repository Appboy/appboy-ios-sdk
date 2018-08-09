#import "ABKCaptionedImageContentCardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ABKCaptionedImageContentCardCell

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.captionedImageView sd_cancelCurrentAnimationImagesLoad];
}

- (void)hideLinkLabel:(BOOL)hide {
  self.linkLabel.hidden = hide;
  if (hide) {
    if ((self.linkBottomConstraint.priority != UILayoutPriorityDefaultLow)
        || (self.descriptionBottomConstraint.priority != UILayoutPriorityDefaultHigh)) {
      self.linkBottomConstraint.priority = UILayoutPriorityDefaultLow;
      self.descriptionBottomConstraint.priority = UILayoutPriorityDefaultHigh;
      [self setNeedsLayout];
    }
  } else {
    if ((self.linkBottomConstraint.priority != UILayoutPriorityDefaultHigh)
        || (self.descriptionBottomConstraint.priority != UILayoutPriorityDefaultLow)) {
      self.linkBottomConstraint.priority = UILayoutPriorityDefaultHigh;
      self.descriptionBottomConstraint.priority = UILayoutPriorityDefaultLow;
      [self setNeedsLayout];
    }
  }
}

- (void)applyCard:(ABKCaptionedImageContentCard *)captionedImageCard {
  if (![captionedImageCard isKindOfClass:[ABKCaptionedImageContentCard class]]) {
    return;
  }
  
  [super applyCard:captionedImageCard];
  
  [self applyAppboyAttributedTextStyleFrom:captionedImageCard.title forLabel:self.titleLabel];
  [self applyAppboyAttributedTextStyleFrom:captionedImageCard.cardDescription forLabel:self.descriptionLabel];
  [self applyAppboyAttributedTextStyleFrom:captionedImageCard.domain forLabel:self.linkLabel];
  
  BOOL shouldHideLink = (captionedImageCard.domain.length == 0);
  [self hideLinkLabel:shouldHideLink];
  
  CGFloat currImageHeightConstraint = self.captionedImageView.frame.size.width / captionedImageCard.imageAspectRatio;
  [self updateImageConstraintsWithNewConstant:currImageHeightConstraint];
  
  typeof(self) __weak weakSelf = self;
  [self.captionedImageView sd_setImageWithURL:[NSURL URLWithString:captionedImageCard.image] placeholderImage:nil options:(SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    if (weakSelf == nil) {
      return;
    }
    if (image && image.size.width > 0.0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat newImageHeightConstraint = weakSelf.captionedImageView.frame.size.width * image.size.height / image.size.width;
        [weakSelf updateImageConstraintsWithNewConstant:newImageHeightConstraint];
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.captionedImageView.image = [weakSelf getPlaceHolderImage];
      });
    }
  }];
}
 
- (void)updateImageConstraintsWithNewConstant:(CGFloat)newConstant {
  if (fabs(newConstant - self.imageHeightContraint.constant) < 5e-1) {
    return;
  }
  self.imageHeightContraint.constant = newConstant;
  [self setNeedsLayout];
}

@end
