//
//  ABKStreamViewControllerGenericContext.h
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
// Use the StreamViewControllerGenericContext class to present a stream view with no navigation
// controls or close buttons.  You could use this class, for example, when the stream view is in a
// tab bar controller, or when it's in a split view controller.

#import <UIKit/UIKit.h>
#import "ABKStreamViewControllerContext.h"

@interface ABKStreamViewControllerGenericContext : ABKStreamViewControllerContext <UINavigationControllerDelegate>

@end
