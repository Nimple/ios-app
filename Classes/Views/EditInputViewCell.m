//
//  EditInputViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditInputViewCell.h"

@implementation EditInputViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)propertySwitched:(id)sender {
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if(self.section == 0) {
        if(self.index == 2) {
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"phone_switch"];
        } else if(self.index == 3) {
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"email_switch"];
        }
    } else if(self.section == 1) {
        if(self.index == 0) {
            NSLog(@"COMPANY SIWTCH");
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"company_switch"];
        } else if(self.index == 1) {
            NSLog(@"JOB SIWTCH");
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"job_switch"];
        }
    }
}


// Editing of the input cell has changed
- (IBAction)editingChanged:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if(self.section == 0) {
        if(self.index == 0) {
            // Prename is required, no need to check propertySwitch
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"prename"];
        } else if(self.index ==  1) {
            // Surname is required, no need to check propertySwitch
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"surname"];
        } else if(self.index == 2) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"phone"];
        } else if(self.index == 3) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"email"];
        }
    } else if(self.section == 1) {
        if(self.index == 0) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"company"];
        } else if(self.index == 1) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"job"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// editing of a cell ended, saving input
- (IBAction)EditingDidEnd:(id)sender {
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if(self.section == 0) {
        if(self.index == 0) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"prename"];
            if(self.inputField.text.length == 0) {
                [self.inputField setPlaceholder:@"Dein Vorname"];
            }
        } else if(self.index == 1) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"surname"];
            if(self.inputField.text.length == 0) {
                [self.inputField setPlaceholder:@"Dein Nachname"];
            }
        } else if(self.index == 2) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"phone"];
            if(self.inputField.text.length == 0) {
                [self.inputField setPlaceholder:@"Deine Telefonnummer"];
            }
        } else if(self.index == 3) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"email"];
            if(self.inputField.text.length == 0) {
                [self.inputField setPlaceholder:@"Deine E-Mail Adresse"];
            }
        }
    } else if(self.section == 2) {
        if(self.index == 0) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"job"];
            if(self.inputField.text.length == 0) {
                [self.inputField setPlaceholder:@"Deine Job Bezeichnung"];
            }
        } else if(self.index == 1) {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"company"];
            if(self.inputField.text.length == 0) {
                [self.inputField setPlaceholder:@"Deine Firma"];
            }
        }
    }
}

@end
