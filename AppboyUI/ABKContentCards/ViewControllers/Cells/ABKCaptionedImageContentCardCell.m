#import "ABKCaptionedImageContentCardCell.h"
#import "Appboy.h"
#import "ABKImageDelegate.h"
#import "ABKUIUtils.h"

static const CGFloat ImageMinResizingDifference = 5e-1;

@implementation ABKCaptionedImageContentCardCell

static UIColor *_titleLabelColor = nil;
static UIColor *_descriptionLabelColor = nil;
static UIColor *_linkLabelColor = nil;

+ (UIColor *)titleLabelColor {
  if (_titleLabelColor == nil) {
    if (@available(iOS 13.0, *)) {
      _titleLabelColor = [UIColor labelColor];
    } else {
      _titleLabelColor = [UIColor blackColor];
    }
  }
  return _titleLabelColor;
}

+ (void)setTitleLabelColor:(UIColor *)titleLabelColor {
  _titleLabelColor = titleLabelColor;
}

+ (UIColor *)descriptionLabelColor {
  if (_descriptionLabelColor == nil) {
    if (@available(iOS 13.0, *)) {
      _descriptionLabelColor = [UIColor labelColor];
    } else {
      _descriptionLabelColor = [UIColor blackColor];
    }
  }
  return _descriptionLabelColor;
}

+ (void)setDescriptionLabelColor:(UIColor *)descriptionLabelColor {
  _descriptionLabelColor = descriptionLabelColor;
}

+ (UIColor *)linkLabelColor {
  if (_linkLabelColor == nil) {
    if (@available(iOS 13.0, *)) {
      _linkLabelColor = [UIColor linkColor];
    } else {
      _linkLabelColor = [UIColor systemBlueColor];
    }
  }
  return _linkLabelColor;
}

+ (void)setLinkLabelColor:(UIColor *)linkLabelColor{
  _linkLabelColor = linkLabelColor;
}

#pragma mark - SetUp

- (void)setUpUI {
  [super setUpUI];
  [self setUpCaptionedImageView];
  [self setUpBackgroundTitleView];
  [self resetUpPinImageView];
  [self setUpTitleLabel];
  [self setUpDescriptionLabel];
  [self setUpLinkLabel];
}

#pragma mark CaptionedImageView

- (void)setUpCaptionedImageView {
  self.captionedImageView =  [[[self imageViewClass] alloc] init];
  self.captionedImageView.contentMode = UIViewContentModeScaleAspectFit;
  self.captionedImageView.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.captionedImageView];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[captionedImageView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"captionedImageView" : self.captionedImageView}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSLayoutConstraint *topConstraint = [self.captionedImageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor];
  topConstraint.priority = ABKContentCardPriorityLayoutRequiredBelowAppleRequired;

  self.imageHeightConstraint = [self.captionedImageView.heightAnchor constraintEqualToConstant:223];
  self.imageHeightConstraint.priority = ABKContentCardPriorityLayoutVeryHighButBelowRequired;
  [NSLayoutConstraint activateConstraints:@[topConstraint,self.imageHeightConstraint]];
}

#pragma mark BackgroundTitleView

- (void)setUpBackgroundTitleView {
  self.titleBackgroundView = [[UIView alloc] init];
  self.titleBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.titleBackgroundView];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[titleBackgroundView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"titleBackgroundView" : self.titleBackgroundView}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[captionedImageView]-0-[titleBackgroundView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                           views:@{
                                                                               @"titleBackgroundView" : self.titleBackgroundView,
                                                                               @"captionedImageView" : self.captionedImageView,
                                                                           }];
  [NSLayoutConstraint activateConstraints:verticalConstraints];
}

- (void)resetUpPinImageView {
  [self.pinImageView removeFromSuperview];
  
  [self.titleBackgroundView addSubview:self.pinImageView];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[pinImageView(20)]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"pinImageView" : self.pinImageView}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pinImageView(20)]"
                                                                           options:0
                                                                           metrics:nil
                                                                           views:@{@"pinImageView" : self.pinImageView}];
  [NSLayoutConstraint activateConstraints:verticalConstraints];
}

- (void)setUpTitleLabel {
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.font = [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleCallout weight:UIFontWeightBold];
  self.titleLabel.textColor = [self class].titleLabelColor;
  self.titleLabel.text = @"Title";
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.titleBackgroundView addSubview:self.titleLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[titleLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"titleLabel" : self.titleLabel}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  [self.titleLabel.topAnchor constraintEqualToAnchor:self.titleBackgroundView.topAnchor constant:17].active = YES;

  [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow - 1
                                     forAxis:UILayoutConstraintAxisHorizontal];
  [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                     forAxis:UILayoutConstraintAxisVertical];
  [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1
                                                   forAxis:UILayoutConstraintAxisVertical];
}

