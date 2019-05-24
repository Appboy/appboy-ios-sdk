#import "InAppMessageTestViewController.h"
#import "AppboyInAppMessage.h"
#import "AlertControllerUtils.h"

@implementation InAppMessageTestViewController

/*
 * For further details regarding in-app message delegate methods and stacking mechanisms, please see
 * ABKInAppMessageControllerDelegate.h and ABKInAppMessageController.h
 */

#pragma mark Braze In-App Message Delegate methods

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
  
  [self updateRemainingInAppMessageLabel];

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

/*!
 * This callback method allows you to specify if each control in-app message should be logged. It is called just before each control in-app
 * message is logged. Please check ABKInAppMessageControllerDelegate.h for more about the return value ABKInAppMessageDisplayChoice
 *
 * In-app message queuing:
 *
 * Arriving control in-app messages are stacked when they can't be logged for one of these reasons:
 * - Another non-control in-app message is visible
 * - If the keyboard is being displayed currently.
 *
 * Control in-app messages are potentially removed from the in-app message stack and logged when:
 * - The application comes to the foreground after being backgrounded
 * - displayNextInAppMessageWithDelegate is called
 *
 * If one of these events occurs and the control in-app message can't be logged, it remains in the stack.
 *
 * Note that if you unset the delegate after some control in-app messages have been stacked, the accumulated stacked control in-app messages
 * will be logged according to the above scheme.
 */
- (ABKInAppMessageDisplayChoice)beforeControlMessageImpressionLogged:(ABKInAppMessage *)inAppMessage {
  NSLog(@"Received in-app message with message: %@", inAppMessage.message);
  
  [self updateRemainingInAppMessageLabel];
  
  // /Check if the delegate is called by a click on the "Display Next Available In-App Message" button.
  if (self.shouldDisplayInAppMessage && self.segmentedControlForInAppMode.selectedSegmentIndex == 1) {
    // If the in-app message mode is ABKDisplayInAppMessageLater and the user has clicked the "Display Next Available In-App Message"
    // button, this will log the next available control in-app message.
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
  if ([inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    return [[ABKInAppMessageSlideupViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageModal class]]) {
    return [[ABKInAppMessageModalViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageFull class]]) {
    return [[ABKInAppMessageFullViewController alloc] initWithInAppMessage:inAppMessage];
  }
  return nil;
}

// This delegate method is notified if the in-app message is tapped.  You can use this to initiate an action
// in response to the tap.  Note that when the delegate returns NO, Braze SDK will perform the action sent down from
// the Braze Server after the delegate method is executed. If it returns YES, the response to the tap is up to you.
- (BOOL)onInAppMessageClicked:(ABKInAppMessage *)inAppMessage {
  NSLog(@"In-app message tapped!");
  [AlertControllerUtils presentTemporaryAlertWithTitle:NSLocalizedString(@"Appboy.Stopwatch", nil)
                                                 message:NSLocalizedString(@"Appboy.Stowpatch.slideup-test.slideup-is-tap", nil)
                                            presentingVC:self];

  [inAppMessage setInAppMessageClickAction:ABKInAppMessageNoneClickAction withURI:nil];
  // Returning YES here to prevent Braze from performing the click action.
  return YES;
}

#pragma mark Stopwatch view controller methods

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // Here we set self as the in-app message controller delegate to enable in-app message customization on this page.
  [Appboy sharedInstance].inAppMessageController.delegate = self;
  
  self.remainingIAMLabel.text = [NSString stringWithFormat:@"In-App Messages Remaining in Stack: %ld", [[Appboy sharedInstance].inAppMessageController inAppMessagesRemainingOnStack]];
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
  [self updateRemainingInAppMessageLabel];
}

- (IBAction)dismissCurrentSlideup:(id)sender {
  [[Appboy sharedInstance].inAppMessageController.inAppMessageUIController hideCurrentInAppMessage:YES];
  [self updateRemainingInAppMessageLabel];
}

- (void)updateRemainingInAppMessageLabel {
  self.remainingIAMLabel.text = [NSString stringWithFormat:@"In-App Messages Remaining in Stack: %ld", [[Appboy sharedInstance].inAppMessageController inAppMessagesRemainingOnStack]];
}

@end
