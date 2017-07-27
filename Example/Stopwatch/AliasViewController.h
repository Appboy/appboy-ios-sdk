@interface AliasViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *aliasLabelTextField;
@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;

- (IBAction)addUserAliasButtonClick:(id)sender;

@end
