#import "ABKNFCaptionedMessageCardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ABKNFCaptionedMessageCardCell

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.captionedImageView sd_cancelCurrentAnimationImagesLoad];
}

- (void)hideLinkLabel:(BOOL)hide {
  self.linkLabel.hidden = hide;
  self.bodyAndLinkConstraint.constant = hide ? 0 : 13;
}

- (void)applyCard:(ABKCard *)card {
  [super applyCard:card];
  if ([card isKindOfClass:[ABKCaptionedImageCard class]]) {
    [self applyCaptionedImageCard:(ABKCaptionedImageCard *)card];
  } else if ([card isKindOfClass:[ABKTextAnnouncementCard class]]) {
    [self applyTextAnnouncementCard:(ABKTextAnnouncementCard *)card];
  }
}

- (void)applyCaptionedImageCard:(ABKCaptionedImageCard *)captionedImageCard {
  self.titleLabel.text = captionedImageCard.title;
  self.descriptionLabel.text = captionedImageCard.cardDescription;
  self.linkLabel.text = captionedImageCard.domain;
  BOOL shouldHideLink = captionedImageCard.domain == nil || captionedImageCard.domain.length == 0;
  [self hideLinkLabel:shouldHideLink];
  
  CGFloat currImageHeightConstraint = self.captionedImageView.frame.size.width / captionedImageCard.imageAspectRatio;
  self.imageHeightContraint.constant = currImageHeightConstraint;
  [self setNeedsUpdateConstraints];
  [self setNeedsDisplay];
  __weak typeof(self) weakSelf = self;
  [self.captionedImageView sd_setImageWithURL:[NSURL URLWithString:captionedImageCard.image]
                             placeholderImage:nil
                                      options:(SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync)
                                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                      if (weakSelf == nil) {
                                        return;
                                      }
                                      if (image) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          CGFloat newImageHeightConstraint = weakSelf.captionedImageView.frame.size.width * image.size.height / image.size.width;
                                          if (fabs(newImageHeightConstraint - currImageHeightConstraint) > 5e-1) {
                                            weakSelf.imageHeightContraint.constant = newImageHeightConstraint;
                                            [weakSelf setNeedsUpdateConstraints];
                                            [weakSelf setNeedsDisplay];
                                            if (weakSelf.onCellHeightUpdateBlock) {
                                              weakSelf.onCellHeightUpdateBlock();
                                            }
                                          }
                                        });
                                      } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          weakSelf.captionedImageView.image = [weakSelf getPlaceHolderImage];
                                        });
                                      }
                                    }];
}

- (void)applyTextAnnouncementCard:(ABKTextAnnouncementCard *)textAnnouncementCard {
  self.titleLabel.text = textAnnouncementCard.title;
  self.descriptionLabel.text = textAnnouncementCard.cardDescription;
  self.linkLabel.text = textAnnouncementCard.domain;
  BOOL shouldHideLink = textAnnouncementCard.domain == nil || textAnnouncementCard.domain.length == 0;
  [self hideLinkLabel:shouldHideLink];
  
  self.imageHeightContraint.constant = 0;
  [self setNeedsLayout];
}

@end
