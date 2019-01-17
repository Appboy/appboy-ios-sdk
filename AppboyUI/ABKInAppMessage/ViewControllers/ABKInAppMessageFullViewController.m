#import "ABKInAppMessageFullViewController.h"
#import "ABKInAppMessageViewController.h"
#import "ABKInAppMessageImmersive.h"
#import "ABKUIUtils.h"

static const CGFloat FullViewInIPadCornerRadius = 10.0f;
static const CGFloat MaxLongEdge = 768.0f;
static const CGFloat MaxShortEdge = 480.0f;
static const CGFloat TextPaddingForNormalRectScreen = 20.0f;
static const CGFloat TextPaddingForLandscapeiPhoneX = 45.0f;

@implementation ABKInAppMessageFullViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  CGFloat maxWidth = MaxShortEdge;
  CGFloat maxHeight = MaxLongEdge;
  if (self.inAppMessage.orientation == ABKInAppMessageOrientationLandscape) {
    maxWidth = MaxLongEdge;
    maxHeight = MaxShortEdge;
  }
  if (self.isiPad) {
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(<=max)]"
                                                                        options:0
                                                                        metrics:@{@"max" : @(maxWidth)}
                                                                          views:@{@"view" : self.view}];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(<=max)]"
                                                                         options:0
                                                                         metrics:@{@"max" : @(maxHeight)}
                                                                           views:@{@"view" : self.view}];
    [self.view addConstraints:widthConstraints];
    [self.view addConstraints:heightConstraints];
    self.view.layer.cornerRadius = FullViewInIPadCornerRadius;
    self.view.layer.masksToBounds = YES;
    
    [self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[view]-(>=0)-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"view" : self.view}]];
  } else {
    NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view.superview
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1
                                                                       constant:0.0];
    NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:self.view.superview
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1
                                                                        constant:0.0];
    [self.view.superview addConstraints:@[leadConstraint, trailConstraint]];
  }
  
  NSString *heightVisualFormat = self.isiPad? @"V:|-(>=0)-[view]-(>=0)-|" : @"V:|-[view]-|";
  NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:heightVisualFormat
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"view" : self.view}];
  [self.view.superview addConstraints:heightConstraints];
}

- (void)setupLayoutForGraphic {
  [super applyImageToImageView:self.graphicImageView];
  [self.iconImageView removeFromSuperview];
  [self.textsView removeFromSuperview];
  self.iconImageView = nil;
  self.textsView = nil;
}

- (void)setupLayoutForTopImage {
  [self.graphicImageView removeFromSuperview];
  self.graphicImageView = nil;
  self.inAppMessageMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.textsView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // When there is no header, we set following two things to 0:
  // (1) the header label's height
  // (2) the constraint's height between header label and the message label
  // so that the space is collapsed.
  if (![ABKUIUtils objectIsValidAndNotEmpty:((ABKInAppMessageImmersive *)self.inAppMessage).header]) {
    for (NSLayoutConstraint *constraint in self.inAppMessageHeaderLabel.constraints) {
      if (constraint.firstAttribute == NSLayoutAttributeHeight) {
        constraint.constant = 0.0f;
        break;
      }
    }
    self.headerBodySpaceConstraint.constant = 0.0f;
  }
  [super applyImageToImageView:self.iconImageView];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if ([ABKUIUtils isiPhoneX] && self.textsView != nil) {
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat textPadding = UIInterfaceOrientationIsPortrait(statusBarOrientation) ?
                          TextPaddingForNormalRectScreen : TextPaddingForLandscapeiPhoneX;
    self.textsViewLeadingConstraint.constant = textPadding;
    self.textsViewTrailingConstraint.constant = textPadding;
    self.headerLeadingConstraint.constant = textPadding;
    self.headerTrailingConstraint.constant = textPadding;
    self.messageLeadingConstraint.constant = textPadding;
    self.messageTrailingConstraint.constant = textPadding;
  }
}

- (UIView *)bottomViewWithNoButton {
  return self.textsView;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.textsView flashScrollIndicators];
}

- (void)loadView {
  [[NSBundle bundleForClass:[ABKInAppMessageFullViewController class]] loadNibNamed:@"ABKInAppMessageFullViewController"
                                                                               owner:self
                                                                             options:nil];
  self.inAppMessageHeaderLabel.font = HeaderLabelDefaultFont;
  self.inAppMessageMessageLabel.font = MessageLabelDefaultFont;
}

@end
