//
//  EditInputViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditInputViewCell.h"

@implementation EditInputViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)propertySwitched:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if(self.section == 0)
    {
        if(self.index == 2)
        {
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"phone_switch"];
        }
        if(self.index == 3)
        {
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"email_switch"];
        }
    }
    if(self.section == 1)
    {
        if(self.index == 0)
        {
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"company_switch"];
        }
        if(self.index == 1)
        {
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"job_switch"];
        }
    }
    
    [viewController.myNimpleCode synchronize];
}


// Editing of the input cell has changed
- (IBAction)editingChanged:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if(self.section == 0)
    {
        if(self.index == 0)
        {
            // Prename is required, no need toc heck propertySwitch
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"prename"];
        }
        if(self.index ==  1)
        {
            // Surname is required, no need toc heck propertySwitch
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"surname"];
        }
        if(self.index == 2)
        {
            
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"phone"];
            
        }
        if(self.index == 3)
        {
            
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"email"];
        }
    }
    if(self.section == 1)
    {
        if(self.index == 0)
        {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"company"];
        }
        if(self.index == 1)
        {
            [viewController.myNimpleCode setValue:self.inputField.text forKey:@"job"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Save the user data
- (IBAction)EditingDidEnd:(id)sender {
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    switch (self.section)
    {
        case 0:
            switch (self.index)
            {
                case 0:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"prename"];
                    if(self.inputField.text.length == 0)
                    {
                        [self.inputField setPlaceholder:@"Dein Vorname"];
                    }
                    break;
                case 1:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"surname"];
                    if(self.inputField.text.length == 0)
                    {
                        [self.inputField setPlaceholder:@"Dein Nachname"];
                    }
                    break;
                case 2:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"phone"];
                    if(self.inputField.text.length == 0)
                        [self.inputField setPlaceholder:@"Deine Telefonnummer"];
                    break;
                case 3:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"email"];
                    if(self.inputField.text.length == 0)
                        [self.inputField setPlaceholder:@"Deine E-Mail Adresse"];
                    break;
            }
            break;
        case 2:
            switch (self.index)
            {
                case 0:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"job"];
                    if(self.inputField.text.length == 0)
                        [self.inputField setPlaceholder:@"Deine Job Bezeichnung"];
                    break;
                case 1:
                    [viewController.myNimpleCode setValue:self.inputField.text forKey:@"company"];
                    if(self.inputField.text.length == 0)
                        [self.inputField setPlaceholder:@"Deine Firma"];
                    break;
            }
            break;
    }
}


@end
