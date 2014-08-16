//
//  NimpleCardViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCardViewController.h"
#import "BarCodeReaderController.h"

@interface NimpleCardViewController () {
    __weak IBOutlet UILabel *_tutorialAddLabel;
    __weak IBOutlet UILabel *_tutorialEditLabel;
    __weak IBOutlet UINavigationItem *_navigationLabel;
    NimpleCode *_code;
}
@end

@implementation NimpleCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code = [NimpleCode sharedCode];
    [self setupNotificationCenter];
    [self localizeViewAttributes];
    [self updateView];
}

- (void)setupNotificationCenter
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(handleChangedNimpleCode:) name:@"nimpleCodeChanged" object:nil];
}

-(void)localizeViewAttributes
{
    _tutorialAddLabel.text = NimpleLocalizedString(@"tutorial_add_text");
    _tutorialEditLabel.text = NimpleLocalizedString(@"tutorial_edit_text");
    _navigationLabel.title = NimpleLocalizedString(@"nimple_card_label");
}

- (void)updateView
{
    if (self.checkOwnProperties) {
        [self.nimpleCardView setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
        return;
    } else {
        [self.nimpleCardView setHidden:FALSE];
        [self.welcomeView setHidden:TRUE];
        
        // Fill the nimple card
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", _code.prename, _code.surname]];
        [self.jobLabel setText:_code.job];
        [self.companyLabel setText:_code.company];
        [self.phoneLabel setText:_code.cellPhone];
        [self.emailLabel setText:_code.email];
        
        // facebook
        NSString *facebook_URL = _code.facebookUrl;
        NSString *facebook_ID  = _code.facebookId;
        if ((facebook_URL.length != 0 || facebook_ID.length != 0) && [self.myNimpleCode boolForKey:@"facebook_switch"]) {
            [self.facebookIcon setAlpha:1.0];
        } else {
            [self.facebookIcon setAlpha:0.2];
        }
        
        if ((_code.twitterUrl.length != 0 || _code.twitterId.length != 0) && [self.myNimpleCode boolForKey:@"twitter_switch"]) {
            [self.twitterIcon setAlpha:1.0];
        } else {
            [self.twitterIcon setAlpha:0.2];
        }
        
        // xing
        NSString *xing_URL = _code.xing;
        if(xing_URL.length != 0 && [self.myNimpleCode boolForKey:@"xing_switch"])
            [self.xingIcon setAlpha:1.0];
        else
            [self.xingIcon setAlpha:0.2];
        
        // linkedin
        NSString *linkedin_URL = _code.linkedIn;
        if(linkedin_URL.length != 0 && [self.myNimpleCode boolForKey:@"linkedin_switch"])
            [self.linkedinIcon setAlpha:1.0];
        else
            [self.linkedinIcon setAlpha:0.2];
        
        if (!_code.cellPhoneSwitch) {
            [self.phoneLabel setAlpha:0.2];
            [self.phoneIcon setAlpha:0.2];
        } else {
            [self.phoneLabel setAlpha:1.0];
            [self.phoneIcon setAlpha:1.0];
        }
        
        if (!_code.emailSwitch) {
            [self.emailLabel setAlpha:0.2];
            [self.emailIcon setAlpha:0.2];
        } else {
            [self.emailLabel setAlpha:1.0];
            [self.emailIcon setAlpha:1.0];
        }

        if (![self.myNimpleCode boolForKey:@"company_switch"]) {
            [self.companyLabel setAlpha:0.2];
            [self.companyIcon setAlpha:0.2];
        } else {
            [self.companyLabel setAlpha:1.0];
            [self.companyIcon setAlpha:1.0];
        }

        if (![self.myNimpleCode boolForKey:@"job_switch"]) {
            [self.jobLabel setAlpha:0.2];
            [self.jobIcon setAlpha:0.2];
        } else {
            [self.jobLabel setAlpha:1.0];
            [self.jobIcon setAlpha:1.0];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.checkOwnProperties) {
        [self.nimpleCardView setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
    } else {
        [self.nimpleCardView setHidden:FALSE];
        [self.welcomeView setHidden:TRUE];
    }
}

- (BOOL)checkOwnProperties
{
    return (_code.prename.length == 0 && _code.surname.length == 0);
}

#pragma mark - Handles the nimpleCodeChanged notifaction

- (void)handleChangedNimpleCode:(NSNotification *)note
{
    NSLog(@"Received changed NimpleCode event");
    [self updateView];
}

#pragma mark - Edit segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        EditNimpleCodeTableViewController *editNimpleCodeController = segue.destinationViewController;
        editNimpleCodeController.delegate = self;
    }
}

#pragma mark - EditNimpleCodeTableControllerDelegate

- (void)editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
