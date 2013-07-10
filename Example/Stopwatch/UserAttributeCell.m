//
//  UserAttributeCell.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "UserAttributeCell.h"

@implementation UserAttributeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
  [_attributeNameLabel release];
  [_attributeTextField release];
    [_attributeSegmentedControl release];
  [super dealloc];
}
@end
