#import "AliasViewController.h"
#import "AppboyKit.h"

@implementation AliasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addUserAliasButtonClick:(id)sender {  
  [[Appboy sharedInstance].user addAlias:self.aliasTextField.text withLabel:self.aliasLabelTextField.text];
}

@end
