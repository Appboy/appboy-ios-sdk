#import <UIKit/UIKit.h>

@interface UserAttributesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *attributesLabelsArray;
@property (nonatomic, weak) IBOutlet UINavigationBar *modalNavBar;
@property (nonatomic, weak) IBOutlet UITableView *attributesTableView;
@property (nonatomic, strong) NSString *userId;

- (IBAction)doneButtonTapped:(id)sender;

@end
