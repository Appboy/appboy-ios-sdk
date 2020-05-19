#import <UIKit/UIKit.h>
#import "UserCustomAttribute.h"

typedef void (^SelectNextCellBlock) (UITableViewCell *);
typedef void (^TextFieldShouldBeginEditingBlock) (UITableViewCell *);

@interface UserCustomAttributeCell: UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *keyTextField;
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;

@property (nonatomic, weak) UserCustomAttribute *customAttibute;
@property (nonatomic, copy) SelectNextCellBlock selectNextCellBlock;
@property (nonatomic, copy) TextFieldShouldBeginEditingBlock textFieldShouldBeginEditingBlock;

- (void)setUserCustomAttribute:(UserCustomAttribute *)customAttribute selectNextCellBlock:(SelectNextCellBlock)nextCellBlock textFieldShouldBeginEditingBlock:(TextFieldShouldBeginEditingBlock)textFieldBlock;

@end
