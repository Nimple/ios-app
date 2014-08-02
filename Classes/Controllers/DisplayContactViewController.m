//
//  DisplayContactViewController.m
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "DisplayContactViewController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/ABUnknownPersonViewController.h"
#import "Logging.h"

@interface DisplayContactViewController ()

@end

@implementation DisplayContactViewController

@synthesize nimpleContact;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup scroll view
    [self.scrollView setDelegate:self];
    [self.scrollView setScrollEnabled:TRUE];
    self.scrollView.contentSize = CGSizeMake(320, 753);
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.frame = self.view.frame;
    
    // Do any additional setup after loading the view
    NSLog(@"Display contact view loaded");
    NSLog(@"With contact %@", self.nimpleContact.objectID);
    
    // Prepare output
    NSString* name = [NSString stringWithFormat:@"%@ %@", self.nimpleContact.prename, self.nimpleContact.surname];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedStringFromTable(@"date_format", @"Localizable", nil)];
    NSString *formattedDate = [dateFormatter stringFromDate:self.nimpleContact.created];
    
    // Set labels
    [self.nameLabel setText:name];
    [self.phoneLabel setText:self.nimpleContact.phone];
    [self.emailLabel setText:self.nimpleContact.email];
    [self.companyLabel setText:self.nimpleContact.company];
    [self.jobLabel setText:self.nimpleContact.job];
    
    NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"de"]) {
        [self.timestampLabel setText:[NSString stringWithFormat:@"%@ Uhr", formattedDate]];
    } else {
        [self.timestampLabel setText:[NSString stringWithFormat:@"%@", formattedDate]];
    }
    [self.notesTextField setText:self.nimpleContact.note];
    
    // Social icons
    // facebook
    NSString *facebook_URL = self.nimpleContact.facebook_URL;
    NSString *facebook_ID  = self.nimpleContact.facebook_ID;
    if((facebook_URL.length != 0 || facebook_ID.length != 0)) {
        [self.facebookIcon setAlpha:1.0];
        [self.facebookURL setTitle:facebook_URL forState:UIControlStateNormal];
    } else {
        [self.facebookIcon setAlpha:0.2];
        [self.facebookURL setTitle:NSLocalizedStringFromTable(@"detail_facebook_label", @"Localizable", nil) forState:UIControlStateNormal];
    }
    
    // twitter
    NSString *twitter_URL = self.nimpleContact.twitter_URL;
    NSString *twitter_ID  = self.nimpleContact.twitter_ID;
    if((twitter_URL.length != 0 || twitter_ID.length != 0)) {
        [self.twitterIcon setAlpha:1.0];
        [self.twitterURL setTitle:twitter_URL forState:UIControlStateNormal];
    } else {
        [self.twitterIcon setAlpha:0.2];
        [self.twitterURL setTitle:NSLocalizedStringFromTable(@"detail_twitter_label", @"Localizable", nil) forState:UIControlStateNormal];
    }
    
    // xing
    NSString *xing_URL = self.nimpleContact.xing_URL;
    if(xing_URL.length != 0) {
        [self.xingIcon setAlpha:1.0];
        [self.xingURL setTitle:xing_URL forState:UIControlStateNormal];
    } else {
        [self.xingIcon setAlpha:0.2];
        [self.xingURL setTitle:NSLocalizedStringFromTable(@"detail_xing_label", @"Localizable", nil) forState:UIControlStateNormal];
    }
    
    // linkedin
    NSString *linkedin_URL = self.nimpleContact.linkedin_URL;
    if(linkedin_URL.length != 0) {
        [self.linkedinIcon setAlpha:1.0];
        [self.linkedinURL setTitle:linkedin_URL forState:UIControlStateNormal];
    } else {
        [self.linkedinIcon setAlpha:0.2];
        [self.linkedinURL setTitle:NSLocalizedStringFromTable(@"detail_linkedin_label", @"Localizable", nil) forState:UIControlStateNormal];
    }
    
    // Initalize action sheets
    self.actionSheetDelete = [[UIActionSheet alloc]
                              initWithTitle:NSLocalizedStringFromTable(@"msg_box_delete_contact_title", @"Localizable", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedStringFromTable(@"msg_box_delete_contact_activity2", @"Localizable", nil)
                              destructiveButtonTitle:NSLocalizedStringFromTable(@"msg_box_delete_contact_activity1", @"Localizable", nil)
                              otherButtonTitles: nil];
    
    self.actionSheetAddressbook = [[UIActionSheet alloc]
                                   initWithTitle:NSLocalizedStringFromTable(@"msg_box_save_contact_title", @"Localizable", nil)
                                   delegate:self
                                   cancelButtonTitle:NSLocalizedStringFromTable(@"msg_box_save_contact_activity2", @"Localizable", nil)
                                   destructiveButtonTitle:NSLocalizedStringFromTable(@"msg_box_save_contact_activity1", @"Localizable", nil)
                                   otherButtonTitles: nil];
    
    // Initialize on tap recognizer for mail and phone labels
    UITapGestureRecognizer *phoneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneButtonClicked:)];
    phoneTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.phoneLabel addGestureRecognizer:phoneTapGestureRecognizer];
    self.phoneLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *mailTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mailButtonClicked:)];
    mailTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.emailLabel addGestureRecognizer:mailTapGestureRecognizer];
    self.emailLabel.userInteractionEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"Save should be invoked!");
    [self saved];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Callbacks

- (void) saved {
    self.nimpleContact.note = self.notesTextField.text;
    [self.delegate displayContactViewControllerDidSave:self];
}

