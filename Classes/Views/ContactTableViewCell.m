//
//  ContactTableViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize contact = _contact;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// Sets the contact of the cell
- (void)setContact:(NimpleContact *)contact; {
    if (contact != _contact) {
        _contact = contact;
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.contact.prename, self.contact.surname]];
        [self.phoneButton setTitle:self.contact.phone forState:UIControlStateNormal];
        [self.emailButton setTitle:self.contact.email forState:UIControlStateNormal];
        if(contact.job.length != 0)
            [self.jobCompanyLabel setText:[NSString stringWithFormat:@"%@ (%@)", contact.company, contact.job]];
        else
            [self.jobCompanyLabel setText:[NSString stringWithFormat:@"%@", contact.company]];
    }
}

@end