//
//  DisplayContactViewController.h
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimpleContact.h"
#import "AddressBookUI/ABUnknownPersonViewController.h"
#import <MessageUI/MessageUI.h>

@class DisplayContactViewController;

@protocol DisplayContactViewControllerDelegate <NSObject>

@required
- (void) displayContactViewControllerDidSave:(DisplayContactViewController*)controller;
- (void) displayContactViewControllerDidDelete:(DisplayContactViewController*)controller;
@end

@interface DisplayContactViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, ABUnknownPersonViewControllerDelegate, MFMailComposeViewControllerDelegate>


// delegate
@property (nonatomic, weak) id <DisplayContactViewControllerDelegate> delegate;

// iOS ui-related
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

// core data
@property (nonatomic, strong) NimpleContact *nimpleContact;

// ui properties
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UIButton *facebookURL;
@property (weak, nonatomic) IBOutlet UIButton *twitterURL;
@property (weak, nonatomic) IBOutlet UIButton *xingURL;
@property (weak, nonatomic) IBOutlet UIButton *linkedinURL;

// social icons
@property (weak, nonatomic) IBOutlet UIButton *facebookIcon;
@property (weak, nonatomic) IBOutlet UIButton *twitterIcon;
@property (weak, nonatomic) IBOutlet UIButton *xingIcon;
@property (weak, nonatomic) IBOutlet UIButton *linkedinIcon;

// buttons
@property (weak, nonatomic) IBOutlet UIButton *saveToAddressBookButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteContactButton;

// dialogs
@property (strong, atomic) UIActionSheet *actionSheetDelete;
@property (strong, atomic) UIActionSheet *actionSheetAddressbook;

-(void)saved;
-(void)checkForAccess;

@end