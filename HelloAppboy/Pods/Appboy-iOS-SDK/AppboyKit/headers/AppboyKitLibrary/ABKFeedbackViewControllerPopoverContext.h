//
//  ABKFeedbackViewControllerPopoverContext.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

#import "ABKFeedbackViewController.h"
/* ------------------------------------------------------------------------------------------------------
 * ABKFeedbackViewController
 */

@class ABKFeedbackViewControllerPopoverContext;

@protocol ABKFeedbackViewControllerPopoverContextDelegate <NSObject>

@required

/*!
  @param sender The calling context

  Called when the popover is cancelled.
*/
- (void) feedbackViewControllerPopoverContextCancelTapped:(ABKFeedbackViewControllerPopoverContext *)sender;

/*!
  @param sender The calling context

  Called when feedback is sent by the popover.
*/
- (void) feedbackViewControllerPopoverContextFeedbackSent:(ABKFeedbackViewControllerPopoverContext *)sender;

@end

/*!
 * The FeedbackViewController classes implement the form you present to your users to collect feedback.
 * To integrate, simply create a FeedbackViewController -- either programmatically or in a storyboard -- like
 * you'd create any view controller, and present it.
 *
 * There are three different versions of the FeedbackViewController: Modal, Popover, and Navigation.
 * Pick the one which matches the context in which you're using the FeedbackViewController; for example,
 * if you present the FeedbackViewController in a modal view, use FeedbackViewControllerModalContext. If you
 * present it in a popover, use FeedbackViewControllerPopoverContext.
 */

/* ------------------------------------------------------------------------------------------------------
 * ABKFeedbackViewControllerPopoverContext
 */

/*!
 * Use the FeedbackViewControllerPopoverContext to present a feedback view controller in a popover.
 *
 * This controller has "send" and "cancel" buttons on its navigation bar.  When the cancel button is
 * tapped, the controller sends the feedbackViewControllerPopoverContextCancelTapped:sender to the delegate.
 * When feedback has been sent successfully, the controller sends feedbackViewControllerPopoverContextFeedbackSent:sender.
 * Use these messages to trigger dismissing the popover.
 */

/*
 * Appboy Public API: ABKFeedbackViewControllerPopoverContext
 */
@interface ABKFeedbackViewControllerPopoverContext : ABKFeedbackViewController

@property (assign, nonatomic) id <ABKFeedbackViewControllerPopoverContextDelegate> delegate;

@end
