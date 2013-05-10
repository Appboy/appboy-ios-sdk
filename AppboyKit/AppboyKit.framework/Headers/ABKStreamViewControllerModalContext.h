//
// ABKStreamViewControllerModalContext.h
//
// Copyright (c) 2013 Appboy. All rights reserved.
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
// Use this class to present a stream view controller as a modal view.
//
// This controller provides a "close" button on the right side of its navigation bar which,
// when tapped, sends the ABKStreamViewControllerModalContextCloseTapped:sender message to the closeButtonDelegate.
// If the delegate is *not* set, the controller dismisses itself;  if it is set, it's the responsibility of
// the delegate to dismiss the controller.  The delegate should adopt the
// ABKStreamViewControllerModalContextDelegate protocol.

#import <UIKit/UIKit.h>
#import "ABKStreamViewControllerContext.h"

@protocol ABKStreamViewControllerModalContextDelegate;

@interface ABKStreamViewControllerModalContext : ABKStreamViewControllerContext

// Title displayed in the top bar
@property (retain, nonatomic) NSString *navigationBarTitle;

// Delegate
@property (assign, nonatomic) id closeButtonDelegate;

@end


@protocol ABKStreamViewControllerModalContextDelegate <NSObject>

- (void) streamViewControllerModalContextCloseTapped:(ABKStreamViewControllerModalContext *)sender;

@end

