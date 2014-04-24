//
//  ContactTableViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "Logging.h"

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

// Opens the browser with the linkedin url
- (IBAction)linkedinButtonClicked:(id)sender
{
    NSLog(@"linkedin clicked");
    if(self.contact.linkedin_URL.length != 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.contact.linkedin_URL]];
    }
}

// Opens the browser with the xing url
- (IBAction)xingButtonClicked:(id)sender
{
    NSLog(@"xing clicked %@", self.contact.xing_URL);
    if(self.contact.xing_URL.length != 0)
    {
        NSString *newXingUrl = [self.contact.xing_URL substringFromIndex:29];
        NSString *finalCallUrl = [NSString stringWithFormat:@"https://touch.xing.com/users/%@", newXingUrl];
        NSLog(@"%@", finalCallUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalCallUrl]];
    }
}

// Opens the browser with the twitter url
- (IBAction)twitetrButtonClicked:(id)sender
{
    NSLog(@"twitter clicked %@", self.contact.twitter_URL);
    if(self.contact.twitter_URL.length != 0)
    {
        NSURL *url = [NSURL URLWithString:self.contact.twitter_URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

// Opens the browser with the facebook url
- (IBAction)facebookButtonClicked:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *facebookURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",self.contact.facebook_ID]];
    if ([app canOpenURL:facebookURL])
    {
        [app openURL:facebookURL];
        return;
    }
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.contact.facebook_URL] ];
}

// Delegates calling a phone number to the phone app
- (IBAction)phoneButtonClicked:(id)sender
{
    NSLog(@"Phone calling...");
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *cellNameStr = [NSString stringWithFormat:@"%@", self.phoneButton.currentTitle];
    
    if ([cellNameStr isEqualToString:@"http://www.nimple.de"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cellNameStr]];
    } else if ([[device model] isEqualToString:@"iPhone"])
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
    if([MFMailComposeViewController canSendMail])
    {
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
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// Sets the contact of the cell
- (void)setContact:(NimpleContact *)contact;
{
    if (contact != _contact)
    {
        _contact = contact;
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.contact.surname, self.contact.prename]];
        [self.phoneButton setTitle:self.contact.phone forState:UIControlStateNormal];
        [self.emailButton setTitle:self.contact.email forState:UIControlStateNormal];
        if(contact.job.length != 0)
            [self.jobCompanyLabel setText:[NSString stringWithFormat:@"%@ (%@)", contact.company, contact.job]];
        else
            [self.jobCompanyLabel setText:[NSString stringWithFormat:@"%@", contact.company]];
    }
}

#pragma mark - Phone Book Icon Handling

// Handles the incoming button click
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // handling adding contact
    if(buttonIndex == 0) {
        NSLog(@"Adding contact to address book");
        [self addingNewContactToAddressBook];
    }
    
    // handle merging
    if(buttonIndex == 1) {
        NSLog(@"Begin merging contact to address book");
        [self mergingContactWithExisting];
    }
}

// Displays action sheet for adding contact
- (void) displayActionSheet
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to add the contact to your address book?"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles: nil];
    
    [self.actionSheet addButtonWithTitle:@"Add new contact"];
    // [self.actionSheet addButtonWithTitle:@"Merge with existing contact"];
    [self.actionSheet addButtonWithTitle:@"Cancel"];
    self.actionSheet.cancelButtonIndex = 1;
    [self.actionSheet showInView:self.superview.superview];
}

// Adding new contact
- (void) addingNewContactToAddressBook
{
    ABAddressBookRef addressBook = NULL;
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus())
    {
        case kABAuthorizationStatusAuthorized:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            
            [self addAccountWithFirstName:self.contact.prename LastName:self.contact.surname PhoneNumber:self.phoneButton.currentTitle MailAddress:self.emailButton.currentTitle JobTitle:self.contact.job CompanyName:self.contact.company inAddressBook:addressBook];
            
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
                    [Logging sendContactTransferredEvent];
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

// Merging contact with existing contact in address book
- (void) mergingContactWithExisting
{
    
}

// Handles clicking the phone book icon
- (IBAction)saveToAddressBookButtonClicked:(id)sender {
    [self displayActionSheet];
    return;
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
    
    // FirstNameProperty and LastNameProperty seem to be swapped!
    BOOL couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef)p_surname, &error);
    BOOL couldSetLastName = ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef)p_prename, &error);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef) p_phone, kABPersonPhoneMainLabel, nil);
    ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, nil);
    
    ABMutableMultiValueRef multiMail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiMail, (__bridge CFTypeRef) p_mail, kABHomeLabel, nil);
    ABRecordSetValue(result, kABPersonEmailProperty, multiMail, nil);
    
    ABRecordSetValue(result, kABPersonJobTitleProperty, (__bridge CFTypeRef)p_job, &error);
    ABRecordSetValue(result, kABPersonOrganizationProperty, (__bridge CFTypeRef)p_company, &error);
    
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
