#import "ViewController.h"

@import Appboy_iOS_SDK.AppboyKit;

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)identifyButtonClicked:(id)sender {
  if (self.userIDTextField.text.length > 0) {
    NSString *userID = self.userIDTextField.text;
    [[Appboy sharedInstance] changeUser:userID];
  }
}

- (IBAction)flushButtonClicked:(id)sender {
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
}

- (IBAction)customAttributeButtonClicked:(id)sender {
  NSString *customAttributeKey = nil;
  if (self.customAttributeKeyTextField.text.length > 0) {
    customAttributeKey = self.customAttributeKeyTextField.text;
  }
  NSString *customAttributeValue = nil;
  if (self.customAttributeValueTextField.text.length > 0) {
    customAttributeValue = self.customAttributeValueTextField.text;
  }
  
  if (customAttributeKey.length > 0 && customAttributeValue.length > 0) {
    [[Appboy sharedInstance].user setCustomAttributeWithKey:customAttributeKey andStringValue:customAttributeValue];
  }
}

- (IBAction)trackButtonClicked:(id)sender {
  NSString *customEvent = nil;
  if (self.customEventTextField.text.length > 0) {
    customEvent = self.customEventTextField.text;
  }
  NSString *propertyKey = nil;
  if (self.customEventPropertyKeyTextField.text.length > 0) {
    propertyKey = self.customEventPropertyKeyTextField.text;
  }
  NSString *propertyValue = nil;
  if (self.customEventPropertyValueTextField.text.length > 0) {
    propertyValue = self.customEventPropertyValueTextField.text;
  }
  if (customEvent.length > 0) {
    if (propertyKey.length > 0 && propertyValue > 0) {
      NSDictionary *properties = @{propertyKey:propertyValue};
      [[Appboy sharedInstance] logCustomEvent:customEvent withProperties:properties];
    } else {
      [[Appboy sharedInstance] logCustomEvent:customEvent];
    }
  }
}

@end
