//
//  EditAddressInputViewCell.m
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditAddressInputViewCell.h"

@interface EditAddressInputViewCell() {
    __weak IBOutlet UITextField *_streetTextField;
    __weak IBOutlet UITextField *_postalTextField;
    __weak IBOutlet UITextField *_cityTextField;
    __weak IBOutlet UISwitch *_propertySwitch;
    
    NimpleCode *_code;
}
@end

@implementation EditAddressInputViewCell

- (void)configureCell
{
    _code = [NimpleCode sharedCode];
    [self localizeViewAttributes];
    [self updateView];
    [self configurePropertySwitch];
}

- (void)localizeViewAttributes
{
    _streetTextField.placeholder = @"Street";
    _postalTextField.placeholder = @"Postal";
    _cityTextField.placeholder = @"City";
}

- (void)updateView
{
    _streetTextField.text = _code.addressStreet;
    _postalTextField.text = _code.addressPostal;
    _cityTextField.text = _code.addressCity;
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
    _code.addressSwitch = _propertySwitch.isOn;
}

- (IBAction)editingChanged:(id)sender
{
    _code.addressStreet = _streetTextField.text;
    _code.addressPostal = _postalTextField.text;
    _code.addressCity = _cityTextField.text;
}

- (IBAction)editingDidEnd:(id)sender
{
    if([self isFilled])
        [self animatePropertySwitchVisibilityTo:1.0];
    else
        [self animatePropertySwitchVisibilityTo:0.0];
    _code.addressStreet = _streetTextField.text;
    _code.addressPostal = _postalTextField.text;
    _code.addressCity = _cityTextField.text;
}

- (void)animatePropertySwitchVisibilityTo:(NSInteger)value
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [_propertySwitch setAlpha:value];
    [UIView commitAnimations];
}

@end
