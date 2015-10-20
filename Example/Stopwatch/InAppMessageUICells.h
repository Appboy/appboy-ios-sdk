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
static NSString *const ItemModalFrameColor = @"Frame Color";

static NSString *const CellIdentifierSegment = @"SegmentCellIdentifier";
static NSString *const CellIdentifierText = @"TextCellIdentifier";
static NSString *const CellIdentifierChevron = @"ChevronCellIdentifier";
static NSString *const CellIdentifierColor = @"ColorCellIdentifier";
static NSString *const CellIdentifierButton = @"ButtonCellIdentifer";

@interface SegmentCell : UITableViewCell
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UISegmentedControl *segmentControl;
- (void) setUpWithItem:(NSString *)item;
@end

@interface TextFieldCell : UITableViewCell
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UITextField *textField;

@end

@interface ColorCell : UITableViewCell
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UIButton *colorButton;
- (void) setColor:(UIColor *)color;
- (UIColor *)color;
@end

@interface HideChevronCell : UITableViewCell
@property IBOutlet UISwitch *hideChevronSwitch;

@end

@interface InAppMessageButtonCell : UITableViewCell <UITextFieldDelegate, KKColorListViewControllerDelegate>
@property IBOutlet UITextField *titleTextField;
@property IBOutlet UIButton *textColorButton;
@property IBOutlet UIButton *backgroundColorButton;
@property IBOutlet UISegmentedControl *actionSegmentControl;
@property IBOutlet UITextField *URITextField;
@property (nonatomic) ABKInAppMessageButton *button;
@property NSURL *buttonURL;
@end
