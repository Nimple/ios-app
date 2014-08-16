//
//  NimpleCardViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditNimpleCodeTableViewController.h"

@interface NimpleCardViewController : UIViewController<EditNimpleCodeTableControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UILabel     *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;
@property (weak, nonatomic) IBOutlet UILabel     *companyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property (weak, nonatomic) IBOutlet UILabel     *jobLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jobIcon;
@property (weak, nonatomic) IBOutlet UIImageView *facebookIcon;
@property (weak, nonatomic) IBOutlet UIImageView *twitterIcon;
@property (weak, nonatomic) IBOutlet UIImageView *xingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *linkedinIcon;
@property (weak, nonatomic) IBOutlet UIView      *welcomeView;
@property (weak, nonatomic) IBOutlet UIView      *nimpleCardView;
@property (atomic, strong) NSUserDefaults        *myNimpleCode;

@end
