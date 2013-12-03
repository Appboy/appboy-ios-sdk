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

@interface ABKFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
    SKStoreProductViewControllerDelegate>
@end

