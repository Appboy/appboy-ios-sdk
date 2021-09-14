#import <UIKit/UIKit.h>
#import "UserSubscriptionGroup.h"
#import "StopwatchSegmentedControl.h"

typedef void (^SelectNextCellBlock) (UITableViewCell *);
typedef void (^TextFieldShouldBeginEditingBlock) (UITableViewCell *);

@interface UserSubscriptionGroupCell: UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *groupIdTextField;
@property (nonatomic, weak) IBOutlet StopwatchSegmentedControl *statusSegmentControl;

@property (nonatomic, weak) UserSubscriptionGroup *subscriptionGroup;
@property (nonatomic, copy) SelectNextCellBlock selectNextCellBlock;
@property (nonatomic, copy) TextFieldShouldBeginEditingBlock textFieldShouldBeginEditingBlock;

- (void)setUserSubscriptionGroup:(UserSubscriptionGroup *)subscriptionGroup
             selectNextCellBlock:(SelectNextCellBlock)nextCellBlock
textFieldShouldBeginEditingBlock:(TextFieldShouldBeginEditingBlock)textFieldBlock;

@end
