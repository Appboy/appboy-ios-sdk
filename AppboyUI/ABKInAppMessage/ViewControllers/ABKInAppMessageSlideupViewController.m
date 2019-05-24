#import "ABKInAppMessageSlideupViewController.h"
#import "ABKInAppMessageSlideup.h"
#import "ABKUIUtils.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const SlideupAssetRightMargin = 20.0f;
static CGFloat const SlideupAssetLeftMargin = 20.0f;

static CGFloat const BevelViewRadius = 15.0f;
static CGFloat const BevelDefaultVerticalMarginHeight = 10.0f;
static CGFloat const BevelDefaultSideMarginWidth = 15.0f;
static CGFloat const BevelNotchedPhoneLandscapeBottomMarginHeight = 21.0f;
static CGFloat const BevelNotchedPhoneLandscapeSideMarginWidth = 44.0f;
static CGFloat const BevelNotchedPhonePortraitTopMarginHeight = 44.0f;
static CGFloat const BevelNotchedPhonePortraitBottomMarginHeight = 34.0f;

static NSString *const InAppMessageSlideupLabelKey = @"inAppMessageMessageLabel";

@interface ABKInAppMessageSlideupViewController()

@property (strong, nonatomic) NSLayoutConstraint *leadConstraint;
@property (strong, nonatomic) NSLayoutConstraint *trailConstraint;

@end

@implementation ABKInAppMessageSlideupViewController

- (void)loadView {
  [[NSBundle bundleForClass:[ABKInAppMessageSlideupViewController class]] loadNibNamed:@"ABKInAppMessageSlideupViewController"
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

  self.view.layer.cornerRadius = BevelViewRadius;
  self.view.layer.masksToBounds = NO;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // Redraw the shadow when the layout is changed.
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:BevelViewRadius];
  self.view.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:InAppMessageShadowOpacity].CGColor;
  self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  self.view.layer.shadowRadius = InAppMessageShadowBlurRadius;
  self.view.layer.shadowPath = shadowPath.CGPath;

  // Make opacity of shadow match opacity of the In-App Message background
  CGFloat alpha = 0;
  [self.view.backgroundColor getRed:nil green:nil blue:nil alpha:&alpha];
  self.view.layer.shadowOpacity = alpha;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

  CGFloat sidePadding = [self sideMarginsForPhoneAndOrientation];
  self.leadConstraint.constant = sidePadding;
  self.trailConstraint.constant = sidePadding;
}

#pragma mark - Private methods

- (void)setupChevron {
  if (((ABKInAppMessageSlideup *)self.inAppMessage).hideChevron) {
    [self.arrowImage removeFromSuperview];
    self.arrowImage = nil;
    NSDictionary *inAppMessageLabelDictionary = @{ InAppMessageSlideupLabelKey : self.inAppMessageMessageLabel };
    NSArray *inAppMessageLabelTrailingConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[inAppMessageMessageLabel]-RightMargin-|"
                                                                                           options:0
                                                                                           metrics:@{@"RightMargin" : @(SlideupAssetRightMargin)}
                                                                                             views:inAppMessageLabelDictionary];
    [self.view addConstraints:inAppMessageLabelTrailingConstraint];
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
      NSDictionary *inAppMessageLabelDictionary = @{ InAppMessageSlideupLabelKey : self.inAppMessageMessageLabel };
      NSArray *inAppMessageLabelLeadingConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LeftMargin-[inAppMessageMessageLabel]"
                                                                                            options:0
                                                                                            metrics:@{@"LeftMargin" : @(SlideupAssetLeftMargin)}
                                                                                              views:inAppMessageLabelDictionary];
      [self.view addConstraints:inAppMessageLabelLeadingConstraint];
    }
  }
}

- (void)setupConstraintsWithSuperView {
  CGFloat sidePadding = [self sideMarginsForPhoneAndOrientation];
  self.leadConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view.superview
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:sidePadding];
  self.trailConstraint = [NSLayoutConstraint constraintWithItem:self.view.superview
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view
                                                      attribute:NSLayoutAttributeTrailing
                                                     multiplier:1
                                                       constant:sidePadding];

  NSLayoutConstraint *slideConstraint = nil;
  if (((ABKInAppMessageSlideup *)self.inAppMessage).inAppMessageSlideupAnchor == ABKInAppMessageSlideupFromTop) {
    slideConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.view.superview
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1
                                                    constant:- self.view.frame.size.height];
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

- (CGFloat)sideMarginsForPhoneAndOrientation {
  if ([ABKUIUtils isNotchedPhone] && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    return BevelNotchedPhoneLandscapeSideMarginWidth;
  }
  return BevelDefaultSideMarginWidth;
}

#pragma mark - Superclass methods

- (void)beforeMoveInAppMessageViewOnScreen {
  self.slideConstraint.constant = BevelDefaultVerticalMarginHeight;

  if ([ABKUIUtils isNotchedPhone]) {
    BOOL animatesFromTop = ((ABKInAppMessageSlideup *)self.inAppMessage).inAppMessageSlideupAnchor == ABKInAppMessageSlideupFromTop;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
      if (animatesFromTop) {
        self.slideConstraint.constant = BevelNotchedPhonePortraitTopMarginHeight;
      } else {
        self.slideConstraint.constant = BevelNotchedPhonePortraitBottomMarginHeight;
      }
    } else if (!animatesFromTop) {
      // Is landscape and animates from bottom
      self.slideConstraint.constant = BevelNotchedPhoneLandscapeBottomMarginHeight;
    }
  }
}

- (void)moveInAppMessageViewOnScreen {
  [self.view.superview layoutIfNeeded];
}

- (void)beforeMoveInAppMessageViewOffScreen {
  self.slideConstraint.constant = - self.view.frame.size.height;
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
    self.view.alpha = .8;
  }
}

@end
