//
//  SettingsTableViewController.m
//  nimple-iOS
//
//  Created by Ben John on 23/03/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "MessageUI/MessageUI.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Will be executed when the view is loaded to memory
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tap Gesture Action
- (IBAction)faqClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/faq/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)termsClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/terms/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)disclaimerClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/disclaimer/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)impressumClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/imprint/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)visitFacebookClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/facebook/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)shareNimpleClicked:(id)sender {
    NSString *shareText = NimpleLocalizedString(@"settings.share-text");
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:shareText, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)feedbackClicked:(id)sender {
    NSString *recipient = NimpleLocalizedString(@"mail_first_contact_label");
    NSString *topic = NimpleLocalizedString(@"settings.feedback-header");
    NSString *text = NimpleLocalizedString(@"settings.feedback-text");
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        [mailVC setToRecipients:[NSArray arrayWithObjects:recipient, nil]];
        [mailVC setSubject:topic];
        [mailVC setMessageBody:text isHTML:NO];
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

#pragma mark - MailComposeViewDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
