#import "AppboyKit.h"
#import "KKColorListPicker.h"

static NSString *const ItemIcon = @"Icon Badge";
static NSString *const ItemImageURL = @"Image URL";
static NSString *const ItemIconColor = @"Icon Color";
static NSString *const ItemIconBackgroundColor = @"Icon Background";
static NSString *const ItemMessage = @"Message";
static NSString *const ItemBodyColor = @"Body Text Color";
static NSString *const ItemHeader = @"Title";
static NSString *const ItemHeaderColor = @"Title Color";
static NSString *const ItemBackgroundColor = @"Background";
static NSString *const ItemHideChevron = @"Hide Chevron";
static NSString *const ItemChevronColor = @"Chevron Color";
static NSString *const ItemCloseButtonColor = @"Close Button Color";
static NSString *const ItemClickAction = @"Action";
static NSString *const ItemClickActionURL = @"Action URL";
static NSString *const ItemDismissType = @"Dismiss";
static NSString *const ItemDuration = @"Duration(s)";
static NSString *const ItemAnimatedFrom = @"Aminated From";
static NSString *const ItemButtonNumber = @"Buttons:";
static NSString *const ItemButtonOne = @"Button One";
static NSString *const ItemButtonTwo = @"Button Two";

static NSString *const CellIdentifierSegment = @"SegmentCellIdentifier";
static NSString *const CellIdentifierText = @"TextCellIdentifier";
static NSString *const CellIdentifierChevron = @"ChevronCellIdentifier";
static NSString *const CellIdentifierColor = @"ColorCellIdentifier";
static NSString *const CellIdentifierButton = @"ButtonCellIdentifer";

@interface SegmentCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (void) setUpWithItem:(NSString *)item;
@end

@interface TextFieldCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *textField;

@end

@interface ColorCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *colorButton;
- (void) setColor:(UIColor *)color;
- (UIColor *)color;
@end

@interface HideChevronCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UISwitch *hideChevronSwitch;

@end

@interface InAppMessageButtonCell : UITableViewCell <UITextFieldDelegate, KKColorListViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UIButton *textColorButton;
@property (retain, nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *actionSegmentControl;
@property (retain, nonatomic) IBOutlet UITextField *URITextField;
@property (retain, nonatomic) ABKInAppMessageButton *button;
@property (retain, nonatomic) NSURL *buttonURL;
@end
