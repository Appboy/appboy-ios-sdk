#import <UIKit/UIKit.h>

@interface UserAttributesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (retain, nonatomic) NSArray *attributesLabelsArray;
@property (retain, nonatomic) NSMutableArray *attributesValuesArray;
@property (retain, nonatomic) IBOutlet UINavigationBar *modalNavBar;
@property (retain, nonatomic) IBOutlet UITableView *attributesTableView;

- (IBAction) doneButtonTapped:(id)sender;
- (IBAction) setGender:(UISegmentedControl *)sender;


@end
