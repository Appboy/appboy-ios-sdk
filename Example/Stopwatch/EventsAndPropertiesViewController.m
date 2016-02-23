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

- (IBAction)logCustomEventFromTextBox:(id)sender {
  [self.customEventTextField resignFirstResponder];
  NSString *customEventName = self.customEventTextField.text;
  self.customEventTextField.text = @"";
  // wait 1 second to dismiss the keyboard in case an IAM is triggered and waiting for displaying
  [[Appboy sharedInstance] performSelector:@selector(logCustomEvent:) withObject:customEventName afterDelay:1];
}
- (IBAction)logPropertyFromTextBox:(id)sender {
  [self.purchaseTextField resignFirstResponder];
  NSString *purchaseName = self.purchaseTextField.text;
  self.purchaseTextField.text = @"";
  // wait 1 second to dismiss the keyboard in case an IAM is triggered and waiting for displaying
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [[Appboy sharedInstance] logPurchase:purchaseName inCurrency:@"USD" atPrice:[[NSDecimalNumber alloc] initWithString:@"0.99"] withQuantity:1];
  });
}

- (NSString *)attributionStringGenerator:(NSString *)inputString {
  return [inputString stringByAppendingString:[NSString stringWithFormat:@"%i", self.attributionCounter]];
}

- (IBAction)launchCachedFilesAlertView:(id)sender {
  NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
  NSArray *allFiles = [self getDirectoryContentsWithPath:cachePath];
  NSString *fileString = [allFiles componentsJoinedByString:@"\n"];
  UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Cache Files"
                                                     message:fileString
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  [theAlert show];
}

- (NSArray *)getDirectoryContentsWithPath:(NSString *)path {
  NSMutableArray *returnArray = [NSMutableArray array];
  NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:path];
  BOOL isDirectory;
  int count = 1;
  for (NSString *item in subpaths){
    NSString *fullPath = [[path stringByAppendingString:@"/"] stringByAppendingString:item];
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
    if (fileExistsAtPath) {
      if (!isDirectory && ![item hasSuffix:@".DS_Store"])
      {
        [returnArray addObject:[NSString stringWithFormat:@"%d) %@", count, item]];
        count++;
        NSLog(@"Cache file: %@", item);
      }
    }
  }
  return returnArray;
}

@end
