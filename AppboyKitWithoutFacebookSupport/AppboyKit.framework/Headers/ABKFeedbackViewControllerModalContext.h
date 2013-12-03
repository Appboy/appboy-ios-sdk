//
//  ABKFeedbackViewControllerModalContext.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

#import "ABKFeedbackViewController.h"
/* ------------------------------------------------------------------------------------------------------
 * ABKFeedbackViewController
 */

@class ABKFeedbackViewControllerModalContext;

@protocol ABKFeedbackViewControllerModalContextDelegate <NSObject>
@optional
/*!
  @param sender The calling context

  Called when the feedback modal is cancelled.
*/
- (void) feedbackViewControllerModalContextCancelTapped:(ABKFeedbackViewControllerModalContext *)sender;

/*!
  @param sender The calling context

  Called when feedback is sent from the modal.
*/
- (void) feedbackViewControllerModalContextFeedbackSent:(ABKFeedbackViewControllerModalContext *)sender;

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
 * ABKFeedbackViewControllerModalContext
 */

/*!
 * Use the ABKFeedbackViewControllerModalContext class to present a feedback view controller as a modal view.
 *
 * This controller has "send" and "cancel" buttons on its navigation bar. If the delegate is set, it sends
 * feedbackViewControllerModalContextCancelTapped:sender when the cancel button is tapped, or
 * feedbackViewControllerModalContextFeedbackSent:sender after feedback has been sent successfully.
 *
 * If the delegate is *not* set, the controller dismisses itself after cancel or send completes.
 */
@interface ABKFeedbackViewControllerModalContext : UINavigationController

@property (assign, nonatomic) id <ABKFeedbackViewControllerModalContextDelegate> feedbackDelegate;

@end
