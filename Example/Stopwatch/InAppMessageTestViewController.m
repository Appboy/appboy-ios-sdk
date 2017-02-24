#import "InAppMessageTestViewController.h"
#import "CustomInAppMessageViewController.h"

@implementation InAppMessageTestViewController

/*
 * For further details regarding in-app message delegate methods and stacking mechanisms, please see
 * ABKInAppMessageControllerDelegate.h and ABKInAppMessageController.h
 */

#pragma mark Appboy In-App Message Delegate methods

// This delegate method is called every time a new in-app message is received from the Appboy server.
// Implementing this method is OPTIONAL. The default behavior is equivalent to a return of NO from this method. In other
// words, Appboy will handle the in-app message display automatically if this delegate method is not implemented.
- (BOOL)onInAppMessageReceived:(ABKInAppMessage *)inAppMessage {
  //Return NO when you want Appboy to handle the in-app message display.
  return NO;
}

/*!
 * This callback method allows you to specify if each in-app message should be displayed. It is called just before each in-app
 * message is displayed. Please check ABKInAppMessageControllerDelegate.h for more about the return value ABKInAppMessageDisplayChoice
 *
 * In-app message queuing:
 *
 * Arriving in-app messages are stacked when they can't be displayed for one of these reasons:
 * - Another in-app message is visible
 * - If the beforeInAppMessageDisplayed:withKeyboardIsUp: delegate method HAS NOT been implemented and keyboard is being
 *   displayed currently.
 * - If the beforeInAppMessageDisplayed:withKeyboardIsUp: delegate method returned ABKDisplayInAppMessageLater
 *
 * In-app messages are potentially removed from the in-app message stack and displayed when:
 * - Another in-app messages arrives and onInAppMessageReceived: DOES NOT return YES.
 * - The application comes to the foreground after being backgrounded
 * - displayNextInAppMessageWithDelegate is called
 *
 * If one of these events occurs and the in-app message can't be displayed, it remains in the stack.
 *
 * Note that if you unset the delegate after some in-app messages have been stacked, the accumulated stacked in-app messages
 * will be displayed according to the above scheme.
 */
- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage
                                            withKeyboardIsUp:(BOOL)keyboardIsUp {
  NSLog(@"Received in-app message with message: %@", inAppMessage.message);
  
  
  // We want to display the in-app message from the top if there is a keyboard being displayed on the screen.
  if (keyboardIsUp && [inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    ((ABKInAppMessageSlideup *)inAppMessage).inAppMessageSlideupAnchor = ABKInAppMessageSlideupFromTop;
  }
  
  [self updateRemainingIAMLabel];

  // /Check if the delegate is called by a click on the "Display Next Available In-App Message" button.
  if (self.shouldDisplayInAppMessage && self.segmentedControlForInAppMode.selectedSegmentIndex == 1) {
    // If the in-app message mode is ABKDisplayInAppMessageLater and the user has clicked the "Display Next Available In-App Message"
    // button, this will display the next available in-app message.
    return ABKDisplayInAppMessageNow;
  } else {
    switch (self.segmentedControlForInAppMode.selectedSegmentIndex) {
      case 0:
        return ABKDisplayInAppMessageNow;

      case 1:
        return ABKDisplayInAppMessageLater;

      case 2:
        return ABKDiscardInAppMessage;

      default:
        return ABKDisplayInAppMessageNow;
    }
  }
}

// This delegate method asks if there is any custom in-app message view controller that developers want to pass in. The returned
// view controller should be a subclass of ABKInAppMessageViewController.
// Also, the view of the returned view controller should be an instance of ABKInAppMessageView or its subclass.
- (ABKInAppMessageViewController *)inAppMessageViewControllerWithInAppMessage:(ABKInAppMessage *)inAppMessage {
  if (self.useCustomViewControllerSwitch.isOn) {
    return [[CustomInAppMessageViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    return [[ABKInAppMessageSlideupViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageModal class]]) {
    return [[ABKInAppMessageModalViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageFull class]]) {
    return [[ABKInAppMessageFullViewController alloc] initWithInAppMessage:inAppMessage];
  } else {
    CustomInAppMessageViewController *customInAppMessage = [[CustomInAppMessageViewController alloc] initWithInAppMessage:inAppMessage];
    return customInAppMessage;
  }
  return nil;
}

// This delegate method is notified if the in-app message is tapped.  You can use this to initiate an action
// in response to the tap.  Note that when the delegate returns NO, Appboy SDK will perform the action sent down from
// the Appboy Server after the delegate method is executed. If it returns YES, the response to the tap is up to you.
- (BOOL)onInAppMessageClicked:(ABKInAppMessage *)inAppMessage {
  NSLog(@"In-app message tapped!");
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch", nil)
                                                      message:NSLocalizedString(@"Appboy.Stowpatch.slideup-test.slideup-is-tap", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  alertView = nil;
  
  [inAppMessage setInAppMessageClickAction:ABKInAppMessageNoneClickAction withURI:nil];
  // Returning YES here to prevent Appboy from performing the click action.
  return YES;
}

#pragma mark Stopwatch view controller methods

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    // In iOS 7, views are automatically extended to fit the size of the screen. Therefore, views may end up under
    // the navigation bar, which makes some buttons invisible or unclickable. In order to prevent this behaviour, we set
    // the Extended Layout mode to UIRectEdgeNone.
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // Here we set self as the in-app message controller delegate to enable in-app message customization on this page.
  [Appboy sharedInstance].inAppMessageController.delegate = self;
  
  self.remainingIAMLabel.text = [NSString stringWithFormat:@"IAMs Remaining in Stack: %ld", [[Appboy sharedInstance].inAppMessageController inAppMessagesRemainingOnStack]];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [Appboy sharedInstance].inAppMessageController.delegate = nil;
}
// If we've been returning ABKDisplayInAppMessageLater and in-app message have arrived, they'll be put in the stack.  Here, take
// one off the stack and display it.
- (IBAction)displayNextAvailableInAppPressed:(id)sender {
  self.shouldDisplayInAppMessage = YES;
  [[Appboy sharedInstance].inAppMessageController displayNextInAppMessageWithDelegate:self];
  self.shouldDisplayInAppMessage = NO;
  [self updateRemainingIAMLabel];
}

- (IBAction)requestAnInApp:(id)sender {
  [[Appboy sharedInstance] requestInAppMessageRefresh];
  [self updateRemainingIAMLabel];
}

- (IBAction)dismissCurrentSlideup:(id)sender {
  [[Appboy sharedInstance].inAppMessageController hideCurrentInAppMessage:YES];
  [self updateRemainingIAMLabel];
}

- (void)updateRemainingIAMLabel {
  self.remainingIAMLabel.text = [NSString stringWithFormat:@"IAMs Remaining in Stack: %ld", [[Appboy sharedInstance].inAppMessageController inAppMessagesRemainingOnStack]];
}

@end
