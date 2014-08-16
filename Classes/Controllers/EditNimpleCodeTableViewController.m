//
//  EditNimpleCodeTableViewController.m
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditNimpleCodeTableViewController.h"
#import "NimpleAppDelegate.h"
#import "Logging.h"

@interface EditNimpleCodeTableViewController () {
    __weak IBOutlet UINavigationItem *_editNimpleCode;
    __weak IBOutlet UILabel *_descriptionLabel;
    NimpleCode *_code;
}

@end

@implementation EditNimpleCodeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code = [NimpleCode sharedCode];
    [self localizeViewAttributes];
    [self updateView];
}

- (void)localizeViewAttributes
{
    _editNimpleCode.title = NimpleLocalizedString(@"edit_nimple_code_title");
    _descriptionLabel.text = NimpleLocalizedString(@"nimple_code_description");
}

- (void)updateView
{
   // NSDictionary *dataDict = [NSDictionary dictionaryWithObject:self.myNimpleCode forKey:@"nimpleCode"];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self userInfo:dataDict];
}

#pragma mark - Table view data source

// Returns the number of sections used in this table view
// 1. personal section
// 2. social section
// 3. business section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// Returns the number of cells in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount = 0;
    
    // 1. section (personal): 1. prename 2. surname 3. phone 4. mail 5. address 6. website
    if(section == 0)
        cellCount = 6;
    // 2. section (business): 1. job title 2. company
    else if (section == 1)
        cellCount = 2;
    // 3. section (social): 1. facebook 2. twitter 3. xing 4. linkedin
    else if(section == 2)
        cellCount = 4;
    
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
        return 60.0;
    else if (indexPath.section == 0 && indexPath.row == 4)
        return 86.0;
    else
        return 45.0;
}

