//
//  ABKStreamViewControllerNavigationContext.h
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
// Use the StreamViewControllerNavigationContext class if you're presenting the stream view controller as a child of
// a UINavigationController.

#import "ABKStreamViewController.h"

@interface ABKStreamViewControllerNavigationContext : ABKStreamViewController <UINavigationControllerDelegate>;

@end
