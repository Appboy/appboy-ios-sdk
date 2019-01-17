#import "ViewController.h"
#import <AppboyTVOSKit/AppboyKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)changeUserClick:(id)sender {
  [[Appboy sharedInstance] changeUser:self.changeUserText.text];
}

- (IBAction)eventAndPurchasesClick:(id)sender {
  [[Appboy sharedInstance] logCustomEvent:@"tvOSEvent" withProperties:@{@"tvOSEventPKey" : @1}];
  [[Appboy sharedInstance] logPurchase:@"tvOSPurchase" inCurrency:@"USD" atPrice:[[NSDecimalNumber alloc] initWithString:@"0.99"] withQuantity:1 andProperties:@{@"tvOSPurchasePKey" : @1}];
}

- (IBAction)attributesClick:(id)sender {
  [Appboy sharedInstance].user.firstName = @"tvFirstName";
  [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tvCustomAttribute" andBOOLValue:YES];
}

- (IBAction)feedbackClick:(id)sender {
  [[Appboy sharedInstance] submitFeedback:@"tvuser@tv.com" message:@"great tvos app!" isReportingABug:NO];
}

- (IBAction)feedCardsClick:(id)sender {
  NSArray *feedCards =  [[Appboy sharedInstance].feedController getNewsFeedCards];
  for (ABKCard *card in feedCards) {
    if ([card isKindOfClass:[ABKBannerCard class]]) {
      NSLog(@"Card with value: %@", ((ABKBannerCard *)card).image);
    } else if ([card isKindOfClass:[ABKClassicCard class]]) {
      NSLog(@"Card with value: %@", ((ABKClassicCard *)card).title);
    } else if ([card isKindOfClass:[ABKCaptionedImageCard class]]) {
      NSLog(@"Card with value: %@", ((ABKCaptionedImageCard *)card).title);
    } else if ([card isKindOfClass:[ABKTextAnnouncementCard class]]) {
      NSLog(@"Card with value: %@", ((ABKTextAnnouncementCard *)card).title);
    }
  }
}

@end
