#import <UIKit/UIKit.h>

@interface UserAttributeCell : UITableViewCell

@property IBOutlet UILabel *attributeNameLabel;
@property IBOutlet UITextField *attributeTextField;
@property IBOutlet UISegmentedControl *attributeSegmentedControl;

@end

@interface EventTextFieldCell : UITableViewCell

@property IBOutlet UILabel *eventLabel;
@property IBOutlet UITextField *eventTextField;

@end

@interface EventSwitchCell : UITableViewCell

@property IBOutlet UILabel *eventLabel;
@property IBOutlet UISwitch *eventPropertySwitch;

@end

@interface EventButtonCell : UITableViewCell

@property IBOutlet UIButton *eventButton;
@property (nonatomic, weak) IBOutlet UIView *divView;

@end

@interface EventSegmentedControlCell : UITableViewCell

@property IBOutlet UISegmentedControl *customEventPropertyTypeSegment;

@end
