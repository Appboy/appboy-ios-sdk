#import "AppboyInterfaceController.h"
#import "AppboyWatchKit.h"
#import "ABWKUser.h"

@implementation AppboyInterfaceController

// Test all the Appboy WatchKit SDK feature in one click!
- (IBAction)testAll:(id)sender {
  [ABWKUser setFirstName:@"First Name"];
  [ABWKUser setLastName:@"Last Name"];
  [ABWKUser setEmail:@"stopwatch@appboy.com"];
  [ABWKUser setDateOfBirth:[NSDate date]];
  [ABWKUser setCountry:@"USA"];
  [ABWKUser setHomeCity:@"New York City"];
  [ABWKUser setBio:@"Appboy"];
  [ABWKUser setPhone:@"1234567890"];
  [ABWKUser setAvatarImageURL:@"https://github.com/Appboy/appboy-ios-sdk/blob/master/Appboy_Logo_Smiley_Red-01.png?raw=true"];
  [ABWKUser setCustomAttributeWithKey:@"Bool Attribute" andBOOLValue:YES];
  [ABWKUser setCustomAttributeWithKey:@"Date Attribute" andDateValue:[NSDate date]];
  [ABWKUser setCustomAttributeWithKey:@"Double Attribute" andDoubleValue:3.14159];
  [ABWKUser setCustomAttributeWithKey:@"Integer Attribute" andIntegerValue:21];
  [ABWKUser setCustomAttributeWithKey:@"String Attribute" andStringValue:@"www.appboy.com"];
  [ABWKUser setCustomAttributeWithKey:@"Unset String Attribute" andStringValue:@"Unset Attribute"];
  [ABWKUser unsetCustomAttributeWithKey:@"Unset String Attribute"];
  [ABWKUser incrementCustomUserAttribute:@"Increment Attribute" by:7];
  [ABWKUser setCustomAttributeArrayWithKey:@"Candy" array:@[@"Cracker Jack", @"Haribo", @"Jelly Belly", @"Heinz"]];
  [ABWKUser addToCustomAttributeArrayWithKey:@"Candy" value:@"Mars"];
  [ABWKUser removeFromCustomAttributeArrayWithKey:@"Candy" value:@"Heinz"];
  [ABWKUser setLastKnownLocationWithLatitude:40.6892 longitude:-74.0444 horizontalAccuracy:0.0001 altitude:92.99 verticalAccuracy:0.01];
  [AppboyWatchKit logCustomEvent:@"Test All Custom Event" withProperties:@{@"custom key" : @"custom value"}];
  [AppboyWatchKit logPurchase:@"watch purchase" inCurrency:@"USD"
                      atPrice:[NSDecimalNumber decimalNumberWithString:@"1.99"]
                 withQuantity:2
                andProperties:@{@"purchase key" : @"purchase value"}];
  [AppboyWatchKit submitFeedback:@"watch@appboy.com" message:@"Feedback from watch." isReportingABug:NO];
}

- (IBAction)logCustomEvent {
  [AppboyWatchKit logCustomEvent:@"watch custom event"];
}

- (IBAction)logPurchase {
  [AppboyWatchKit logPurchase:@"watch purchase" inCurrency:@"USD" atPrice:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
}

- (IBAction)logCustomAttribute {
  [ABWKUser setCustomAttributeWithKey:@"watch bool custom attribute" andBOOLValue:YES];
}

- (IBAction)logCustomAttributeArray {
  [ABWKUser setCustomAttributeArrayWithKey:@"watch custom array" array:@[@"string1", @"string2"]];
}

- (IBAction)logCustomIncrement {
  [ABWKUser incrementCustomUserAttribute:@"watch increment attribute"];
}

@end



