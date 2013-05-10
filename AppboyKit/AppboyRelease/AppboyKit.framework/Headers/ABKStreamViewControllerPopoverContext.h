//
//  ABKStreamViewControllerPopoverContext.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//
// The StreamViewController classes implement the scrolling view of news items you display for users of your app.
// To integrate, simply create a StreamViewController -- either programmatically or in a storyboard -- like
// you'd create any view controller, and present it.
//
// There are four different versions of the StreamViewController: Generic, Modal, Popover, and Navigation.
// Pick the one which matches the context in which you're using the StreamViewController; for example,
// if you present the StreamViewController in a modal view, use StreamViewControllerModalContext. If you
// present it in a popover, use StreamViewControllerPopoverContext.
//
// ---------------------------------------------------------------------------------------------------------------
//
// Use the StreamViewControllerPopoverContext to present a stream view controller in a popover.
//
// This controller provides a "close" button on the popover's navigation bar. When the button
// is tapped, the controller sends the ABKStreamViewControllerPopoverContextCloseTapped:sender message to
// closeButtonDelegate.  You can use this message to trigger closing the popover.
// The delegate should adopt the ABKStreamViewControllerPopoverContextDelegate protocol.

#import <UIKit/UIKit.h>
#import "ABKStreamViewControllerContext.h"

@protocol ABKStreamViewControllerPopoverContextDelegate;

@interface ABKStreamViewControllerPopoverContext : ABKStreamViewControllerContext

// Title displayed in the top bar
@property (retain, nonatomic) NSString *navigationBarTitle;

// Delegate
@property (assign, nonatomic) id closeButtonDelegate;

@end


@protocol ABKStreamViewControllerPopoverContextDelegate <NSObject>

- (void) streamViewControllerPopoverContextCloseTapped:(ABKStreamViewControllerPopoverContext *)sender;

@end

