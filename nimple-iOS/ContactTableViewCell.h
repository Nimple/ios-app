//
//  ContactTableViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

// Framework imports
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
// Nimple imports
#import "NimpleContact.h"

@interface ContactTableViewCell : UITableViewCell <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) NimpleContact* contact;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobCompanyLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIImageView *saveToContactsView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

- (ABRecordRef)addAccountWithFirstName:(NSString*)p_prename LastName:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job CompanyName:(NSString*)p_company inAddressBook:(ABAddressBookRef)addressBook;

@end
