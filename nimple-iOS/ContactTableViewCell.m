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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)linkedinButtonClicked:(id)sender {
    NSLog(@"linkedin clicked");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.contact.linkedin_URL]];
}

- (IBAction)xingButtonClicked:(id)sender {
    NSLog(@"xing clicked");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.contact.xing_URL]];
}

- (IBAction)twitetrButtonClicked:(id)sender {
    NSLog(@"twitter clicked %@", self.contact.twitter_URL);
    NSURL *url = [NSURL URLWithString:self.contact.twitter_URL];
    [[UIApplication sharedApplication] openURL:url];
}

// Opens the browser with the facebook URL
- (IBAction)facebookButtonClicked:(id)sender
{
    NSLog(@"facebook clicked: %@", self.contact.facebook_URL);
    NSString* formatted = [NSString stringWithFormat:@"%@", self.contact.facebook_URL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formatted]];
}

// Delegates calling a phone number to the phone app
- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"Phone calling...");
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *cellNameStr = [NSString stringWithFormat:@"%@", self.phoneButton.currentTitle];
    
    if ([[device model] isEqualToString:@"iPhone"])
    {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:cellNameStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else
    {
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Error: Phone Calls does not work properly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warning show];
    }
}

// Delegates the sending of an email to the mail app
- (IBAction)mailButtonClicked:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailContent = [[MFMailComposeViewController alloc] init];
        // Required to invoke mailComposeController when send
        mailContent.mailComposeDelegate = self;
        
        [mailContent setSubject:@""];
        [mailContent setToRecipients:[NSArray arrayWithObject:self.emailButton.currentTitle]];
        [mailContent setMessageBody:@"" isHTML:NO];
        
        [self.window.rootViewController presentViewController:mailContent animated:YES completion:nil];
    }
    else
        NSLog(@"Error: Your Mail Account may not be set up.");
}

// Called when returning from mail app
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// Sets the contact of the cell
- (void)setContact:(NimpleContact *)contact;
{
    if (contact != _contact)
    {
        _contact = contact;
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.contact.prename, self.contact.surname]];
        [self.phoneButton setTitle:self.contact.phone forState:UIControlStateNormal];
        [self.emailButton setTitle:self.contact.email forState:UIControlStateNormal];
        self.jobCompanyLabel.text = [NSString stringWithFormat:@"%@ @ %@", contact.job, contact.company];
    }
}

// Handles clicking the phone book icon
- (IBAction)saveToAddressBookButtonClicked:(id)sender {
    ABAddressBookRef addressBook = NULL;
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus())
    {
        case kABAuthorizationStatusAuthorized:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            
            [self addAccountWithFirstName:self.contact.prename LastName:self.contact.surname PhoneNumber:self.phoneButton.currentTitle MailAddress:self.emailButton.currentTitle JobTitle:@"" CompanyName:@"" inAddressBook:addressBook];
            
            if (addressBook != NULL) CFRelease(addressBook);
            break;
        }
        case kABAuthorizationStatusDenied:
        {
            NSLog(@"Access denied to address book");
            break;
        }
        case kABAuthorizationStatusNotDetermined:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"Access was granted");
                    [self addAccountWithFirstName:self.nameLabel.text LastName:self.nameLabel.text PhoneNumber:self.phoneButton.currentTitle MailAddress:self.emailButton.currentTitle JobTitle:@"" CompanyName:@"" inAddressBook:addressBook];
                }
                else NSLog(@"Access was not granted");
                if (addressBook != NULL) CFRelease(addressBook);
            });
            break;
        }
        case kABAuthorizationStatusRestricted: {
            NSLog(@"access restricted to address book");
            break;
        }
    }
}

// Saves a contact to the address book of the phone
- (ABRecordRef)addAccountWithFirstName:(NSString*)p_prename LastName:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job CompanyName:(NSString*)p_company inAddressBook:(ABAddressBookRef)addressBook
{
    ABRecordRef result = NULL;
    CFErrorRef error   = NULL;
    
    result = ABPersonCreate();
    if (result == NULL) {
        NSLog(@"Failed to create a new person.");
        return NULL;
    }
    

    BOOL couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef)p_prename, &error);
    BOOL couldSetLastName = ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef)p_surname, &error);
    //BOOL couldSetPhone = ABRecordSetValue(result, kABPersonPhoneProperty, (__bridge CFTypeRef)p_phone, &error);
    //BOOL couldSetMail = ABRecordSetValue(result, kABPersonEmailProperty, (__bridge CFTypeRef)p_mail, &error);
    //BOOL couldSetJob = ABRecordSetValue(result, kABPersonJobTitleProperty, (__bridge CFTypeRef)p_job, &error);
    //BOOL couldSetCompany = ABRecordSetValue(result, kABPersonOrganizationProperty, (__bridge CFTypeRef)p_company, &error);
    
    if (couldSetFirstName && couldSetLastName)
    {
        NSLog(@"Successfully set the first name and the last name of the person.");
    } else {
        NSLog(@"Failed.");
    }
    
    BOOL couldAddPerson = ABAddressBookAddRecord(addressBook, result, &error);
    
    if (couldAddPerson) {
        NSLog(@"Successfully added the person.");
    } else {
        NSLog(@"Failed to add the person.");
        CFRelease(result);
        result = NULL;
        return result;
    }
    
    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        BOOL couldSaveAddressBook = ABAddressBookSave(addressBook, &error);
        
        if (couldSaveAddressBook) {
            NSLog(@"Succesfully saved the address book.");
        } else {
            NSLog(@"Failed.");
        }
    }
    
    return result;
}

@end
