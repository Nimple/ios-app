//
//  ContactTableViewCell.h
//  nimple-iOS
//
//  Created by Ben John on 17/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimpleContact.h"

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobCompanyLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *xingButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedinButton;

- (void)configureCell;
- (void)setContact:(NimpleContact *)contact;

@end
