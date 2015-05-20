//
//  ABKFeedViewController.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

/*!
 * This class is used internally; you don't need to include it.
 */

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "ABKFeedViewControllerDelegate.h"
#import "ABKFeedController.h"

/*
 * Appboy Public API: ABKFeedViewController
 */
@interface ABKFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
    SKStoreProductViewControllerDelegate>

/*! 
 * This property defines the width for each feed card on an iPhone. The default width is 300.0f. This value will only be
 * utilized when each margin between the card and the left and right edges of the view is greater than or equal to
 * minimumCardMarginForiPhone. This property is not utilized on iPad, iPad mini or iPad air.
 */
@property (nonatomic, assign) CGFloat cardWidthForiPhone;

/*!
 * This property defines the width for each feed card on an iPad, iPad mini or iPad air. The default width is 600.0f.
 * This property will only utilized when each margin between the card and the left and right edges of the view is greater
 * than or equal to minimumCardMarginForiPad. This property is not utilized on iPhones.
 */
@property (nonatomic, assign) CGFloat cardWidthForiPad;

/*!
 * This property defines the minimum acceptable left and right margins between the card and and the edge of the view on an iPhone.
 * The default value is 10.0f. If the defined cardWidthForiPhone would create margins less than the value of this property
 * a new card width will be calculated automatically to provide the defined minimumCardMarginForiPhone
 */
@property (nonatomic, assign) CGFloat minimumCardMarginForiPhone;

/*!
 * This property defines the minimum acceptable left and right margins between the card and and the edge of the view on an iPad.
 * The default value is 20.0f. If the defined cardWidthForiPad would create margins less than the value of this property
 * a new card width will be calculated automatically to provide the defined minimumCardMarginForiPad.
 */
@property (nonatomic, assign) CGFloat minimumCardMarginForiPad;

/*! Delegate */
@property (assign, nonatomic) id<ABKFeedViewControllerDelegate> appboyDelegate;

/*!
 * This property is to indicate what categories of cards the news feed is displaying. 
 * Setting this property will automatically update the news feed page and only display cards in the given categories.
 * This method won't request refresh of cards from Appboy server, but only look into cards that are cached in the SDK.
 */
@property (nonatomic, assign) ABKCardCategory categories;

/*!
 *  This property allows you to enable or disable the unread indicator on the news feed. The default value is NO, which
 *  will enable the displaying of the unread indicator on cards.
 */
@property (nonatomic, assign) BOOL disableUnreadIndicator;

@end
