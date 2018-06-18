#import "CustomFeedTableViewController.h"
#include <objc/runtime.h>

@implementation CustomFeedTableViewController

- (instancetype)init {
  self = [super init];
  object_setClass(self, [CustomFeedTableViewController class]);
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor blackColor];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  if ([cell isKindOfClass:[ABKNFBaseCardCell class]]) {
    ABKNFBaseCardCell *cardCell = (ABKNFBaseCardCell *)cell;
    cardCell.rootView.backgroundColor = [UIColor lightGrayColor];
    cardCell.rootView.layer.borderColor = [UIColor purpleColor].CGColor;
    
    if ([cardCell isKindOfClass:[ABKNFCaptionedMessageCardCell class]]) {
      ((ABKNFCaptionedMessageCardCell *)cardCell).TitleBackgroundView.backgroundColor = [UIColor darkGrayColor];
      ((ABKNFCaptionedMessageCardCell *)cardCell).titleLabel.textColor = [UIColor brownColor];
    }
  }
  return cell;
}

- (void)handleCardClick:(ABKCard *)card {
  NSLog(@"The card %@ is clicked.", card.idString);
  
  [super handleCardClick:card];
}

@end
