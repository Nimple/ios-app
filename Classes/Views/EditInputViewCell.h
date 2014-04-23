//
//  EditInputViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditNimpleCodeTableViewController.h"

@interface EditInputViewCell : UITableViewCell <UITextFieldDelegate>

@property (atomic) NSInteger                      index;
@property (atomic) NSInteger                      section;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) NSString             *value;
@property (weak, nonatomic) IBOutlet UISwitch    *propertySwitch;

-(void) animatePropertySwitchVisibilityTo:(NSInteger)value;

@end
