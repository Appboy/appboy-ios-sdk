#import <Appboy-iOS-SDK/ABKUser.h>
#import "EventsAndPropertiesViewController.h"
#import "Appboy.h"

@interface EventsAndPropertiesViewController ()
@end

@implementation EventsAndPropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Events and Properties";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logPurchaseWithProperties:(id)sender {
  [[Appboy sharedInstance]
      logPurchase:@"propPurchase"
       inCurrency:@"USD"
          atPrice:[[[NSDecimalNumber alloc] initWithString:@"0.99"] autorelease]
     withQuantity:1
    andProperties:@{
        @"propPurIntKey": @2,
        @"propPurStringKey": @"propPurStringVal",
        @"propPurDoubleKey": @3.3,
        @"propPurBoolKey": [NSNumber numberWithBool:YES],
        @"propPurDateKey": [NSDate date]
    }];
}

- (IBAction)logCustomEventWIthProperties:(id)sender {
  [[Appboy sharedInstance]
      logCustomEvent:@"propEvent"
      withProperties:@{
          @"propEvIntKey": @2,
          @"propEvStringKey": @"propEvStringVal",
          @"propEvDoubleKey": @3.3,
          @"propEvBoolKey": [NSNumber numberWithBool:YES],
          @"propEvDateKey": [NSDate date],
      }
   ];
}
@end
