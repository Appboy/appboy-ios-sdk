#import <UIKit/UIKit.h>

@interface UserAttributesArrayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *attributeKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *attributeValueTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setToSegmentedControl;
@property NSMutableArray *setValuesArray;
@property UITextField *currentTextField;
@property (nonatomic, assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIButton *removeValuesButton;
@property (weak, nonatomic) IBOutlet UIButton *addValuesButton;

@end