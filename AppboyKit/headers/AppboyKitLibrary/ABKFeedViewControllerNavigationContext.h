//
//  ABKFeedViewControllerNavigationContext.h
//  AppboySDK
//
//  Copyright (c) 2016 Appboy. All rights reserved.

#import "ABKFeedViewController.h"
/* ------------------------------------------------------------------------------------------------------
 * ABKFeedViewController
 */

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
 * Use the FeedViewControllerNavigationContext class if you're presenting the feed view controller as a child of
 * a UINavigationController.
 */

/*
 * Appboy Public API: ABKFeedViewControllerNavigationContext
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKFeedViewControllerNavigationContext : ABKFeedViewController <UINavigationControllerDelegate>;

@end
NS_ASSUME_NONNULL_END
