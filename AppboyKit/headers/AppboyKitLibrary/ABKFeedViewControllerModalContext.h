//
//  ABKFeedViewControllerModalContext.h
//  AppboySDK
//
//  Copyright (c) 2016 Appboy. All rights reserved.

#import <UIKit/UIKit.h>
#import "ABKFeedViewControllerGenericContext.h"
/* ------------------------------------------------------------------------------------------------------
 * ABKFeedViewController
 */

/*
 * Appboy Public API: ABKFeedViewControllerModalContextDelegate
 */
NS_ASSUME_NONNULL_BEGIN
@protocol ABKFeedViewControllerModalContextDelegate;

/*!
 * The FeedViewController classes implement the scrolling view of cards you display for users of your app.
 * To integrate, simply create a FeedViewController -- either programmatically or in a storyboard -- like
 * you'd create any view controller, and present it.
 *
 * There are four different versions of the FeedViewController: Generic, Modal, Popover, and Navigation.
 * Pick the one which matches the context in which you're using the FeedViewController; for example,
 * if you present the FeedViewController in a modal view, use FeedViewControllerModalContext. If you
 * present it in a popover, use FeedViewControllerPopoverContext.
 */

/* ------------------------------------------------------------------------------------------------------
 * ABKFeedViewControllerModalContext
 */

/*!
 * Use this class to present a feed view controller as a modal view.
 *
 * This controller provides a "close" button on the right side of its navigation bar which,
 * when tapped, sends the ABKFeedViewControllerModalContextCloseTapped:sender message to the closeButtonDelegate.
 * If the delegate is *not* set, the controller dismisses itself;  if it is set, it's the responsibility of
 * the delegate to dismiss the controller.  The delegate should adopt the
 * ABKFeedViewControllerModalContextDelegate protocol.
 */

/*
 * Appboy Public API: ABKFeedViewControllerModalContext
 */
@interface ABKFeedViewControllerModalContext : ABKFeedViewControllerGenericContext

/*! Title displayed in the top bar */
@property (strong, nullable) NSString *navigationBarTitle;

/*! Delegate */
@property (weak, nullable) id<ABKFeedViewControllerModalContextDelegate> closeButtonDelegate;

@end


@protocol ABKFeedViewControllerModalContextDelegate <NSObject>

/*!
  @param sender The calling context

  Called when the feed modal is closed.
*/
- (void)feedViewControllerModalContextCloseTapped:(ABKFeedViewControllerModalContext *)sender;

@end
NS_ASSUME_NONNULL_END
