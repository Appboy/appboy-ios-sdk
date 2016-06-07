#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *labelsArray;
@property NSMutableDictionary *valuesDictionary;
@property UITextField *currentTextField;

- (IBAction)switchChangedValue:(UISwitch *)sender;
- (IBAction)logEventOrPurchase:(UIButton *)sender;

@end
