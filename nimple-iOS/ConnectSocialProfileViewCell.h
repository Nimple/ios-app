//
//  ConnectSocialProfileViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

// SDK imports
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <IOSLinkedInAPI/LIALinkedInAuthorizationViewController.h>
// Nimple imports
#import "EditNimpleCodeTableViewController.h"

@interface ConnectSocialProfileViewCell : UITableViewCell<FBLoginViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (atomic) NSInteger                  index;
@property (atomic) NSInteger                  section;
@property (weak, nonatomic) IBOutlet UIButton *socialNetworkButton;
@property (weak, nonatomic) IBOutlet UIButton *connectStatusButton;
@property (atomic, strong) FBLoginView        *fbLoginView;
@property (nonatomic) ACAccountStore          *twitterAcount;
@property (strong, atomic) UIActionSheet      *actionSheet;
@property (strong, atomic) UIAlertView        *alertView;

@end
