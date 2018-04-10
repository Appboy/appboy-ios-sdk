#import "AliasViewController.h"
#import "AppboyKit.h"
#import "UIViewController+Keyboard.h"

@implementation AliasViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addDismissGestureForView:self.view];
}

- (IBAction)addUserAliasButtonClick:(id)sender {  
  [[Appboy sharedInstance].user addAlias:self.aliasTextField.text withLabel:self.aliasLabelTextField.text];
}

@end
