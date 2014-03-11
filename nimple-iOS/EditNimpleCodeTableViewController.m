//
//  EditNimpleCodeTableViewController.m
//  
//
//  Created by Guido Schmidt on 01.03.14.
//
//

#import "EditNimpleCodeTableViewController.h"

@interface EditNimpleCodeTableViewController ()

@end

@implementation EditNimpleCodeTableViewController

@synthesize ownNimpleCodeExists;
@synthesize myNimpleCode;
@synthesize cells;

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
    
    // Initalize user defaults if needed
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
    
    [self.myNimpleCode synchronize];
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:self.myNimpleCode forKey:@"nimpleCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self userInfo:dataDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.myNimpleCode synchronize];
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
    // 1. section (personal): 1. prename 2. surname 3. phone 4. mail
    if(section == 0)
        cellCount = 4;
    // 2. section (social)
    else if (section == 1)
        cellCount = 4;
    // 3. section (business): 1. job title 2. company
    else if(section == 2)
        cellCount = 2;
    
    return cellCount;
}

// Returns the cell for a given row index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myNimpleCode synchronize];
    static NSString *CellIdentifier = @"ContactInputCell";
    EditInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        // Section: personal
        case 0:
            if(indexPath.row == 0)
            {
                if([[self.myNimpleCode valueForKey:@"prename"] length] == 0)
                    [cell.inputField setPlaceholder:@"Dein Vorname"];
                else
                    [cell.inputField setText:[self.myNimpleCode valueForKey:@"prename"]];
            }
            if(indexPath.row == 1)
            {
                if([[self.myNimpleCode valueForKey:@"surname"] length] == 0)
                    [cell.inputField setPlaceholder:@"Dein Nachname"];
                else
                    [cell.inputField setText:[self.myNimpleCode valueForKey:@"surname"]];
            }
            if(indexPath.row == 2)
            {
                if([[self.myNimpleCode valueForKey:@"phone"] length] == 0)
                    [cell.inputField setPlaceholder:@"Deine Telefonnummer"];
                else
                    [cell.inputField setText:[self.myNimpleCode valueForKey:@"phone"]];
            }
            if(indexPath.row == 3)
            {
                if([[self.myNimpleCode valueForKey:@"email"] length] == 0)
                    [cell.inputField setPlaceholder:@"Deine E-Mail Adresse"];
                else
                    [cell.inputField setText:[self.myNimpleCode valueForKey:@"email"]];
                
            }
            break;
        // Section: social
        case 1:
            if(indexPath.row == 0)
            {
                static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
                ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
                [cell.socialNetworkIcon setImage:[UIImage imageNamed:@"ic_round_facebook"]];
                [cell.socialNetworkIcon setAlpha:0.3];
                [cell.socialNetworkIcon setContentMode:UIViewContentModeScaleAspectFill];
                [cell.connectStatusButton setTitle:@"Mit facebook verbinden" forState:UIControlStateNormal];
                cell.fbloginView = [[FBLoginView alloc]initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
                
            }
            if(indexPath.row == 1)
            {
                static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
                ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
                cell.socialNetworkIcon.contentMode = UIViewContentModeScaleAspectFill;
                [cell.socialNetworkIcon setImage:[UIImage imageNamed:@"ic_round_twitter"]];
                [cell.socialNetworkIcon setAlpha:0.3];
                [cell.connectStatusButton setTitle:@"Mit twitter verbinden" forState:UIControlStateNormal];
            }
            if(indexPath.row == 2)
            {
                static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
                ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
                [cell.socialNetworkIcon setImage:[UIImage imageNamed:@"ic_round_xing"]];
                [cell.socialNetworkIcon setAlpha:0.3];
                [cell.socialNetworkIcon setContentMode:UIViewContentModeScaleAspectFill];
                [cell.connectStatusButton setTitle:@"Mit xing verbinden" forState:UIControlStateNormal];
            }
            if(indexPath.row == 3)
            {
                static NSString *CellIdentifierSocial = @"ConnectSocialProfileCell";
                ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial forIndexPath:indexPath];
                [cell.socialNetworkIcon setImage:[UIImage imageNamed:@"ic_round_linkedin"]];
                [cell.socialNetworkIcon setAlpha:0.3];
                [cell.socialNetworkIcon setContentMode:UIViewContentModeScaleAspectFill];
                [cell.connectStatusButton setTitle:@"Mit linkedin verbinden" forState:UIControlStateNormal];
            }
            break;
        // Section: business
        case 2:
            if(indexPath.row == 0)
            {
                if([[self.myNimpleCode valueForKey:@"job"] length] == 0)
                    [cell.inputField setPlaceholder:@"Deine Job Bezeichnung"];
                else
                    [cell.inputField setText:[self.myNimpleCode valueForKey:@"job"]];
            }
            if(indexPath.row == 1)
            {
                if([[self.myNimpleCode valueForKey:@"company"] length] == 0)
                    [cell.inputField setPlaceholder:@"Deine Firma"];
                else
                    [cell.inputField setText:[self.myNimpleCode valueForKey:@"company"]];
            }
            break;
    }
    
    [cell setIndex: indexPath.item];
    [cell setSection: indexPath.section];
    
    return cell;
}

// Returns the title for a given section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionName = @"";
    
    if(section == 0)
        sectionName = @"Personal";
    else if(section == 1)
        sectionName = @"Social";
    else if(section == 2)
        sectionName = @"Business";
    
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
    [self.myNimpleCode synchronize];
    // Notification that the nimple code changed
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:self.myNimpleCode forKey:@"nimpleCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self userInfo:dataDict];
    
    [self.delegate editNimpleCodeTableViewControllerDidSave:self];
}

@end
