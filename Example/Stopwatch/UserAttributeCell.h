//
//  UserAttributeCell.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAttributeCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *attributeNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *attributeTextField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *attributeSegmentedControl;

@end
