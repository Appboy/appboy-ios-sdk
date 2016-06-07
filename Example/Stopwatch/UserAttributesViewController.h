#import <UIKit/UIKit.h>

@interface UserAttributesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property NSArray *attributesLabelsArray;
@property IBOutlet UINavigationBar *modalNavBar;
@property IBOutlet UITableView *attributesTableView;
@property (weak) UITextField *currentEditingTextField;
@property NSString *userID;

- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)setGender:(UISegmentedControl *)sender;

@end
