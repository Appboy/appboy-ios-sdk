//
//  ABKFeedViewControllerGenericContext.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

#import <UIKit/UIKit.h>
#import "ABKFeedViewControllerContext.h"
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
 * ABKFeedViewControllerGenericContext
 */

/*!
 * Use the FeedViewControllerGenericContext class to present a feed view with no navigation
 * controls or close buttons.  You could use this class, for example, when the feed view is in a
 * tab bar controller, or when it's in a split view controller.
 */

@interface ABKFeedViewControllerGenericContext : ABKFeedViewControllerContext <UINavigationControllerDelegate>

@end
