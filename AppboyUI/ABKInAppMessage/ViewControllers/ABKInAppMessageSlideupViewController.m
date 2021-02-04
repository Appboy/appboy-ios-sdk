#import "ABKInAppMessageSlideupViewController.h"
#import "ABKInAppMessageSlideup.h"
#import "ABKUIUtils.h"

static CGFloat const AssetSideMargin = 20.0f;
static CGFloat const DefaultViewRadius = 15.0f;
static CGFloat const DefaultVerticalMarginHeight = 10.0f;
static CGFloat const NotchedPhoneLandscapeBottomMarginHeight = 21.0f;
static CGFloat const NotchedPhonePortraitBottomMarginHeight = 34.0f;

@interface ABKInAppMessageSlideupViewController()

@property (strong, nonatomic) NSLayoutConstraint *leadConstraint;
@property (strong, nonatomic) NSLayoutConstraint *trailConstraint;

@end

@implementation ABKInAppMessageSlideupViewController

- (void)loadView {
  NSBundle *bundle = [ABKUIUtils bundle:[ABKInAppMessageSlideupViewController class] channel:ABKInAppMessageChannel];
  [bundle loadNibNamed:@"ABKInAppMessageSlideupViewController"
                 owner:self
               options:nil];
  self.inAppMessageMessageLabel.font = MessageLabelDefaultFont;
  if (self.inAppMessage.message) {
    NSMutableAttributedString *attributedStringMessage = [[NSMutableAttributedString alloc] initWithString:self.inAppMessage.message];
    NSMutableParagraphStyle *messageStyle = [[NSMutableParagraphStyle alloc] init];
    [messageStyle setLineSpacing:2];
    [messageStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedStringMessage addAttribute:NSParagraphStyleAttributeName
                                    value:messageStyle
                                    range:NSMakeRange(0, self.inAppMessage.message.length)];
    self.inAppMessageMessageLabel.attributedText = attributedStringMessage;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.view.translatesAutoresizingMaskIntoConstraints = NO;

  [self setupChevron];
  [self setupImageOrLabelView];
  [self setupConstraintsWithSuperView];

  self.view.layer.cornerRadius = DefaultViewRadius;
  self.view.layer.masksToBounds = NO;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // Redraw the shadow when the layout is changed.
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:DefaultViewRadius];
  self.view.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:InAppMessageShadowOpacity].CGColor;
  self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  self.view.layer.shadowRadius = InAppMessageShadowBlurRadius;
  self.view.layer.shadowPath = shadowPath.CGPath;

  // Make opacity of shadow match opacity of the In-App Message background
  CGFloat alpha = 0;
  [self.view.backgroundColor getRed:nil green:nil blue:nil alpha:&alpha];
  self.view.layer.shadowOpacity = alpha;
}

#pragma mark - Private methods

- (void)setupChevron {
  if (((ABKInAppMessageSlideup *)self.inAppMessage).hideChevron) {
    [self.arrowImage removeFromSuperview];
    self.arrowImage = nil;
    NSLayoutConstraint *inAppMessageLabelTrailingConstraint =
        [self.inAppMessageMessageLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor
                                                                     constant:-AssetSideMargin];
    [self.view addConstraint:inAppMessageLabelTrailingConstraint];

  } else {
    if (((ABKInAppMessageSlideup *)self.inAppMessage).chevronColor != nil) {
      UIColor *arrowColor = ((ABKInAppMessageSlideup *)self.inAppMessage).chevronColor;
      self.arrowImage.image = [self.arrowImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      self.arrowImage.tintColor = arrowColor;
    } else {
      UIColor *defaultArrowColor = [UIColor colorWithRed:(155.0/255.0) green:(155.0/255.0) blue:(155.0/255.0) alpha:1.0];
      self.arrowImage.image = [self.arrowImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      self.arrowImage.tintColor = defaultArrowColor;
    }
  }
}

- (void)setupImageOrLabelView {
  if (![super applyImageToImageView:self.iconImageView]) {
    [self.iconImageView removeFromSuperview];
    self.iconImageView = nil;

    if (![super applyIconToLabelView:self.iconLabelView]) {
      [self.iconLabelView removeFromSuperview];
      self.iconLabelView = nil;
      NSLayoutConstraint *inAppMessageLabelLeadingConstraint =
          [self.inAppMessageMessageLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                                                       constant:AssetSideMargin];
      [self.view addConstraint:inAppMessageLabelLeadingConstraint];
    }
  }
}

- (void)setupConstraintsWithSuperView {
  self.leadConstraint = [self.view.leadingAnchor constraintEqualToAnchor:self.view.superview.layoutMarginsGuide.leadingAnchor];
  self.trailConstraint = [self.view.trailingAnchor constraintEqualToAnchor:self.view.superview.layoutMarginsGuide.trailingAnchor];

  NSLayoutConstraint *slideConstraint = nil;
  if ([self animatesFromTop]) {
    CGFloat offscreenDistance = self.view.frame.size.height + [ABKUIUtils getStatusBarSize].height;
    slideConstraint = [self.view.topAnchor constraintEqualToAnchor:self.view.superview.layoutMarginsGuide.topAnchor
                                                          constant:-offscreenDistance];
  } else {
    slideConstraint =  [NSLayoutConstraint constraintWithItem:self.view.superview
                                                    attribute:NSLayoutAttributeBottom
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.view
                                                    attribute:NSLayoutAttributeBottom
                                                   multiplier:1
                                                     constant:- self.view.frame.size.height];
  }
  self.slideConstraint = slideConstraint;
  [self.view.superview addConstraints:@[self.leadConstraint, self.trailConstraint, slideConstraint]];
}

- (CGFloat)slideupAnimationDistance {
  if ([ABKUIUtils isNotchedPhone] && ![self animatesFromTop]) {
    return UIInterfaceOrientationIsPortrait([ABKUIUtils getInterfaceOrientation])
            ? NotchedPhonePortraitBottomMarginHeight
            : NotchedPhoneLandscapeBottomMarginHeight;
  }
  return DefaultVerticalMarginHeight;
}

- (BOOL)animatesFromTop {
  return ((ABKInAppMessageSlideup *)self.inAppMessage).inAppMessageSlideupAnchor == ABKInAppMessageSlideupFromTop;
}

#pragma mark - Superclass methods

- (void)beforeMoveInAppMessageViewOnScreen {
  self.slideConstraint.constant = [self slideupAnimationDistance];
}

- (void)moveInAppMessageViewOnScreen {
  [self.view.superview layoutIfNeeded];
}

- (void)beforeMoveInAppMessageViewOffScreen {
  CGFloat offscreenDistance = [self animatesFromTop] ? self.view.frame.size.height + [ABKUIUtils getStatusBarSize].height
                                                     : self.view.frame.size.height;
  self.slideConstraint.constant = -offscreenDistance;
}

- (void)moveInAppMessageViewOffScreen {
  [self.view.superview layoutIfNeeded];
}

- (void)setInAppMessage:(ABKInAppMessage *)inAppMessage {
  if ([inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    super.inAppMessage = inAppMessage;
  } else {
    NSLog(@"ABKInAppMessageSlideupViewController only accepts in-app message with type ABKInAppMessageSlideup. Setting in-app message fails.");
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.inAppMessage.inAppMessageClickActionType != ABKInAppMessageNoneClickAction) {
    self.view.alpha = InAppMessageSelectedOpacity;
  }
}

@end