- (void)setUpDescriptionLabel {
  self.descriptionLabel = [[UILabel alloc] init];
  self.descriptionLabel.font = [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleFootnote weight:UIFontWeightRegular];
  self.descriptionLabel.textColor = [self class].descriptionLabelColor;
  self.descriptionLabel.text = @"Description";
  self.descriptionLabel.numberOfLines = 0;
  self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.titleBackgroundView addSubview:self.descriptionLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[descriptionLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"descriptionLabel" : self.descriptionLabel}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6].active = YES;

  [self.descriptionLabel setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                           forAxis:UILayoutConstraintAxisVertical];
  [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1
                                                         forAxis:UILayoutConstraintAxisVertical];

  self.descriptionBottomConstraint = [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:self.titleBackgroundView.bottomAnchor constant:-25];
  self.descriptionBottomConstraint.priority = UILayoutPriorityDefaultLow;
  self.descriptionBottomConstraint.active = YES;
}

- (void)setUpLinkLabel {
  self.linkLabel = [[UILabel alloc] init];
  self.linkLabel.font = [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleFootnote weight:UIFontWeightMedium];
  self.linkLabel.textColor = [self class].linkLabelColor;
  self.linkLabel.text = @"Link";
  self.linkLabel.numberOfLines = 0;
  self.linkLabel.lineBreakMode = NSLineBreakByCharWrapping;
  self.linkLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.titleBackgroundView addSubview:self.linkLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[linkLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"linkLabel" : self.linkLabel}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSLayoutConstraint *topConstraint = [self.linkLabel.topAnchor constraintGreaterThanOrEqualToAnchor:self.descriptionLabel.bottomAnchor constant:8];
  topConstraint.priority = UILayoutPriorityRequired;
  topConstraint.active = YES;
  self.linkBottomConstraint = [self.linkLabel.bottomAnchor constraintEqualToAnchor:self.titleBackgroundView.bottomAnchor constant:-25];
  self.linkBottomConstraint.priority = UILayoutPriorityDefaultHigh;
  self.linkBottomConstraint.active = YES;
}

#pragma mark - Update UI

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

#pragma mark - ApplyCard

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
  if ([self shouldResizeImageWithNewConstant:currImageHeightConstraint]) {
    [self updateImageConstraintsWithNewConstant:currImageHeightConstraint];
  }
  
  if (![Appboy sharedInstance].imageDelegate) {
    NSLog(@"[APPBOY][WARN] %@ %s",
          @"ABKImageDelegate on Appboy is nil. Image loading may be disabled.",
          __PRETTY_FUNCTION__);
    return;
  }
  typeof(self) __weak weakSelf = self;
  [[Appboy sharedInstance].imageDelegate setImageForView:self.captionedImageView
                                   showActivityIndicator:NO
                                                 withURL:[NSURL URLWithString:captionedImageCard.image]
                                        imagePlaceHolder:[self getPlaceHolderImage]
                                               completed:^(UIImage * _Nullable image,
                                                           NSError * _Nullable error,
                                                           NSInteger cacheType,
                                                           NSURL * _Nullable imageURL) {
    if (weakSelf == nil) {
      return;
    }
    if (image && image.size.width > 0.0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat newImageAspectRatio = image.size.width / image.size.height;
        CGFloat newImageHeightConstraint = weakSelf.captionedImageView.frame.size.width / newImageAspectRatio;
        if ([self shouldResizeImageWithNewConstant:newImageHeightConstraint]) {
          // Update image size based on actual downloaded image
          [weakSelf updateImageConstraintsWithNewConstant:newImageHeightConstraint];
          [weakSelf.delegate refreshTableViewCellHeights];
          captionedImageCard.imageAspectRatio = newImageAspectRatio;
        }
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.captionedImageView.image = [weakSelf getPlaceHolderImage];
      });
    }
  }];
}

- (void)updateImageConstraintsWithNewConstant:(CGFloat)newConstant {
  self.imageHeightConstraint.constant = newConstant;
  [self setNeedsLayout];
}

#pragma mark - Private methods

- (BOOL)shouldResizeImageWithNewConstant:(CGFloat)newConstant {
  return self.imageHeightConstraint &&
      newConstant != INFINITY &&
      fabs(newConstant - self.imageHeightConstraint.constant) > ImageMinResizingDifference;
}

@end
