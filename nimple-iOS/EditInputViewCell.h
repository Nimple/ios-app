//
//  EditInputViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditInputViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) NSString* value;

@end
