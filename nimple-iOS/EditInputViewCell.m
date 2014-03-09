//
//  EditInputViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditInputViewCell.h"

@implementation EditInputViewCell

@synthesize myNimpleCode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)editingChanged:(id)sender
{
    UITableView *tv = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tv.dataSource;
    
    switch (self.section) {
        case 0:
            switch (self.index) {
                case 0:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"prename"];
                    break;
                case 1:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"surname"];
                    break;
                case 2:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"phone"];
                    break;
                case 3:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"email"];
                    break;
            }
            break;
        case 2:
            switch (self.index) {
                case 0:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"job"];
                    break;
                case 1:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"company"];
                    break;
            }
            break;
    }
}

- (IBAction)valueChanged:(id)sender
{
    NSLog(@"Value changed");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Save the user data
- (IBAction)EditingDidEnd:(id)sender {
    UITableView *tv = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tv.dataSource;
    
    switch (self.section) {
        case 0:
            switch (self.index) {
                case 0:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"prename"];
                    break;
                case 1:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"surname"];
                    break;
                case 2:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"phone"];
                    break;
                case 3:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"email"];
                    break;
            }
            break;
        case 2:
            switch (self.index) {
                case 0:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"job"];
                    break;
                case 1:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"company"];
                    break;
            }
            break;
    }
    
    [viewController.myNimpleCode synchronize];
}


@end
