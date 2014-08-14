//
//  EditAddressInputViewCell.m
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditAddressInputViewCell.h"
#import "EditNimpleCodeTableViewController.h"

@interface EditAddressInputViewCell() {
    __weak IBOutlet UITextField *_streetTextField;
    __weak IBOutlet UITextField *_postalTextField;
    __weak IBOutlet UITextField *_cityTextField;
    __weak IBOutlet UISwitch *_propertySwitch;
}
@end

@implementation EditAddressInputViewCell

- (void)configureCell
{
    [self localizeViewAttributes];
    [self configurePropertySwitch];
    [self updateView];
}

- (void)localizeViewAttributes
{
    _streetTextField.placeholder = @"Street";
    _postalTextField.placeholder = @"Postal";
    _cityTextField.placeholder = @"City";
    _propertySwitch.hidden = YES;
}

- (void)configurePropertySwitch
{
    if(![self isFilled]) {
        [_propertySwitch setAlpha:0.0];
        [_propertySwitch setOn:YES];
    } else {
        [_propertySwitch setAlpha:1.0];
        [_propertySwitch setOn:YES];
    }
}

- (void)updateView
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    _streetTextField.text = [viewController.myNimpleCode valueForKey:@"street"];
    _postalTextField.text = [viewController.myNimpleCode valueForKey:@"postal"];
    _cityTextField.text = [viewController.myNimpleCode valueForKey:@"city"];
}

- (BOOL)isFilled
{
    if (_streetTextField.text.length != 0)
        return true;
    if (_postalTextField.text.length != 0)
        return true;
    if (_cityTextField.text.length != 0)
        return true;
    return false;
}

#pragma mark - Control for ui elements

- (IBAction)propertySwitched:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode setBool:_propertySwitch.isOn forKey:@"address_switch"];
}

- (IBAction)editingChanged:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode setValue:_streetTextField.text forKey:@"street"];
    [viewController.myNimpleCode setValue:_postalTextField.text forKey:@"postal"];
    [viewController.myNimpleCode setValue:_cityTextField.text forKey:@"city"];
}

- (IBAction)editingDidEnd:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if([self isFilled])
        [self animatePropertySwitchVisibilityTo:1.0];
    else
        [self animatePropertySwitchVisibilityTo:0.0];
    
    [viewController.myNimpleCode setValue:_streetTextField.text forKey:@"street"];
    [viewController.myNimpleCode setValue:_postalTextField.text forKey:@"postal"];
    [viewController.myNimpleCode setValue:_cityTextField.text forKey:@"city"];
}

- (void)animatePropertySwitchVisibilityTo:(NSInteger)value
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [_propertySwitch setAlpha:value];
    [UIView commitAnimations];
}

@end
