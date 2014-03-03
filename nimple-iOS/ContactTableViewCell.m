//
//  ContactTableViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactTableViewCell.h"


@implementation ContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

// Fill the cell with name, phone nr. and mail address
- (void) fillCellName:(NSString*)p_name PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail
{
    self.nameLabel.text = p_name;
    [self.phoneButton setTitle:p_phone forState:UIControlStateNormal];
    [self.emailButton setTitle:p_mail  forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Delegates calling a phone number to the phone app
- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"Phone calling...");
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *cellNameStr = [NSString stringWithFormat:@"%@", self.phoneButton.currentTitle];
    
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:cellNameStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }
}

// Delegates the sending of an email to the mail app
- (IBAction)mailButtonClicked:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailContent = [[MFMailComposeViewController alloc] init];
        // Required to invoke mailComposeController when send
        mailContent.mailComposeDelegate = self.window.rootViewController;
        
        [mailContent setSubject:@""];
        [mailContent setToRecipients:[NSArray arrayWithObject:self.emailButton.currentTitle]];
        [mailContent setMessageBody:@"" isHTML:NO];
        
        [self.window.rootViewController presentViewController:mailContent animated:YES completion:nil];
    }
    else
        NSLog(@"error");
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
