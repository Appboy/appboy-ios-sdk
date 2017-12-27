#import "ABKInAppMessageModalViewController.h"
#import "ABKUIUtils.h"
#import "ABKInAppMessageViewController.h"
#import "ABKInAppMessageImmersive.h"
#import "ABKSDWebImageProxy.h"

static const CGFloat ModalViewCornerRadius = 10.0f;
static const CGFloat MaxModalViewGraphicSize = 290.0f;

@implementation ABKInAppMessageModalViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (((ABKInAppMessageImmersive *)self.inAppMessage).imageStyle == ABKInAppMessageTopImage) {
    [self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[view]-(>=0)-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"view" : self.view}]];
  } else {
    @try {
      // SDWebImage downloads the imageView's image asynchronously, so the image is not guaranteed
      // to be downloaded at this point, so we don't create the constraint based on the imageView's image size.
      // Instead, we fetch the image from the SDWebImage cache directly.
      Class SDWebImageProxyClass = [ABKUIUtils getSDWebImageProxyClass];
      NSString *imageKey = [SDWebImageProxyClass cacheKeyForURL:self.inAppMessage.imageURI];
      UIImage *inAppImage = [SDWebImageProxyClass imageFromCacheForKey:imageKey];
      CGFloat imageAspectRatio = 1.0;
      if (inAppImage != nil) {
        imageAspectRatio = inAppImage.size.width / inAppImage.size.height;
      }
      NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.graphicImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.graphicImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:imageAspectRatio
                                                                     constant:0];
      [self.graphicImageView addConstraint:constraint];
      NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(<=max)]"
                                                                          options:0
                                                                          metrics:@{@"max" : @(MaxModalViewGraphicSize)}
                                                                            views:@{@"view" : self.graphicImageView}];
      NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(<=max)]"
                                                                           options:0
                                                                           metrics:@{@"max" : @(MaxModalViewGraphicSize)}
                                                                             views:@{@"view" : self.graphicImageView}];
      [self.graphicImageView addConstraints:widthConstraints];
      [self.graphicImageView addConstraints:heightConstraints];
    } @catch (NSException *exception) {
      NSLog(@"Braze cannot display this message because it has a height or width of 0. The graphic image has width %f and height %f and image URI %@.",
            self.graphicImageView.image.size.width, self.graphicImageView.image.size.height,
            self.inAppMessage.imageURI.absoluteString);
      [self hideInAppMessage:NO];
    }
  }
}

- (void)setupLayoutForGraphic {
  [super applyImageToImageView:self.graphicImageView];
  [self.iconImageView removeFromSuperview];
  [self.iconLabelView removeFromSuperview];
  [self.textsView removeFromSuperview];
  self.iconImageView = nil;
  self.iconLabelView = nil;
  self.inAppMessageHeaderLabel = nil;
  self.inAppMessageMessageLabel = nil;
  self.textsView = nil;
}

- (void)setupLayoutForTopImage {
  self.textsView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==max)]"
                                                                    options:0
                                                                    metrics:@{@"max" : @(MaxModalViewGraphicSize)}
                                                                      views:@{@"view" : self.view}]];
  [self.graphicImageView removeFromSuperview];
  self.graphicImageView = nil;
  
  // Set up the icon image/label view
  if ([super applyImageToImageView:self.iconImageView]) {
    [self.iconLabelView removeFromSuperview];
    self.iconLabelView = nil;
  } else {
    self.iconImageView.hidden = YES;
    self.iconImageHeightConstraint.constant = self.iconLabelView.frame.size.height + 20.0f;
    
    if (![super applyIconToLabelView:self.iconLabelView]) {
      // When there is no image or icon, remove the iconLabelView to free up the space of the image view
      [self.iconLabelView removeFromSuperview];
      self.iconLabelView = nil;
      self.iconImageHeightConstraint.constant = 20.0f;
    }
  }
  
  if (![ABKUIUtils objectIsValidAndNotEmpty:((ABKInAppMessageImmersive *)self.inAppMessage).header]) {
    for (NSLayoutConstraint *constraint in self.inAppMessageHeaderLabel.constraints) {
      if (constraint.firstAttribute == NSLayoutAttributeHeight) {
        constraint.constant = 0.0f;
        break;
      }
    }
    self.headerBodySpaceConstraint.constant = 0.0f;
  }
}

- (UIView *)bottomViewWithNoButton {
  return self.textsView;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.textsView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews {
  if ([self isMemberOfClass:[ABKInAppMessageModalViewController class]]) {
    if (self.textsView && !self.textsViewWidthConstraint) {
      [self.view layoutIfNeeded];
      NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.textsView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:self.textsView.contentSize.width];
      self.textsViewWidthConstraint = widthConstraint;
      NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.textsView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:self.textsView.contentSize.height];
      widthConstraint.priority = 999;
      heightConstraint.priority = 999;
      [self.textsView addConstraint:widthConstraint];
      [self.textsView addConstraint:heightConstraint];
    }
    [self.view layoutIfNeeded];
  }
}

- (void)loadView {
  [[NSBundle bundleForClass:[ABKInAppMessageModalViewController class]] loadNibNamed:@"ABKInAppMessageModalViewController"
                                                                               owner:self
                                                                             options:nil];
  self.view.layer.cornerRadius = ModalViewCornerRadius;
  self.inAppMessageHeaderLabel.font = HeaderLabelDefaultFont;
  self.inAppMessageMessageLabel.font = MessageLabelDefaultFont;
}

@end
