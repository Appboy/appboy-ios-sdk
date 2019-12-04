#import "ABKInAppMessageHTMLFullViewController.h"
#import "ABKInAppMessageView.h"

@implementation ABKInAppMessageHTMLFullViewController

- (void)loadView {
  // View is full screen and covers status bar. It needs to be an ABKInAppMessageView to
  // ensure touches register as per custom logic in ABKInAppMessageWindow
  self.view = [[ABKInAppMessageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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

- (BOOL)prefersStatusBarHidden {
  return YES;
}

@end
