//
//  ContactTableViewCell.m
//  nimple-iOS
//
//  Created by Ben John on 17/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell () {
    NimpleContact *_contact;
}

@end

@implementation ContactTableViewCell

- (void)setContact:(NimpleContact *)contact
{
    _contact = contact;
    [self configureCell];
}

- (void)configureCell
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", _contact.prename, _contact.surname];
    [self.phoneButton setTitle:_contact.phone forState:UIControlStateNormal];
    [self.emailButton setTitle:_contact.email forState:UIControlStateNormal];
    
    if (_contact.job.length > 0 && _contact.company.length > 0) {
        self.jobCompanyLabel.text = [NSString stringWithFormat:@"%@ (%@)", _contact.company, _contact.job];
    } else if (_contact.job.length > 0) {
        self.jobCompanyLabel.text = _contact.job;
    } else {
        self.jobCompanyLabel.text = _contact.company;
    }
    
    if (_contact.facebook_ID.length == 0 && _contact.facebook_URL.length == 0) {
        self.facebookButton.alpha = 0.2;
    } else {
        self.facebookButton.alpha = 1.0;
    }
    
    if (_contact.twitter_ID.length == 0 && _contact.twitter_URL.length == 0) {
        self.twitterButton.alpha = 0.2;
    } else {
        self.twitterButton.alpha = 1.0;
    }
    
    if (_contact.xing_URL.length == 0) {
        self.xingButton.alpha = 0.2;
    } else {
        self.xingButton.alpha = 1.0;
    }
    
    if (_contact.linkedin_URL.length == 0) {
        self.linkedinButton.alpha = 0.2;
    } else {
        self.linkedinButton.alpha = 1.0;
    }
}

@end
