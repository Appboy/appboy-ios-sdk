#import <Appboy-iOS-SDK/ABKUser.h>
#import "EventsAndPropertiesViewController.h"
#import "Appboy.h"
#import "ABKAttributionData.h"

@interface EventsAndPropertiesViewController ()
@property NSInteger attributionCounter;
@end

@implementation EventsAndPropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Events and Properties";
    self.attributionCounter++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logPurchaseWithProperties:(id)sender {
  [[Appboy sharedInstance]
      logPurchase:@"propPurchase"
       inCurrency:@"USD"
          atPrice:[[NSDecimalNumber alloc] initWithString:@"0.99"]
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

- (IBAction)logAttributionData:(id)sender {
  ABKAttributionData *attributionData = [[ABKAttributionData alloc]
                                         initWithNetwork:[self attributionStringGenerator:@"network"]
                                         campaign:[self attributionStringGenerator:@"campaign"]
                                         adGroup:[self attributionStringGenerator:@"adgroup"]
                                         creative:[self attributionStringGenerator:@"creative"]];
  [[Appboy sharedInstance].user setAttributionData:attributionData];
  self.attributionCounter++;
}

- (NSString *)attributionStringGenerator:(NSString *)inputString {
  return [inputString stringByAppendingString:[NSString stringWithFormat:@"%i", self.attributionCounter]];
}
@end
