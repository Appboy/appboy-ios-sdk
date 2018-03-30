#import "DataViewController.h"
#import "AppboyKit.h"

@implementation DataViewController

- (IBAction)wipeDataButton:(id)sender {
  [Appboy wipeDataAndDisableForAppRun];
}

- (IBAction)enableSDKButton:(id)sender {
  [Appboy requestEnableSDKOnNextAppRun];
}

- (IBAction)disableSDKButton:(id)sender {
  [Appboy disableSDK];
}

@end
