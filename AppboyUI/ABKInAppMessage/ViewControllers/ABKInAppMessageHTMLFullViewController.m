#import "ABKInAppMessageHTMLFullViewController.h"

@implementation ABKInAppMessageHTMLFullViewController

- (void)loadView {
  [[NSBundle bundleForClass:[ABKInAppMessageHTMLFullViewController class]] loadNibNamed:@"ABKInAppMessageHTMLFullViewController"
                                                                               owner:self
                                                                             options:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.view.translatesAutoresizingMaskIntoConstraints = NO;
  
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
  self.topConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                    attribute:NSLayoutAttributeTop
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.view.superview
                                                    attribute:NSLayoutAttributeTop
                                                   multiplier:1
                                                     constant:self.view.frame.size.height];
  self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view.superview
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1
                                                        constant:self.view.frame.size.height];
  [self.view.superview addConstraints:@[leadConstraint, trailConstraint, self.topConstraint, self.bottomConstraint]];
}

#pragma mark - Animation

- (void)beforeMoveInAppMessageViewOnScreen {
  self.topConstraint.constant = 0;
  self.bottomConstraint.constant = 0;
}

- (void)moveInAppMessageViewOnScreen {
  [self.view.superview layoutIfNeeded];
}

- (void)beforeMoveInAppMessageViewOffScreen {
  self.topConstraint.constant = self.view.frame.size.height;
  self.bottomConstraint.constant = self.view.frame.size.height;
}

- (void)moveInAppMessageViewOffScreen {
  [self.view.superview layoutIfNeeded];
}

@end
