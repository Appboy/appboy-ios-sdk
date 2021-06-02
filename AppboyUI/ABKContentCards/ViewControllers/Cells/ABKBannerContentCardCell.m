#import "ABKBannerContentCardCell.h"
#import "ABKBannerCard.h"
#import "Appboy.h"
#import "ABKImageDelegate.h"

static const CGFloat ImageMinResizingMultiplier = 0.1f;

@implementation ABKBannerContentCardCell

#pragma mark - SetUp

- (void)setUpUI {
  [super setUpUI];
  [self setUpBannerImageView];
}

#pragma mark BannerImageView

- (void)setUpBannerImageView {
  if (!self.bannerImageView) {
    self.bannerImageView = [[[self imageViewClass] alloc] init];
    self.bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bannerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.rootView addSubview:self.bannerImageView];

    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[bannerImageView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"bannerImageView" : self.bannerImageView}];
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bannerImageView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"bannerImageView" : self.bannerImageView}];
    [NSLayoutConstraint activateConstraints:verticalConstraints];

    self.imageRatioConstraint = [NSLayoutConstraint
                                 constraintWithItem:self.bannerImageView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.bannerImageView
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:(355 / 79)
                                 constant:0];
    self.imageRatioConstraint.priority = ABKContentCardPriorityLayoutVeryHighButBelowRequired;
    self.imageRatioConstraint.active = YES;
  }
}

#pragma mark - ApplyCard

- (void)applyCard:(ABKBannerContentCard *)card {
  if (![card isKindOfClass:[ABKBannerContentCard class]]) {
    return;
  }
  
  [super applyCard:card];

  [self.rootView bringSubviewToFront:self.unviewedLineView];
  
  if (![Appboy sharedInstance].imageDelegate) {
    NSLog(@"[APPBOY][WARN] %@ %s",
          @"ABKImageDelegate on Appboy is nil. Image loading may be disabled.",
          __PRETTY_FUNCTION__);
    return;
  }
  typeof(self) __weak weakSelf = self;
  [[Appboy sharedInstance].imageDelegate setImageForView:self.bannerImageView
                                   showActivityIndicator:NO
                                                 withURL:[NSURL URLWithString:card.image]
                                        imagePlaceHolder:[self getPlaceHolderImage]
                                               completed:^(UIImage * _Nullable image,
                                                           NSError * _Nullable error,
                                                           NSInteger cacheType,
                                                           NSURL * _Nullable imageURL) {
    if (weakSelf == nil) {
      return;
    }
    if (image && image.size.height > 0.0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat newRatio = image.size.width / image.size.height;
        if ([self shouldResizeImageWithNewRatio:newRatio]) {
          // Update image size based on actual downloaded image
          [weakSelf updateImageConstraintsWithRatio:newRatio];
          [weakSelf.delegate refreshTableViewCellHeights];
          card.imageAspectRatio = newRatio;
        }
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.bannerImageView.image = [weakSelf getPlaceHolderImage];
      });
    }
  }];
}

- (void)updateImageConstraintsWithRatio:(CGFloat)newRatio {
  if (self.imageRatioConstraint) {
    self.imageRatioConstraint.active = NO;
  }
  self.imageRatioConstraint = [self.bannerImageView.widthAnchor constraintEqualToAnchor:self.bannerImageView.heightAnchor multiplier:newRatio];
  self.imageRatioConstraint.active = YES;
  [self setNeedsLayout];
}

#pragma mark - Private methods

- (BOOL)shouldResizeImageWithNewRatio:(CGFloat)newRatio {
  return self.imageRatioConstraint &&
      fabs(newRatio - self.imageRatioConstraint.multiplier) > ImageMinResizingMultiplier;
}

@end
