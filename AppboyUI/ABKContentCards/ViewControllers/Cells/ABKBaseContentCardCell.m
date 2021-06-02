#import "ABKBaseContentCardCell.h"

#import "ABKUIUtils.h"
#import "Appboy.h"
#import "ABKImageDelegate.h"

static CGFloat AppboyCardSidePadding = 10.0;
static CGFloat AppboyCardSpacing = 32.0;
static CGFloat AppboyCardBorderWidth = 0.5;
static CGFloat AppboyCardCornerRadius = 3.0;
static CGFloat AppboyCardShadowXOffset = 0.0;
static CGFloat AppboyCardShadowYOffset = -2.0;
static CGFloat AppboyCardShadowOpacity = 0.5;
static CGFloat AppboyCardLineSpacing = 1.2;

@implementation ABKBaseContentCardCell

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setUp];
    [self setUpUI];
  }

  return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setUp];
  }
  return self;
}

#pragma mark - SetUp

- (void)setUp {
  self.backgroundColor = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor clearColor];
  self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  self.unviewedLineViewColor = self.tintColor;

  self.cardSidePadding = AppboyCardSidePadding;
  self.cardSpacing = AppboyCardSpacing;
}

- (void)setUpUI {
  [self setUpRootView];
  [self setUpPinImageView];
  [self setUpUnviewedLineView];
}

#pragma mark Root view

- (void)setUpRootView {
  self.rootView = [[UIView alloc] init];
  self.rootView.translatesAutoresizingMaskIntoConstraints = NO;
  if (@available(iOS 13.0, *)) {
    self.rootView.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    self.rootView.backgroundColor = [UIColor whiteColor];
  }

  [self setUpRootViewBorder];

  self.pinImageView.image = [self.pinImageView.image imageFlippedForRightToLeftLayoutDirection];
  [self.contentView addSubview:self.rootView];

  self.cardWidthConstraint = [self.rootView.widthAnchor constraintLessThanOrEqualToConstant:380];
  [self.rootView.heightAnchor constraintGreaterThanOrEqualToConstant:80].active = YES;

  self.rootViewLeadingConstraint = [self.rootView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:self.cardSidePadding];
  self.rootViewLeadingConstraint.priority = ABKContentCardPriorityLayoutRequiredBelowAppleRequired;
  self.rootViewTrailingConstraint = [self.rootView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-self.cardSidePadding];
  self.rootViewTrailingConstraint.priority = ABKContentCardPriorityLayoutRequiredBelowAppleRequired;

  self.rootViewTopConstraint = [self.rootView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:self.cardSidePadding];
  self.rootViewBottomConstraint = [self.rootView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-self.cardSidePadding];
  self.rootViewBottomConstraint.priority = UILayoutPriorityRequired-1;

  [self.rootView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;

  [NSLayoutConstraint activateConstraints:@[self.cardWidthConstraint,
                                            self.rootViewLeadingConstraint,
                                            self.rootViewTrailingConstraint,
                                            self.rootViewTopConstraint,
                                            self.rootViewBottomConstraint]];
}

- (void)setUpRootViewBorder {
  CALayer *rootLayer = self.rootView.layer;
  rootLayer.masksToBounds = YES;
  rootLayer.cornerRadius = AppboyCardCornerRadius;
  UIColor *lightBorderColor = [UIColor colorWithRed:(224.0 / 255.0) green:(224.0 / 255.0) blue:(224.0 / 255.0) alpha:1.0];
  UIColor *darkBorderColor = [UIColor colorWithRed:(85.0 / 255.0) green:(85.0 / 255.0) blue:(85.0 / 255.0) alpha:1.0];
  rootLayer.borderColor = [ABKUIUtils dynamicColorForLightColor:lightBorderColor darkColor:darkBorderColor].CGColor;
  rootLayer.borderWidth = AppboyCardBorderWidth;
  rootLayer.shadowColor = [UIColor colorWithRed:(178.0 / 255.0) green:(178.0 / 255.0) blue:(178.0 / 255.0) alpha:1.0].CGColor;
  rootLayer.shadowOffset =  CGSizeMake(AppboyCardShadowXOffset, AppboyCardShadowYOffset);
  rootLayer.shadowOpacity = AppboyCardShadowOpacity;
}

- (void)setUpPinImageView {
  self.pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appboy_cc_icon_pinned.png"]];
  self.pinImageView.contentMode = UIViewContentModeScaleToFill;
  self.pinImageView.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.pinImageView];

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

- (void)setUpUnviewedLineView {
  self.unviewedLineView = [[UIView alloc] init];
  self.unviewedLineView.backgroundColor = self.unviewedLineViewColor;
  self.unviewedLineView.translatesAutoresizingMaskIntoConstraints = NO;

  [self.rootView addSubview:self.unviewedLineView];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[unviewedLineView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"unviewedLineView" : self.unviewedLineView}];
  [NSLayoutConstraint activateConstraints:horizontalConstraints];

  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[unviewedLineView(8)]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"unviewedLineView" : self.unviewedLineView}];
  [NSLayoutConstraint activateConstraints:verticalConstraints];
}

