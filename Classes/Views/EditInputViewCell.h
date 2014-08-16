//
//  EditInputViewCell.h
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimpleCode.h"

@interface EditInputViewCell : UITableViewCell

@property (atomic) NSInteger                      index;
@property (atomic) NSInteger                      section;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISwitch    *propertySwitch;

- (void)configureCell;
- (void)animatePropertySwitchVisibilityTo:(NSInteger)value;

@end
