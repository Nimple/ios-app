//
//  SettingsTableViewController.m
//  nimple-iOS
//
//  Created by Ben John on 23/03/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "MessageUI/MessageUI.h"

@interface SettingsTableViewController () {
    __weak IBOutlet UILabel *_faqLabel;
    __weak IBOutlet UILabel *_legalLabel;
    __weak IBOutlet UILabel *_disclaimerLabel;
    __weak IBOutlet UILabel *_imprintLabel;
    
    __weak IBOutlet UILabel *_facebookLabel;
    __weak IBOutlet UILabel *_shareLabel;
    __weak IBOutlet UILabel *_feedbackLabel;
    
    __weak IBOutlet UINavigationItem *_settingsLabel;
}
@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self localizeViewAttributes];
}

- (void)localizeViewAttributes
{
    _faqLabel.text = NimpleLocalizedString(@"settings_faq");
    _legalLabel.text = NimpleLocalizedString(@"settings_legal");
    _disclaimerLabel.text = NimpleLocalizedString(@"settings_disclaimer");
    _imprintLabel.text = NimpleLocalizedString(@"settings_imprint");
    
    _facebookLabel.text = NimpleLocalizedString(@"settings_facebook");
    _shareLabel.text = NimpleLocalizedString(@"settings_share");
    _feedbackLabel.text = NimpleLocalizedString(@"settings_feedback");
    
    _settingsLabel.title = NimpleLocalizedString(@"settings_title");
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
