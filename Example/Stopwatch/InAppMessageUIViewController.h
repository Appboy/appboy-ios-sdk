#import <UIKit/UIKit.h>
#import "KKColorListPicker.h"

@class ABKSlideup;

@interface InAppMessageUIViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
  UIActionSheetDelegate, KKColorListViewControllerDelegate>
@property NSMutableArray *inAppSlideupList;
@property NSMutableArray *inAppModalList;
@property NSMutableArray *inAppFullList;
@property NSMutableDictionary *inAppMessageDictionary;
@property IBOutlet UISegmentedControl *inAppMessageTypeSegment;
@property IBOutlet UITableView *tableView;

@property UITextField *currentTextField;

- (IBAction)inAppMessageTypeChanged:(id)sender;

@end
