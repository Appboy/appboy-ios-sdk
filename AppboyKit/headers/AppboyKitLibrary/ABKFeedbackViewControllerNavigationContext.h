//
//  ABKFeedbackViewControllerNavigationContext.h
//  AppboySDK
//
//  Copyright (c) 2016 Appboy. All rights reserved..

#import "ABKFeedbackViewController.h"
/* ------------------------------------------------------------------------------------------------------
 * ABKFeedbackViewController
 */

@class ABKFeedbackViewControllerNavigationContext;

NS_ASSUME_NONNULL_BEGIN
@protocol ABKFeedbackViewControllerNavigationContextDelegate <NSObject>

/*!
  @param sender The calling context

  Called when feedback is sent.
*/
- (void)feedbackViewControllerNavigationContextFeedbackSent:(ABKFeedbackViewControllerNavigationContext *)sender;

@optional
/*!
  @param message The feedback message

  Called before feedback is submitted.  Return a message to be submitted.
*/
- (NSString *)feedbackViewControllerBeforeFeedbackSent:(NSString *)message;

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
 * ABKFeedbackViewControllerNavigationContext
 */

/*!
 * Use the ABKFeedbackViewControllerNavigationContext to present the feedback view controller as a child of a UINavigationController.
 *
 * If a delegate is set, the controller will send feedbackViewControllerNavigationContextFeedbackSent:sender after
 * feedback has been sent successfully.
 */

/*
 * Appboy Public API: ABKFeedbackViewControllerNavigationContext
 */
@interface ABKFeedbackViewControllerNavigationContext : ABKFeedbackViewController

@property (nonatomic, weak, nullable) id <ABKFeedbackViewControllerNavigationContextDelegate> delegate;

@end
NS_ASSUME_NONNULL_END
