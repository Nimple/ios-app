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
    self.scrollView.contentSize = CGSizeMake(320, 700);
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.frame = self.view.frame;
    
    // Do any additional setup after loading the view
    NSLog(@"Display contact view loaded");
    NSLog(@"With contact %@", self.nimpleContact.objectID);
    
    // Prepare output
    NSString* name = [NSString stringWithFormat:@"%@ %@", self.nimpleContact.prename, self.nimpleContact.surname];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy hh:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.nimpleContact.created];
    
    // Set labels
    [self.nameLabel setText:name];
    [self.phoneLabel setText:self.nimpleContact.phone];
    [self.emailLabel setText:self.nimpleContact.email];
    [self.companyLabel setText:self.nimpleContact.company];
    [self.jobLabel setText:self.nimpleContact.job];
    [self.timestampLabel setText:[NSString stringWithFormat:@"%@ Uhr", formattedDate]];
    [self.notesTextField setText:self.nimpleContact.note];
    [self.facebookURL setTitle:self.nimpleContact.facebook_URL forState:UIControlStateNormal];
    [self.twitterURL setTitle:self.nimpleContact.twitter_URL forState:UIControlStateNormal];
    [self.xingURL setTitle:self.nimpleContact.xing_URL forState:UIControlStateNormal];
    [self.linkedinURL setTitle:self.nimpleContact.linkedin_URL forState:UIControlStateNormal];
    
    // Initalize action sheets
    NSString *destructiveTitle = @"Löschen";
    NSString *cancelTitle = @"Abbrechen";
    self.actionSheetDelete = [[UIActionSheet alloc]
                              initWithTitle:@"Kontakt wirklich löschen?"
                              delegate:self
                              cancelButtonTitle:cancelTitle
                              destructiveButtonTitle:destructiveTitle
                              otherButtonTitles: nil];
    
    NSString *addNewTitle = @"Speichern";
    self.actionSheetAddressbook = [[UIActionSheet alloc]
                                   initWithTitle:@"Kontakt ins Adressbuch speichern"
                                   delegate:self
                                   cancelButtonTitle:cancelTitle
                                   destructiveButtonTitle:addNewTitle
                                   otherButtonTitles: nil
                                   ];
    
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

#pragma mark Callbacks

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

#pragma mark Button Handling

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
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *cellNameStr = [NSString stringWithFormat:@"%@", self.nimpleContact.phone];
    
    if ([cellNameStr isEqualToString:@"http://www.nimple.de"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cellNameStr]];
    } else if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:cellNameStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
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
        [mailContent setToRecipients:[NSArray arrayWithObject:self.nimpleContact.email]];
        [mailContent setMessageBody:@"" isHTML:NO];
        
        [self.navigationController popToViewController:mailContent animated:YES];
    } else
        NSLog(@"Error: Your Mail Account may not be set up.");
}

// Called when returning from mail app
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark AddressBook Handling

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person {
    NSLog(@"Invoked!");
}

-(void)addToAddressBook {
    ABUnknownPersonViewController *addPersonView = [[ABUnknownPersonViewController alloc] init];
    addPersonView.unknownPersonViewDelegate = self;
    addPersonView.displayedPerson = [self prepareNimpleContactForAddressBook];
    addPersonView.allowsAddingToAddressBook = YES;
    addPersonView.allowsActions = YES;
    [self.navigationController pushViewController:addPersonView animated:YES];
}

-(void)checkForAccess {
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self addToAddressBook];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                [self showAlertView];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addToAddressBook];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        [self showAlertView];
    }
}

-(void)showAlertView {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Kein Zugriff auf Kontakte"
                                                      message:@"Nimple hat keinen Zugriff auf deine Kontakte. Bitte aktiviere den Zugang zu deinen Kontakten unter iPhone Einstellungen > Datenschutz > Kontakte > Nimple."
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
    BOOL couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef) nimpleContact.surname, &error);
    BOOL couldSetLastName = ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef) nimpleContact.prename, &error);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef) nimpleContact.phone, kABPersonPhoneMainLabel, nil);
    ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, nil);
    
    ABMutableMultiValueRef multiMail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiMail, (__bridge CFTypeRef) nimpleContact.email, kABHomeLabel, nil);
    ABRecordSetValue(result, kABPersonEmailProperty, multiMail, nil);
    
    ABRecordSetValue(result, kABPersonJobTitleProperty, (__bridge CFTypeRef) nimpleContact.job, &error);
    ABRecordSetValue(result, kABPersonOrganizationProperty, (__bridge CFTypeRef) nimpleContact.company, &error);
    
    if (couldSetFirstName && couldSetLastName) {
        NSLog(@"Successfully set the first name and the last name of the person.");
    } else {
        NSLog(@"Failed.");
    }
    
    return result;
}


@end
