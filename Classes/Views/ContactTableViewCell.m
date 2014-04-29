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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// Opens the browser with the linkedin url
- (IBAction)linkedinButtonClicked:(id)sender {
    NSLog(@"linkedin clicked");
    if(self.contact.linkedin_URL.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.contact.linkedin_URL]];
    }
}

// Opens the browser with the xing url
- (IBAction)xingButtonClicked:(id)sender {
    NSLog(@"xing clicked %@", self.contact.xing_URL);
    if(self.contact.xing_URL.length != 0) {
        NSString *newXingUrl = [self.contact.xing_URL substringFromIndex:29];
        NSString *finalCallUrl = [NSString stringWithFormat:@"https://touch.xing.com/users/%@", newXingUrl];
        NSLog(@"%@", finalCallUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalCallUrl]];
    }
}

// Opens the browser with the twitter url
- (IBAction)twitetrButtonClicked:(id)sender {
    NSLog(@"twitter clicked %@", self.contact.twitter_URL);
    if(self.contact.twitter_URL.length != 0) {
        NSURL *url = [NSURL URLWithString:self.contact.twitter_URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

// Opens the browser with the facebook url
- (IBAction)facebookButtonClicked:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *facebookURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",self.contact.facebook_ID]];
    if ([app canOpenURL:facebookURL]) {
        [app openURL:facebookURL];
        return;
    } else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.contact.facebook_URL]];
}

// Delegates calling a phone number to the phone app
- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"Phone calling...");
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *cellNameStr = [NSString stringWithFormat:@"%@", self.phoneButton.currentTitle];
    
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
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// Sets the contact of the cell
- (void)setContact:(NimpleContact *)contact; {
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

@end
