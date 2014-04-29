//
//  ContactTableViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

// Framework imports
#import <UIKit/UIKit.h>
#import "NimpleContact.h"

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, retain) NimpleContact* contact;

// ui properties
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobCompanyLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *xingButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedinButton;

@end
