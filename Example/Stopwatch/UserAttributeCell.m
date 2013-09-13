#import "UserAttributeCell.h"

@implementation UserAttributeCell

- (void)dealloc {
  [_attributeNameLabel release];
  [_attributeTextField release];
  [_attributeSegmentedControl release];
  [super dealloc];
}
@end
