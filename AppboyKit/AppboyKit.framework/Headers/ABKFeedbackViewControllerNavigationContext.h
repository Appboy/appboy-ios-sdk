//
//  ABKFeedbackViewControllerNavigationContext.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//
// The FeedbackViewController classes implement the form you present to your users to collect feedback.
// To integrate, simply create a FeedbackViewController -- either programmatically or in a storyboard -- like
// you'd create any view controller, and present it.
//
// There are three different versions of the FeedbackViewController: Modal, Popover, and Navigation.
// Pick the one which matches the context in which you're using the FeedbackViewController; for example,
// if you present the FeedbackViewController in a modal view, use FeedbackViewControllerModalContext. If you
// present it in a popover, use FeedbackViewControllerPopoverContext.
//
// ---------------------------------------------------------------------------------------------------------------
//
// Use this controller to present the feedback view controller as a child of a UINavigationController.
//
// If a delegate is set, the controller will send feedbackViewControllerNavigationContextFeedbackSent:sender after
// feedback has been sent successfully.

#import "ABKFeedbackViewController.h"

@class ABKFeedbackViewControllerNavigationContext;

@protocol ABKFeedbackViewControllerNavigationContextDelegate <NSObject>

- (void) feedbackViewControllerNavigationContextFeedbackSent:(ABKFeedbackViewControllerNavigationContext *)sender;

@end

@interface ABKFeedbackViewControllerNavigationContext : ABKFeedbackViewController

@property (assign, nonatomic) id <ABKFeedbackViewControllerNavigationContextDelegate> delegate;

@end