- (IBAction)saveClicked:(id)sender {
    [self saved];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveToAddressBookButtonClicked:(id)sender {
    NSLog(@"Contact will be saved to address book");
    [self.actionSheetAddressbook showInView:self.view];
}

- (IBAction)deleteContactButtonClicked:(id)sender {
    NSLog(@"Contact will be deleted");
    [self.actionSheetDelete showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == self.actionSheetDelete && buttonIndex == 0) {
        [self.delegate displayContactViewControllerDidDelete:self];
    }
    if(actionSheet == self.actionSheetAddressbook && buttonIndex == 0) {
        [self checkForAccess];
    }
}

#pragma mark - Button Handling
// Opens the browser with the linkedin url
- (IBAction)linkedinButtonClicked:(id)sender {
    NSLog(@"linkedin clicked");
    if(self.nimpleContact.linkedin_URL.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.linkedin_URL]];
    }
}

// Opens the browser with the xing url
- (IBAction)xingButtonClicked:(id)sender {
    NSLog(@"xing clicked %@", self.nimpleContact.xing_URL);
    if(self.nimpleContact.xing_URL.length != 0) {
        NSString *newXingUrl = [self.nimpleContact.xing_URL substringFromIndex:29];
        NSString *finalCallUrl = [NSString stringWithFormat:@"https://touch.xing.com/users/%@", newXingUrl];
        NSLog(@"%@", finalCallUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalCallUrl]];
    }
}

// Opens the browser with the twitter url
- (IBAction)twitterButtonClicked:(id)sender {
    NSLog(@"twitter clicked %@", self.nimpleContact.twitter_URL);
    if(self.nimpleContact.twitter_URL.length != 0) {
        NSURL *url = [NSURL URLWithString:self.nimpleContact.twitter_URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

// Opens the browser with the facebook url
- (IBAction)facebookButtonClicked:(id)sender {
    if(self.nimpleContact.facebook_URL.length == 0) {
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *facebookURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",self.nimpleContact.facebook_ID]];
    if ([app canOpenURL:facebookURL]) {
        [app openURL:facebookURL];
        return;
    } else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.facebook_URL]];
}

// Delegates calling a phone number to the phone app
- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"Phone calling...");
    if(self.nimpleContact.phone.length == 0) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([self.nimpleContact.phone isEqualToString:@"http://www.nimple.de"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.phone]];
    } else if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.nimpleContact.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Error: Phone Calls does not work on an iPad" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warning show];
    }
}

// Delegates the sending of an email to the mail app
- (IBAction)mailButtonClicked:(id)sender {
    // From within your active view controller
    if(self.nimpleContact.email.length == 0) {
        return;
    }
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailContent = [[MFMailComposeViewController alloc] init];
        // Required to invoke mailComposeController when send
        mailContent.mailComposeDelegate = self;
        
        [mailContent setSubject:@""];
        [mailContent setToRecipients:[NSArray arrayWithObject:self.nimpleContact.email]];
        [mailContent setMessageBody:@"" isHTML:NO];
        
        [self.navigationController presentViewController:mailContent animated:YES completion:nil];
    } else
        NSLog(@"Error: Your Mail Account may not be set up.");
}

// Called when returning from mail app
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AddressBook Handling
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person {
    [unknownCardViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)addToAddressBook {
    ABUnknownPersonViewController *addPersonView = [[ABUnknownPersonViewController alloc] init];
    addPersonView.unknownPersonViewDelegate = self;
    addPersonView.displayedPerson = [self prepareNimpleContactForAddressBook];
    addPersonView.allowsAddingToAddressBook = YES;
    addPersonView.allowsActions = YES;
    [Logging sendContactTransferredEvent];
    [self.navigationController pushViewController:addPersonView animated:YES];
}

-(void)checkForAccess {
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // First time access has been granted, add the contact
                    [self addToAddressBook];
                } else {
                    // User denied access
                    // Display an alert telling user the contact could not be added
                    [self showAlertView];
                }
            });
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addToAddressBook];
    } else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        [self showAlertView];
    }
}

-(void)showAlertView {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"contacts_no_access_title", @"Localizable", nil)
                                                      message:NSLocalizedStringFromTable(@"contacts_no_access_text", @"Localizable", nil)
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

// Saves a contact to the address book of the phone
- (ABRecordRef)prepareNimpleContactForAddressBook {
    ABRecordRef result = NULL;
    CFErrorRef error   = NULL;
    
    result = ABPersonCreate();
    if (result == NULL) {
        NSLog(@"Failed to create a new person.");
        return NULL;
    }
    
    // FirstNameProperty and LastNameProperty seem to be swapped!
    ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef) nimpleContact.prename, &error);
    ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef) nimpleContact.surname, &error);
    
    if (![nimpleContact.phone isEqualToString:@"http://www.nimple.de"]) {
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef) nimpleContact.phone, kABPersonPhoneMainLabel, nil);
        ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, nil);
    }
    
    ABMutableMultiValueRef multiMail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiMail, (__bridge CFTypeRef) nimpleContact.email, kABHomeLabel, nil);
    ABRecordSetValue(result, kABPersonEmailProperty, multiMail, nil);
    
    ABRecordSetValue(result, kABPersonJobTitleProperty, (__bridge CFTypeRef) nimpleContact.job, &error);
    ABRecordSetValue(result, kABPersonOrganizationProperty, (__bridge CFTypeRef) nimpleContact.company, &error);
    
    return result;
}


@end
