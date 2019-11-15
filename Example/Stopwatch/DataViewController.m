#import "DataViewController.h"
#import "AppboyKit.h"

@implementation DataViewController

static NSString *const sdkEnabled = @"SDK is Enabled";
static NSString *const sdkDisabled = @"SDK is Disabled";
static NSString *const sdkWillBeEnabled = @"SDK will be enabled on next app run";

- (void)viewDidLoad {
  [self updateSdkStateLabelText];
}

- (IBAction)wipeDataButton:(id)sender {
  [Appboy wipeDataAndDisableForAppRun];
  [self updateSdkStateLabelText];
}

- (IBAction)enableSDKButton:(id)sender {
  [Appboy requestEnableSDKOnNextAppRun];
  self.sdkState.text = [Appboy sharedInstance] != nil ? sdkEnabled : sdkWillBeEnabled;
}

- (IBAction)disableSDKButton:(id)sender {
  [Appboy disableSDK];
  [self updateSdkStateLabelText];
}

- (void) updateSdkStateLabelText {
  // Using the presence of the singleton as a proxy for being disabled
  // Clients should have their own business logic for determining when to disable the SDK and understanding the SDK's current state
  self.sdkState.text = [Appboy sharedInstance] != nil ? sdkEnabled : sdkDisabled;
}

@end
