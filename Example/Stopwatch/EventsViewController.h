#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *labelsArraySection1;
@property NSMutableArray *labelsArraySection2;
@property NSMutableDictionary *valuesDictionary;
@property UITextField *currentTextField;
@property NSInteger eventPropertyType;
@property NSInteger purchasePropertyType;

- (IBAction)switchChangedValue:(UISwitch *)sender;
- (IBAction)logEventOrPurchase:(UIButton *)sender;
- (IBAction)customEventPropertyTypeChanged:(UISegmentedControl *)sender;

@end
