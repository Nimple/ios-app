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
#import <IOSLinkedInAPI/LIALinkedInApplication.h>
#import <IOSLinkedInAPI/LIALinkedInHttpClient.h>
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
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
@property (nonatomic) LIALinkedInHttpClient   *linkedInClient;
@property (weak, nonatomic) IBOutlet UISwitch *propertySwitch;
@property (nonatomic) BDBOAuth1SessionManager *networkManager;

- (void)configureCell;
- (void)animatePropertySwitchVisibilityTo:(NSInteger)value;
- (void)authorizeXing;
- (void)deauthorizeWithCompletion:(void (^)(void))completion;
- (LIALinkedInHttpClient *)linkedInClient;


@end
