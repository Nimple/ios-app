//
//  EditNimpleCodeTableViewController.m
//
//
//  Created by Guido Schmidt on 01.03.14.
//
//

#import "EditNimpleCodeTableViewController.h"
#import "NimpleAppDelegate.h"
#import "Logging.h"

@interface EditNimpleCodeTableViewController ()

@end

@implementation EditNimpleCodeTableViewController

@synthesize myNimpleCode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.myNimpleCode synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myNimpleCode = [NSUserDefaults standardUserDefaults];
    NSString* surname = [self.myNimpleCode valueForKey:@"surname"];
    if(surname.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"surname"];
    }
    NSString* prename = [self.myNimpleCode valueForKey:@"prename"];
    if(prename.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"prename"];
    }
    NSString* phone = [self.myNimpleCode valueForKey:@"phone"];
    if(phone.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"phone"];
    }
    NSString* email = [self.myNimpleCode valueForKey:@"email"];
    if(email.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"email"];
    }
    NSString* job = [self.myNimpleCode valueForKey:@"job"];
    if(job.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"job"];
    }
    NSString* company = [self.myNimpleCode valueForKey:@"company"];
    if(company.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"company"];
    }
    NSString* facebook_URL = [self.myNimpleCode valueForKey:@"facebook_URL"];
    if(facebook_URL.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"facebook_URL"];
    }
    NSString* facebook_ID = [self.myNimpleCode valueForKey:@"facebook_ID"];
    if(facebook_ID.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"facebook_ID"];
    }
    NSString* twitter_URL = [self.myNimpleCode valueForKey:@"twitter_URL"];
    if(twitter_URL.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"twitter_URL"];
    }
    NSString* twitter_ID = [self.myNimpleCode valueForKey:@"twitter_ID"];
    if(twitter_ID.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"twitter_ID"];
    }
    NSString* xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
    if(xing_URL.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"xing_URL"];
    }
    NSString* linkedin_URL = [self.myNimpleCode valueForKey:@"linkedin_URL"];
    if(linkedin_URL.length == 0)
    {
        [self.myNimpleCode setValue:@"" forKey:@"linkedin_URL"];
    }
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:self.myNimpleCode forKey:@"nimpleCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self userInfo:dataDict];
    [self.myNimpleCode synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
}

#pragma mark - Table view data source

// Returns the number of sections used in this table view
// 1. personal section
// 2. social section
// 3. business section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// Returns the number of cells in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger cellCount = 0;
    
    // 1. section (personal): 1. prename 2. surname 3. phone 4. mail
    if(section == 0)
        cellCount = 4;
    // 2. section (business): 1. job title 2. company
    else if (section == 1)
        cellCount = 2;
    // 3. section (social): 1. facebook 2. twitter 3. xing 4. linkedin
    else if(section == 2)
        cellCount = 4;
    
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2)
        return 60.0;
    else
        return 45.0;
}


// Returns the cell for a given row index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditInputViewCell";
    EditInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.inputField setText:@""];
    cell.inputField.delegate = cell;
    
    [cell setIndex: indexPath.item];
    [cell setSection: indexPath.section];
    [cell.inputField setTintColor:[UIColor colorWithHue:38 saturation:100 brightness:74 alpha:1.0]];
    
    // Configure the cell...
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            // No propertySwitch, prename is required field
            [cell.propertySwitch setHidden:TRUE];
            if([[self.myNimpleCode valueForKey:@"prename"] length] == 0)
                [cell.inputField setPlaceholder:@"Dein Vorname"];
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"prename"]];
        }
        if(indexPath.row == 1)
        {
            // No propertySwitch, surname is required field
            [cell.propertySwitch setHidden:TRUE];
            if([[self.myNimpleCode valueForKey:@"surname"] length] == 0)
                [cell.inputField setPlaceholder:@"Dein Nachname"];
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"surname"]];
        }
        if(indexPath.row == 2)
        {
            BOOL phone_switch = [self.myNimpleCode boolForKey:@"phone_switch"];
            [cell.propertySwitch setOn:phone_switch];
            
            [cell.inputField setKeyboardType:UIKeyboardTypePhonePad];
            if([[self.myNimpleCode valueForKey:@"phone"] length] == 0) {
                [cell.inputField setPlaceholder:@"Deine Telefonnummer"];
                [cell.propertySwitch setAlpha:0.0];
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
            if([[self.myNimpleCode valueForKey:@"email"] length] == 0) {
                [cell.inputField setPlaceholder:@"Deine E-Mail Adresse"];
                [cell.propertySwitch setAlpha:0.0];
                [self.myNimpleCode setBool:TRUE forKey:@"email_switch"];
            }
            else
                [cell.inputField setText:[self.myNimpleCode valueForKey:@"email"]];
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
                [cell.inputField setPlaceholder:@"Dein Unternehmen/Uni/Schule"];
                [cell.propertySwitch setAlpha:0.0];
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
                [cell.inputField setPlaceholder:@"Dein Job/Position"];
                [cell.propertySwitch setAlpha:0.0];
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
                [cell.connectStatusButton setTitle:@"mit facebook verbinden" forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
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
                [cell.connectStatusButton setTitle:@"mit twitter verbinden" forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
            }
        }
        // xing
        if(indexPath.row == 2)
        {
            static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
            ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
            
            BOOL xing_switch = [self.myNimpleCode boolForKey:@"xing_switch"];
            [cell.propertySwitch setOn:xing_switch];
            
            [cell setSection:2];
            [cell setIndex:2];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_xing"] forState:UIControlStateNormal];
            [cell setNetworkManager: [NimpleAppDelegate sharedDelegate].networkManager];
            
            NSString* xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
            if(xing_URL.length == 0)
            {
                [self.myNimpleCode setBool:TRUE forKey:@"xing_switch"];
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:@"mit XING verbinden" forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
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
            [cell.connectStatusButton setTitle:@"mit LinkedIn verbinden" forState:UIControlStateNormal];
            
            NSString* linkedin_URL = [self.myNimpleCode valueForKey:@"linkedin_URL"];
            if(linkedin_URL.length == 0)
            {
                [self.myNimpleCode setBool:TRUE forKey:@"linkedin_switch"];
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:@"mit LinkedIn verbinden" forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
            }
            else
            {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
            }
        }
    }
    
    return cell;
}

// Returns the title for a given section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionName = @"";
    
    if(section == 0)
        sectionName = @"Persöhnlich";
    else if(section == 1)
        sectionName = @"Geschäftlich";
    else if(section == 2)
        sectionName = @"Soziale Netzwerke";
    
    return sectionName;
}

//
- (IBAction)cancel:(id)sender
{
    [self.delegate editNimpleCodeTableViewControllerDidCancel:self];
}

//
- (IBAction)done:(id)sender
{
    if([[self.myNimpleCode valueForKey:@"prename"] length] == 0 || [[self.myNimpleCode valueForKey:@"surname"] length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Vor- & Nachnahme sind Pflichtfelder"
                                  message:@"Bitte fülle deinen Vor- & Nachnamen aus!"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    } else {
        [self.myNimpleCode synchronize];
        
        // Log Mixpanel
        [Logging sendNimpleCodeChangedEvent:[self.myNimpleCode dictionaryRepresentation]];
        
        // Notification that the nimple code changed
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self];
        [self.delegate editNimpleCodeTableViewControllerDidSave:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
