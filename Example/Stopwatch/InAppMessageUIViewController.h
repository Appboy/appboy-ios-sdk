#import <UIKit/UIKit.h>
#import "KKColorListPicker.h"

@class ABKSlideup;

@interface InAppMessageUIViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
  UIActionSheetDelegate, KKColorListViewControllerDelegate>
@property (retain, nonatomic) NSMutableArray *inAppSlideupList;
@property (retain, nonatomic) NSMutableArray *inAppModalList;
@property (retain, nonatomic) NSMutableArray *inAppFullList;
@property (retain, nonatomic) NSMutableDictionary *inAppMessageDictionary;
@property (retain, nonatomic) IBOutlet UISegmentedControl *inAppMessageTypeSegment;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (IBAction) inAppMessageTypeChanged:(id)sender;

@end
