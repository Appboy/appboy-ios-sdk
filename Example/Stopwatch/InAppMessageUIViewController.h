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
@property IBOutlet UIView *HTMLComposerView;
@property IBOutlet UISegmentedControl *HTMLTypeSegment;
@property IBOutlet UITextField *zipRemoteURLTextField;
@property IBOutlet UITextView *HTMLInAppTextView;
@property UITextField *currentTextField;

- (IBAction)inAppMessageTypeChanged:(id)sender;
- (IBAction)HTMLTypeChanged:(id)sender;

@end
