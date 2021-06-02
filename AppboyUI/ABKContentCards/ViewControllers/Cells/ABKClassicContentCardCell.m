#import "ABKClassicContentCardCell.h"
#import "ABKUIUtils.h"

@implementation ABKClassicContentCardCell

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
- (void)setUp {
  [super setUp];
  self.programmaticLayout = NO;
}

- (void)setUpUI {
  [super setUpUI];
  self.programmaticLayout = YES;
  [self setUpTitleLabel];
  [self setUpDescriptionLabel];
  [self setUpLinkLabel];
  [self.rootView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView setNeedsUpdateConstraints];
}

- (void)setUpTitleLabel {
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.font = [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleCallout weight:UIFontWeightBold];
  self.titleLabel.textColor = [self class].titleLabelColor;
  self.titleLabel.text = @"Title";
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.titleLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[titleLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"titleLabel" : self.titleLabel}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  [self.titleLabel.topAnchor constraintEqualToAnchor:self.rootView.topAnchor constant:17].active = YES;

  [self.titleLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                     forAxis:UILayoutConstraintAxisHorizontal];
  [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisVertical];

  [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                   forAxis:UILayoutConstraintAxisVertical];
  self.rootViewBottomConstraint.priority = UILayoutPriorityDefaultLow;
}

- (void)setUpDescriptionLabel {
  self.descriptionLabel = [[UILabel alloc] init];
  self.descriptionLabel.font = [ABKUIUtils preferredFontForTextStyle:UIFontTextStyleFootnote weight:UIFontWeightRegular];
  self.descriptionLabel.textColor = [self class].descriptionLabelColor;
  self.descriptionLabel.text = @"Description";
  self.descriptionLabel.numberOfLines = 0;
  self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.descriptionLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[descriptionLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"descriptionLabel" : self.descriptionLabel}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6].active = YES;
  
  [self.descriptionLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
  [self.descriptionLabel setContentHuggingPriority:UILayoutPriorityRequired
                                           forAxis:UILayoutConstraintAxisVertical];
  [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                         forAxis:UILayoutConstraintAxisVertical];

  self.descriptionBottomConstraint = [self.descriptionLabel.bottomAnchor
                                      constraintGreaterThanOrEqualToAnchor:self.rootView.bottomAnchor constant:-25];
  self.descriptionBottomConstraint.priority = UILayoutPriorityRequired-1;
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

  [self.rootView addSubview:self.linkLabel];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[linkLabel]-25-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"linkLabel" : self.linkLabel}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];
  NSLayoutConstraint *linkToDescription = [self.linkLabel.topAnchor constraintEqualToAnchor:self.descriptionLabel.bottomAnchor constant:8];
  linkToDescription.active = YES;
  self.linkBottomConstraint = [self.linkLabel.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor constant:-25];
  self.linkBottomConstraint.priority = UILayoutPriorityDefaultHigh-1;
  self.linkBottomConstraint.active = YES;

  [self.linkLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisVertical];
  [self.linkLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                   forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - ApplyCard

- (void)applyCard:(ABKClassicContentCard *)card {
  if (![card isKindOfClass:[ABKClassicContentCard class]]) {
    return;
  }
  
  [super applyCard:card];
  
  [self applyAppboyAttributedTextStyleFrom:card.title forLabel:self.titleLabel];
  [self applyAppboyAttributedTextStyleFrom:card.cardDescription forLabel:self.descriptionLabel];
  [self applyAppboyAttributedTextStyleFrom:card.domain forLabel:self.linkLabel];
  
  BOOL shouldHideLink = (card.domain.length == 0);
  [self hideLinkLabel:shouldHideLink];
  
  if (self.programmaticLayout) {
    [self updateEstimatedHeight];
  }
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

- (void)updateEstimatedHeight {
  CGFloat calculatedHeight = 0.0;
  if (self.linkLabel.frame.size.height > 0.0) {
    calculatedHeight = self.linkLabel.frame.origin.y + self.linkLabel.frame.size.height;
  } else {
    calculatedHeight = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height;
  }
  if (calculatedHeight > 1.0) {
    if (self.estimatedHeightConstraint) {
      self.estimatedHeightConstraint.active = NO;
    }
    self.estimatedHeightConstraint = [self.rootView.heightAnchor constraintGreaterThanOrEqualToConstant:calculatedHeight];
    self.estimatedHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    self.estimatedHeightConstraint.active = YES;
  }
}

@end
