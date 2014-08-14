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
}
@end

@implementation EditAddressInputViewCell

- (void)configureCell
{
    [self localizeViewAttributes];
}

- (void)localizeViewAttributes
{
    _streetTextField.placeholder = @"Street";
    _postalTextField.placeholder = @"Postal";
    _cityTextField.placeholder = @"City";
    _propertySwitch.hidden = YES;
}

@end