// Returns the cell for a given row index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditInputViewCell"];
    cell.inputField.text = @"";
    cell.inputField.tintColor = [UIColor colorWithHue:38 saturation:100 brightness:74 alpha:1.0];
    cell.inputField.delegate = cell;
    cell.index = indexPath.item;
    cell.section = indexPath.section;
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // No propertySwitch, prename is required field
            [cell.propertySwitch setHidden:TRUE];
            if (_code.prename.length == 0)
                cell.inputField.placeholder = NimpleLocalizedString(@"firstname_label");
            else
                cell.inputField.text = _code.prename;
        }
        if (indexPath.row == 1) {
            // No propertySwitch, surname is required field
            [cell.propertySwitch setHidden:TRUE];
            if(_code.surname.length == 0)
                [cell.inputField setPlaceholder:NimpleLocalizedString(@"lastname_label")];
            else
                [cell.inputField setText:_code.surname];
        }
        if (indexPath.row == 2) {
            BOOL phone_switch = [self.myNimpleCode boolForKey:@"phone_switch"];
            [cell.propertySwitch setOn:phone_switch];
            
            [cell.inputField setKeyboardType:UIKeyboardTypePhonePad];
            if([_code.cellPhone length] == 0) {
                [cell.inputField setPlaceholder:NimpleLocalizedString(@"phonenumber_label")];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
                [self.myNimpleCode setBool:TRUE forKey:@"phone_switch"];
            }
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"phone"]];
        }
        if(indexPath.row == 3)
        {
            BOOL email_switch = [self.myNimpleCode boolForKey:@"email_switch"];
            [cell.propertySwitch setOn:email_switch];
            
            [cell.inputField setKeyboardType:UIKeyboardTypeEmailAddress];
            [cell.inputField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [cell.inputField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            if([[self.myNimpleCode valueForKey:@"email"] length] == 0) {
                [cell.inputField setPlaceholder:NimpleLocalizedString(@"mail_label")];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
                [self.myNimpleCode setBool:TRUE forKey:@"email_switch"];
            }
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"email"]];
        }
        
        if(indexPath.row == 4) {
            EditAddressInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressInputViewCell"];
            [cell configureCell];
            return cell;
        }

        if(indexPath.row == 5) {
            BOOL websiteSwitch = [self.myNimpleCode boolForKey:@"company_switch"];
            [cell.propertySwitch setOn:websiteSwitch];
            
            if ([[self.myNimpleCode valueForKey:@"website"] length] == 0) {
                [cell.inputField setPlaceholder:NimpleLocalizedString(@"website_label")];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
                [self.myNimpleCode setBool:TRUE forKey:@"website_switch"];
            } else {
                cell.inputField.text = [self.myNimpleCode valueForKey:@"website"];
            }
        }
    }
    // Section: business
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            BOOL company_switch = [self.myNimpleCode boolForKey:@"company_switch"];
            [cell.propertySwitch setOn:company_switch];
            
            if([[self.myNimpleCode valueForKey:@"company"] length] == 0) {
                [cell.inputField setPlaceholder:NimpleLocalizedString(@"company_label")];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
                [self.myNimpleCode setBool:TRUE forKey:@"company_switch"];
            }
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"company"]];
        }
        if(indexPath.row == 1)
        {
            BOOL job_switch = [self.myNimpleCode boolForKey:@"job_switch"];
            [cell.propertySwitch setOn:job_switch];
            
            if([[self.myNimpleCode valueForKey:@"job"] length] == 0) {
                [cell.inputField setPlaceholder:NimpleLocalizedString(@"job_label")];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
                [self.myNimpleCode setBool:TRUE forKey:@"job_switch"];
            }
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"job"]];
        }
    }
    // Section: social
    else if(indexPath.section == 2)
    {
        // facebook
        if(indexPath.row == 0)
        {
            
            static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
            ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
            [cell setSection:2];
            [cell setIndex:0];
            
            BOOL facebook_switch = [self.myNimpleCode boolForKey:@"facebook_switch"];
            [cell.propertySwitch setOn:facebook_switch];
            
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_facebook"]forState:UIControlStateNormal];
            cell.fbLoginView = [[FBLoginView alloc]initWithReadPermissions:@[@"basic_info", @"email"]];
            cell.fbLoginView.delegate = cell;
            
            NSString* facebook_ID  = [self.myNimpleCode valueForKey:@"facebook_ID"];
            NSString* facebook_URL = [self.myNimpleCode valueForKey:@"facebook_URL"];
            
            if(facebook_ID.length == 0 || facebook_URL.length == 0)
            {
                [self.myNimpleCode setBool:TRUE forKey:@"facebook_switch"];
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"facebook_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
        // twitter
        if(indexPath.row == 1)
        {
            static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
            ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
            
            BOOL twitter_switch = [self.myNimpleCode boolForKey:@"twitter_switch"];
            [cell.propertySwitch setOn:twitter_switch];
            
            [cell setSection:2];
            [cell setIndex:1];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_twitter"] forState:UIControlStateNormal];
            
            NSString* twitter_ID  = [self.myNimpleCode valueForKey:@"twitter_ID"];
            NSString* twitter_URL = [self.myNimpleCode valueForKey:@"twitter_URL"];
            if(twitter_ID.length == 0 || twitter_URL.length == 0)
            {
                [self.myNimpleCode setBool:TRUE forKey:@"twitter_switch"];
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"twitter_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
        // xing
        if(indexPath.row == 2)
        {
            static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
            ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
            
            BOOL xing_switch = [self.myNimpleCode boolForKey:@"xing_switch"];
            [cell.propertySwitch setOn:xing_switch];
            
            NimpleAppDelegate *appDelegate = (NimpleAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [cell setSection:2];
            [cell setIndex:2];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_xing"] forState:UIControlStateNormal];
            [cell setNetworkManager: appDelegate.networkManager];
            
            NSString* xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
            if(xing_URL.length == 0)
            {
                [self.myNimpleCode setBool:TRUE forKey:@"xing_switch"];
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"xing_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
        // linkedin
        if(indexPath.row == 3)
        {
            static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
            ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
            
            BOOL linkedin_switch = [self.myNimpleCode boolForKey:@"linkedin_switch"];
            [cell.propertySwitch setOn:linkedin_switch];
            
            [cell setSection:2];
            [cell setIndex:3];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_linkedin"] forState:UIControlStateNormal];
            
            NSString* linkedin_URL = [self.myNimpleCode valueForKey:@"linkedin_URL"];
            if(linkedin_URL.length == 0)
            {
                [self.myNimpleCode setBool:TRUE forKey:@"linkedin_switch"];
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"linkedin_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:TRUE];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    if (section == 0) {
        sectionName = NimpleLocalizedString(@"personal_label");
    } else if (section == 1) {
        sectionName = NimpleLocalizedString(@"business_label");
    } else if (section == 2) {
        sectionName = NimpleLocalizedString(@"social_label");
    }
    return sectionName;
}

#pragma mark - Callbacks

- (IBAction)done:(id)sender
{
    if (_code.prename.length == 0 || _code.surname.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NimpleLocalizedString(@"error_names") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    } else {
        [[Logging sharedLogging] sendNimpleCodeChangedEvent];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self];
        [self.delegate editNimpleCodeTableViewControllerDidSave:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
