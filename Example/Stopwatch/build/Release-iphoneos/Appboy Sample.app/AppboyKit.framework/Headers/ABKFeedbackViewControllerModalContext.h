//
//  ABKFeedbackViewControllerModalContext.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//
//  The FeedbackViewController classes implement the form you present to your users to collect feedback.
//  To integrate, simply create a FeedbackViewController -- either programmatically or in a storyboard -- like
//  you'd create any view controller, and present it.
//
//  There are three different versions of the FeedbackViewController: Modal, Popover, and Navigation.
//  Pick the one which matches the context in which you're using the FeedbackViewController; for example,
//  if you present the FeedbackViewController in a modal view, use FeedbackViewControllerModalContext. If you
//  present it in a popover, use FeedbackViewControllerPopoverContext.
//
// ---------------------------------------------------------------------------------------------------------------
//
//  Use this class to present a feedback view controller as a modal view.
//
//  This controller has "send" and "cancel" buttons on its navigation bar. If the delegate is set, it sends
//  feedbackViewControllerModalContextCancelTapped:sender when the cancel button is tapped, or
//  feedbackViewControllerModalContextFeedbackSent:sender after feedback has been sent successfully.
//
//  If the delegate is *not* set, the controller dismisses itself after cancel or send completes.

#import "ABKFeedbackViewController.h"

@class ABKFeedbackViewControllerModalContext;

@protocol ABKFeedbackViewControllerModalContextDelegate <NSObject>

- (void) feedbackViewControllerModalContextCancelTapped:(ABKFeedbackViewControllerModalContext *)sender;

- (void) feedbackViewControllerModalContextFeedbackSent:(ABKFeedbackViewControllerModalContext *)sender;

@end

@interface ABKFeedbackViewControllerModalContext : ABKFeedbackViewController

@property (assign, nonatomic) id <ABKFeedbackViewControllerModalContextDelegate> delegate;

@end