# pragma mark - Cell UI Configuration

- (void)setUnviewedLineViewColor:(UIColor*)bgColor {
  _unviewedLineViewColor = bgColor;
  if (self.unviewedLineView) {
    self.unviewedLineView.backgroundColor = self.unviewedLineViewColor;
  }
}

- (void)setHideUnreadIndicator:(BOOL)hideUnreadIndicator {
  if (_hideUnreadIndicator != hideUnreadIndicator) {
    _hideUnreadIndicator = hideUnreadIndicator;
    self.unviewedLineView.hidden = hideUnreadIndicator;
  }
}

- (void)setCardSidePadding:(CGFloat)sidePadding {
  _cardSidePadding = sidePadding;
  if (self.rootViewLeadingConstraint && self.rootViewTrailingConstraint) {
    self.rootViewLeadingConstraint.constant = self.cardSidePadding;
    self.rootViewTrailingConstraint.constant = self.cardSidePadding;
  }
}

- (void)setCardSpacing:(CGFloat)spacing {
  _cardSpacing = spacing;
  if (self.rootViewTopConstraint && self.rootViewBottomConstraint) {
    self.rootViewTopConstraint.constant = self.cardSpacing / 2.0;
    self.rootViewBottomConstraint.constant = self.cardSpacing / 2.0;
  }
}

#pragma mark - ApplyCard

- (void)applyCard:(ABKContentCard *)card {
  if ([card isControlCard]) {
    self.pinImageView.hidden = YES;
    self.unviewedLineView.hidden = YES;
  } else {
    if (self.hideUnreadIndicator) {
      self.unviewedLineView.hidden = YES;
    } else {
      self.unviewedLineView.hidden = card.viewed;
    }
    self.pinImageView.hidden = !card.pinned;
  }
}

#pragma mark - Utiliy Methods

- (UIImage *)getPlaceHolderImage {
  return [ABKUIUtils getImageWithName:@"appboy_cc_noimage_lrg"
                                 type:@"png"
                       inAppboyBundle:[ABKUIUtils
                                       bundle:[ABKBaseContentCardCell class]
                                       channel:ABKContentCardChannel]];
}

- (Class)imageViewClass {
  if ([Appboy sharedInstance].imageDelegate) {
    return [[Appboy sharedInstance].imageDelegate imageViewClass];
  }
  return [UIImageView class];
}

- (void)applyAppboyAttributedTextStyleFrom:(NSString *)text forLabel:(UILabel *)label {
  UIColor *color = label.textColor;
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = AppboyCardLineSpacing;
  UIFont *font = label.font;
  NSDictionary *attributes = @{NSFontAttributeName: font,
                               NSForegroundColorAttributeName: color,
                               NSParagraphStyleAttributeName: paragraphStyle};
  // Convert to empty string to fail gracefully if given null from backend
  text = text ?: @"";
  label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setUpRootViewBorder];
}

@end
