#import <UIKit/UIKit.h>

@interface UserAttributesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property NSArray *attributesLabelsArray;
@property IBOutlet UINavigationBar *modalNavBar;
@property IBOutlet UITableView *attributesTableView;
@property (weak) UITextField *currentEditingTextField;

- (IBAction) doneButtonTapped:(id)sender;
- (IBAction) setGender:(UISegmentedControl *)sender;
- (IBAction)backButtonTapped:(id)sender;

@end
