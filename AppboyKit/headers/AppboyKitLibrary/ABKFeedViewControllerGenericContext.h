//
//  ABKFeedViewControllerGenericContext.h
//  AppboySDK
//
//  Copyright (c) 2016 Appboy. All rights reserved.

#import <UIKit/UIKit.h>
#import "ABKFeedViewControllerDelegate.h"
#import "ABKFeedController.h"
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

/*
 * Appboy Public API: ABKFeedViewControllerGenericContext
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKFeedViewControllerGenericContext : UINavigationController <UINavigationControllerDelegate>

/*!
 * This property defines the width for each feed card on an iPhone. The default width is 300.0f. This value will only be
 * utilized when each margin between the card and the left and right edges of the view is greater than or equal to
 * minimumCardMarginForiPhone. This property is not utilized on iPad, iPad mini or iPad air.
 */
@property CGFloat cardWidthForiPhone;

/*!
 * This property defines the width for each feed card on an iPad, iPad mini or iPad air. The default width is 600.0f.
 * This property will only utilized when each margin between the card and the left and right edges of the view is greater
 * than or equal to minimumCardMarginForiPad. This property is not utilized on iPhones.
 */
@property CGFloat cardWidthForiPad;

/*!
 * This property defines the minimum acceptable left and right margins between the card and and the edge of the view on an iPhone.
 * The default value is 10.0f. If the defined cardWidthForiPhone would create margins less than the value of this property
 * a new card width will be calculated automatically to provide the defined minimumCardMarginForiPhone
 */
@property CGFloat minimumCardMarginForiPhone;

/*!
 * This property defines the minimum acceptable left and right margins between the card and and the edge of the view on an iPad.
 * The default value is 20.0f. If the defined cardWidthForiPad would create margins less than the value of this property
 * a new card width will be calculated automatically to provide the defined minimumCardMarginForiPad.
 */
@property CGFloat minimumCardMarginForiPad;

/*! Delegate */
@property (weak, nullable) id<ABKFeedViewControllerDelegate> appboyDelegate;

- (void)closeButtonPressed:(id)sender;

/*!
 * This property is to indicate what categories of cards the news feed is displaying.
 * Setting this proerty will automatically update the news feed page and only display cards in the given categories.
 */
@property ABKCardCategory categories;

/*!
 *  This property allows you to enable or disable the unread indicator on the news feed. The default value is NO, which
 *  will enable the displaying of the unread indicator on cards.
 */
@property (nonatomic) BOOL disableUnreadIndicator;

@end
NS_ASSUME_NONNULL_END
