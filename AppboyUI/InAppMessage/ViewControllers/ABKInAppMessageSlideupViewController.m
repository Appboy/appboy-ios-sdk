#import "ABKInAppMessageSlideupViewController.h"
#import "ABKInAppMessageSlideup.h"
#import "ABKUIUtils.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const SidePaddingForBeveledSlideup = 15.0f;
static CGFloat const RightMargin = 15.0f;
static CGFloat const LeftMargin = 10.0f;
static CGFloat const BeveledShadowOpacity = 0.2f;
static CGFloat const BeveledShadowRadius = 5;
static CGFloat const BeveledViewRadius = 15;
static CGFloat const BevelLandscapeTopSafeAreaHeight = 10.0f;
static CGFloat const BevelLandscapeBottomSafeAreaHeight = 21.0f;

static CGFloat const BeveliPhoneXPortraitTopSafeAreaHeight = 44.0f;
static CGFloat const BeveliPhoneXPortraitBottomSafeAreaHeight = 34.0f;

static CGFloat const BevelPortraitTopSafeAreaHeightForNormalRectScreen = 22.0f;

@implementation ABKInAppMessageSlideupViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.view.translatesAutoresizingMaskIntoConstraints = NO;

  [self setupChevron];
  [self setupImageOrLabelView];
  [self setupConstraintsWithSuperView];
  
  if ([ABKUIUtils isiPhoneX] || [(ABKInAppMessageSlideup *)self.inAppMessage isBeveled]) {
    self.view.layer.cornerRadius = BeveledViewRadius;
    self.view.layer.masksToBounds = NO;
  }
}

- (void)setupChevron {
  if (((ABKInAppMessageSlideup *)self.inAppMessage).hideChevron) {
    [self.arrowImage removeFromSuperview];
    self.arrowImage = nil;
    NSDictionary *inAppMessageLabelDictionary = @{@"inAppMessageMessageLabel":self.inAppMessageMessageLabel};
    NSArray *inAppMessageLabelTrailingConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[inAppMessageMessageLabel]-RightMargin-|"
                                                                                           options:0
                                                                                           metrics:@{@"RightMargin" : @(RightMargin)}
                                                                                             views:inAppMessageLabelDictionary];
    [self.view addConstraints:inAppMessageLabelTrailingConstraint];
  } else {
    if (((ABKInAppMessageSlideup *)self.inAppMessage).chevronColor != nil) {
      UIImage *newImage = [ABKUIUtils maskImage:self.arrowImage.image
                                        toColor:((ABKInAppMessageSlideup *) self.inAppMessage).chevronColor];
      self.arrowImage.image = newImage;
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
      NSDictionary *inAppMessageLabelDictionary = @{@"inAppMessageMessageLabel":self.inAppMessageMessageLabel};
      NSArray *inAppMessageLabelLeadingConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LeftMargin-[inAppMessageMessageLabel]"
                                                                                            options:0
                                                                                            metrics:@{@"LeftMargin" : @(LeftMargin)}
                                                                                              views:inAppMessageLabelDictionary];
      [self.view addConstraints:inAppMessageLabelLeadingConstraint];
    }
  }
}

- (void)setupConstraintsWithSuperView {
  CGFloat sidePadding = 0.0;
  if ([ABKUIUtils isiPhoneX] || [(ABKInAppMessageSlideup *)self.inAppMessage isBeveled]) {
    sidePadding = SidePaddingForBeveledSlideup;
  }
  
  NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view.superview
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1
                                                                     constant:sidePadding];
  NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:self.view.superview
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
  [self.view.superview addConstraints:@[leadConstraint, trailConstraint, slideConstraint]];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  // Redraw the shadow when the layout is changed.
  if ([ABKUIUtils isiPhoneX] || [(ABKInAppMessageSlideup *)self.inAppMessage isBeveled]) {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, 5);
    self.view.layer.shadowPath = shadowPath.CGPath;
    self.view.layer.shadowOpacity = BeveledShadowOpacity;
    self.view.layer.shadowRadius = BeveledShadowRadius;
  }
}

- (void)loadView {
  [[NSBundle bundleForClass:[ABKInAppMessageSlideupViewController class]] loadNibNamed:@"ABKInAppMessageSlideupViewController"
                                                                               owner:self
                                                                             options:nil];
  self.inAppMessageMessageLabel.font = MessageLabelDefaultFont;
}

- (void)beforeMoveInAppMessageViewOnScreen {
  self.slideConstraint.constant = 0;
  UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
  if (((ABKInAppMessageSlideup *)self.inAppMessage).inAppMessageSlideupAnchor == ABKInAppMessageSlideupFromTop) {
    if ([ABKUIUtils isiPhoneX]) {
      self.slideConstraint.constant = statusBarOrientation == UIInterfaceOrientationPortrait ?
                                      BeveliPhoneXPortraitTopSafeAreaHeight : BevelLandscapeTopSafeAreaHeight;
    } else if ([(ABKInAppMessageSlideup *)self.inAppMessage isBeveled]) {
      self.slideConstraint.constant = statusBarOrientation == UIInterfaceOrientationPortrait ?
                                      BevelPortraitTopSafeAreaHeightForNormalRectScreen : BevelLandscapeTopSafeAreaHeight;
    }
  } else {
    if ([ABKUIUtils isiPhoneX]) {
      if (UIInterfaceOrientationIsPortrait(statusBarOrientation)) {
        self.slideConstraint.constant = BeveliPhoneXPortraitBottomSafeAreaHeight;
      } else {
        self.slideConstraint.constant = BevelLandscapeBottomSafeAreaHeight;
      }
    } else if ([(ABKInAppMessageSlideup *)self.inAppMessage isBeveled]) {
      self.slideConstraint.constant = BevelLandscapeBottomSafeAreaHeight;
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

@end
