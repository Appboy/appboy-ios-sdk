#import "ABKClassicImageContentCardCell.h"
#import "Appboy.h"
#import "ABKImageDelegate.h"
#import "ABKUIUtils.h"

@implementation ABKClassicImageContentCardCell

#pragma mark - SetUp

- (void)setUpUI {
  [super setUpUI];
  [self setUpClassicImageView];
  [self setUpTitleLabel];
  [self setUpDescriptionLabel];
  [self setUpLinkLabel];
}

#pragma mark ClassicImageView

- (void)setUpClassicImageView {
  self.classicImageView =  [[[self imageViewClass] alloc] init];
  self.classicImageView.contentMode = UIViewContentModeScaleAspectFit;
  self.classicImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.classicImageView.clipsToBounds = YES;

  [self.rootView addSubview:self.classicImageView];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[captionedImageView]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"classicImageView" : self.classicImageView}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSLayoutConstraint *topConstraint = [self.classicImageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor constant:20];
  NSLayoutConstraint *bottomConstraint = [self.classicImageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor constant:-20];
  bottomConstraint.priority = ABKContentCardPriorityLayoutRequiredBelowAppleRequired;
  [NSLayoutConstraint activateConstraints:@[topConstraint, bottomConstraint]];

  NSLayoutConstraint *heightConstraint = [self.classicImageView.heightAnchor constraintLessThanOrEqualToConstant:57.5];
  NSLayoutConstraint *ratioConstraint = [self.classicImageView.widthAnchor constraintEqualToAnchor:self.classicImageView.heightAnchor multiplier:1];
  [NSLayoutConstraint activateConstraints:@[heightConstraint, ratioConstraint]];
}

- (void)setUpTitleLabel {
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.font = [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleCallout weight:UIFontWeightBold];
  self.titleLabel.text = @"Title";
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.titleLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[classicImageView]-12-[titleLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{
                                                                                 @"titleLabel" : self.titleLabel,
                                                                                 @"classicImageView" : self.classicImageView
                                                                             }];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSLayoutConstraint *topConstraint = [self.titleLabel.topAnchor constraintEqualToAnchor:self.classicImageView.topAnchor constant:-2];
  [self.rootView addConstraint:topConstraint];

  [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow - 1
                                     forAxis:UILayoutConstraintAxisHorizontal];
  [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                     forAxis:UILayoutConstraintAxisVertical];

  [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1
                                                   forAxis:UILayoutConstraintAxisVertical];
}

- (void)setUpDescriptionLabel {
  self.descriptionLabel = [[UILabel alloc] init];
  self.descriptionLabel.font =  [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleFootnote weight:UIFontWeightRegular];
  self.descriptionLabel.text = @"Description";
  self.descriptionLabel.numberOfLines = 0;
  self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.descriptionLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[classicImageView]-12-[descriptionLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{
                                                                                 @"descriptionLabel" : self.descriptionLabel,
                                                                                 @"classicImageView" : self.classicImageView
                                                                             }];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-6-[descriptionLabel]"
                                                                           options:0
                                                                           metrics:nil
                                                                           views:@{
                                                                               @"titleLabel" : self.titleLabel,
                                                                               @"descriptionLabel" : self.descriptionLabel
                                                                           }];
  [NSLayoutConstraint activateConstraints:verticalConstraints];

  [self.descriptionLabel setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                           forAxis:UILayoutConstraintAxisVertical];
  [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1
                                                         forAxis:UILayoutConstraintAxisVertical];

  self.descriptionBottomConstraint = [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor constant:-25];
  self.descriptionBottomConstraint.priority = UILayoutPriorityDefaultLow;
  self.descriptionBottomConstraint.active = YES;
}

- (void)setUpLinkLabel {
  self.linkLabel = [[UILabel alloc] init];
  self.linkLabel.font =  [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleFootnote weight:UIFontWeightMedium];
  self.linkLabel.text = @"Link";
  self.linkLabel.numberOfLines = 0;
  self.linkLabel.lineBreakMode = NSLineBreakByCharWrapping;
  self.linkLabel.translatesAutoresizingMaskIntoConstraints = NO;

  if (@available(iOS 13.0, *)) {
    self.linkLabel.textColor = [UIColor linkColor];
  } else {
    self.linkLabel.textColor = [UIColor blueColor];
  }

  [self.rootView addSubview:self.linkLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[classicImageView]-12-[linkLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{
                                                                               @"linkLabel" : self.linkLabel,
                                                                               @"classicImageView" : self.classicImageView
                                                                             }];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSLayoutConstraint *topConstraint = [self.linkLabel.topAnchor constraintGreaterThanOrEqualToAnchor:self.descriptionLabel.bottomAnchor constant:8];
  topConstraint.priority = UILayoutPriorityRequired;
  self.linkBottomConstraint = [self.linkLabel.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor constant:-25];
  self.linkBottomConstraint.priority = UILayoutPriorityDefaultHigh;
  [NSLayoutConstraint activateConstraints:@[topConstraint, self.linkBottomConstraint]];

  [self.linkLabel setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                    forAxis:UILayoutConstraintAxisVertical];
  [self.linkLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1
                                                  forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - ApplyCard

- (void)applyCard:(ABKClassicContentCard *)card {
  if (![card isKindOfClass:[ABKClassicContentCard class]]) {
    return;
  }
  [super applyCard:card];
  if (![Appboy sharedInstance].imageDelegate) {
    NSLog(@"[APPBOY][WARN] %@ %s",
          @"ImageDelegate on Appboy is nil. Image loading may be disabled.",
          __PRETTY_FUNCTION__);
    return;
  }
  [[Appboy sharedInstance].imageDelegate setImageForView:self.classicImageView
                                   showActivityIndicator:NO
                                                 withURL:[NSURL URLWithString:card.image]
                                        imagePlaceHolder:[self getPlaceHolderImage]
                                               completed:nil];
}

@end
