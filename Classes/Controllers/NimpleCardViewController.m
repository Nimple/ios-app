//
//  NimpleCardViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCardViewController.h"

@interface NimpleCardViewController () {
    __weak IBOutlet UILabel *_tutorialAddLabel;
    __weak IBOutlet UILabel *_tutorialEditLabel;
    
    __weak IBOutlet UINavigationItem *_navigationLabel;
    
    __weak IBOutlet UILabel *_websiteLabel;
    __weak IBOutlet UIImageView *_websiteIcon;
    
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UIImageView *_addressIcon;
    
    NimpleCode *_code;
}

@end

@implementation NimpleCardViewController

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
        
        [self fillNimpleCard];
    }
}

- (BOOL)checkOwnProperties
{
    return (_code.prename.length == 0 && _code.surname.length == 0);
}

- (void)fillNimpleCard
{
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", _code.prename, _code.surname]];
    [self.jobLabel setText:_code.job];
    [self.companyLabel setText:_code.company];
    [self.phoneLabel setText:_code.cellPhone];
    [self.emailLabel setText:_code.email];
    _websiteLabel.text = _code.website;
    
    if (_code.hasAddress) {
        if (_code.addressStreet > 0) {
            NSString *address = [[NSString alloc] initWithFormat:@"%@\n%@ %@", _code.addressStreet, _code.addressPostal, _code.addressCity];
            _addressLabel.text = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        } else {
            NSString *address = [[NSString alloc] initWithFormat:@"%@ %@", _code.addressPostal, _code.addressCity];
            _addressLabel.text = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
    } else {
        _addressLabel.text = @"";
    }
    
    if ((_code.facebookUrl.length != 0 || _code.facebookId.length != 0) && _code.facebookSwitch) {
        [self.facebookIcon setAlpha:1.0];
    } else {
        [self.facebookIcon setAlpha:0.2];
    }
    
    if ((_code.twitterUrl.length != 0 || _code.twitterId.length != 0) && _code.twitterSwitch) {
        [self.twitterIcon setAlpha:1.0];
    } else {
        [self.twitterIcon setAlpha:0.2];
    }
    
    if (_code.xing.length != 0 && _code.xingSwitch) {
        [self.xingIcon setAlpha:1.0];
    } else {
        [self.xingIcon setAlpha:0.2];
    }
    
    if (_code.linkedIn.length != 0 && _code.linkedInSwitch) {
        [self.linkedinIcon setAlpha:1.0];
    } else {
        [self.linkedinIcon setAlpha:0.2];
    }
    
    if (!_code.addressSwitch) {
        [_addressLabel setAlpha:0.2];
        [_addressIcon setAlpha:0.2];
    } else {
        [_addressLabel setAlpha:1.0];
        [_addressIcon setAlpha:1.0];
    }
    
    if (!_code.websiteSwitch) {
        [_websiteLabel setAlpha:0.2];
        [_websiteIcon setAlpha:0.2];
    } else {
        [_websiteLabel setAlpha:1.0];
        [_websiteIcon setAlpha:1.0];
    }
    
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
    
    if (!_code.companySwitch) {
        [self.companyLabel setAlpha:0.2];
        [self.companyIcon setAlpha:0.2];
    } else {
        [self.companyLabel setAlpha:1.0];
        [self.companyIcon setAlpha:1.0];
    }
    
    NSLog(@"companySwitch %d", _code.companySwitch);
    NSLog(@"jobSwitch %d", _code.jobSwitch);
    
    if (!_code.jobSwitch) {
        [self.jobLabel setAlpha:0.2];
        [self.jobIcon setAlpha:0.2];
    } else {
        [self.jobLabel setAlpha:1.0];
        [self.jobIcon setAlpha:1.0];
    }
}

#pragma mark - Handles the nimpleCodeChanged notifaction

- (void)handleChangedNimpleCode:(NSNotification *)note
{
    NSLog(@"Nimple code changed received in NimpleCardViewController");
    [self updateView];
}

@end
