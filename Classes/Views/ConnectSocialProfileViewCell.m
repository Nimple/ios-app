//
//  ConnectSocialProfileViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#define XING_CONSUMER_KEY    @"247e95c9f304f6c5aaff"
#define XING_CONSUMER_SECRET @"cebe8869323e6d227257361eeabf05046c243721"

#import "ConnectSocialProfileViewCell.h"
#import "NimpleAppDelegate.h"

@implementation ConnectSocialProfileViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) animatePropertySwitchVisibilityTo:(NSInteger)value {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [self.propertySwitch setAlpha:value];
    
    [UIView commitAnimations];
}

- (IBAction) propertySwitched:(id)sender
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    if(self.section == 2)
    {
        // facebook
        if(self.index == 0)
        {
            NSLog(@"porperty FB switched");
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"facebook_switch"];
        }
        // twitter
        if(self.index == 1)
        {
            NSLog(@"property TWTTR switched");
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"twitter_switch"];
        }
        // xing
        if(self.index == 2)
        {
            NSLog(@"property XNG switched");
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"xing_switch"];
        }
        // linkedin
        if(self.index == 3)
        {
            NSLog(@"property LKNDN switched");
            [viewController.myNimpleCode setBool:[self.propertySwitch isOn] forKey:@"linkedin_switch"];
        }
    }
}

//
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    
    // Twitter
    if(self.index == 1)
    {
        if(buttonIndex == 0)
        {
            [self.socialNetworkButton setAlpha:0.3];
            [self animatePropertySwitchVisibilityTo:0.0];
            [self.connectStatusButton setTitle:@"mit twitter verbinden" forState:UIControlStateNormal];
            [viewController.myNimpleCode setValue:@"" forKey:@"twitter_ID"];
            [viewController.myNimpleCode setValue:@"" forKey:@"twitter_URL"];
        }
    }
    // Xing
    if(self.index == 2)
    {
        if(buttonIndex == 0)
        {
            [self deauthorizeWithCompletion:^{
                [self.socialNetworkButton setAlpha:0.3];
                [self animatePropertySwitchVisibilityTo:0.0];
                [self.connectStatusButton setTitle:@"mit XING verbinden" forState:UIControlStateNormal];
                [viewController.myNimpleCode setValue:@"" forKey:@"xing_URL"];
            }];
        }
    }
    // LinkedIn
    if(self.index == 3)
    {
        if(buttonIndex == 0)
        {
            [self.socialNetworkButton setAlpha:0.3];
            [self animatePropertySwitchVisibilityTo:0.0];
            [self.connectStatusButton setTitle:@"mit LinkedIn verbinden" forState:UIControlStateNormal];
            [viewController.myNimpleCode setValue:@"" forKey:@"linkedin_URL"];
        }
    }
    [viewController.myNimpleCode synchronize];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
}

//
- (IBAction)connectButtonClicked:(id)sender
{
    NSString *destructiveTitle = @"Log out";
    NSString *cancelTitle = @"Cancel";
    self.actionSheet = [[UIActionSheet alloc]
                        initWithTitle:@""
                        delegate:self
                        cancelButtonTitle:cancelTitle
                        destructiveButtonTitle:destructiveTitle
                        otherButtonTitles: nil];
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Hello World!"
                                          message:@"This is your first UIAlertview message."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode synchronize];
    
    // handle facebook
    if(self.index == 0)
    {
        self.fbLoginView = [[FBLoginView alloc] init];
        self.fbLoginView.readPermissions = @[@"basic_info"];
        [self addSubview:self.fbLoginView];
        [self.fbLoginView setHidden:TRUE];
        self.fbLoginView.delegate = self;
        
        for(id object in self.fbLoginView.subviews){
            if([[object class] isSubclassOfClass:[UIButton class]]){
                UIButton* button = (UIButton*)object;
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    // handle twitter
    if(self.index == 1)
    {
        self.twitterAcount = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [self.twitterAcount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Handling log out
        if([[viewController.myNimpleCode valueForKey:@"twitter_ID"] length] == 0)
        {
            [self.twitterAcount requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                
                if(granted == YES)
                {
                    NSLog(@"Acces granted");
                    NSArray* accountsArray = [self.twitterAcount accountsWithAccountType:accountType];
                    NSLog(@"Acoounts count: %lu", (unsigned long)[accountsArray count]);
                    if([accountsArray count] > 0 )
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.socialNetworkButton setAlpha:1.0];
                            [self.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
                            [self animatePropertySwitchVisibilityTo:1.0];
                        });
                        ACAccount *twitterAccount = [accountsArray lastObject];
                        NSString *twitter_URL = [NSString stringWithFormat:@"https://twitter.com/%@", twitterAccount.username];
                        NSString *twitter_ID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                        [viewController.myNimpleCode setValue:twitter_URL forKey:@"twitter_URL"];
                        [viewController.myNimpleCode setValue:twitter_ID forKey:@"twitter_ID"];
                        [self animatePropertySwitchVisibilityTo:1.0];
                    }
                    else
                    {
                        NSLog(@"No twitter profile found!");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.alertView.title = @"Kein twitter Profil gefunden";
                            self.alertView.message = @"Logge dich in den Einstellungen unter 'Twitter' ein";
                            [self.alertView show];
                        });
                    }
                }
                else
                {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
        // Handling log out
        else
        {
            self.actionSheet.title = @"Loggd in using twitter";
            [self.actionSheet showInView:self.superview.superview];
        }
    }
    // xing
    if(self.index == 2)
    {
        // Introduce table view cell to app delegate, which handles the URL-opening in the browser
        self.networkManager = [[BDBOAuth1SessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.xing.com/"] consumerKey:XING_CONSUMER_KEY consumerSecret:XING_CONSUMER_SECRET];
        
        if(![NimpleAppDelegate sharedDelegate].xingTableViewCell)
            [NimpleAppDelegate sharedDelegate].xingTableViewCell = self;
        
        if(self.networkManager)
            [NimpleAppDelegate sharedDelegate].networkManager = self.networkManager;
        
        if([self.networkManager isAuthorized])
        {
            self.actionSheet.title = @"Loggd in using XING";
            [self.actionSheet showInView:self.superview.superview];
        }
        else
        {
            NSLog(@"XING has to be authorized");
            [self authorize];
        }
    }
    // linkedin
    if(self.index == 3)
    {
        // Handling log in
        if([[viewController.myNimpleCode valueForKey:@"linkedin_URL"] length] == 0)
        {
            self.linkedInClient = [self linkedInClient];
            [self.linkedInClient getAuthorizationCode:^(NSString *code) {
                [self.linkedInClient getAccessToken:code success:^(NSDictionary *accessTokenData) {
                    NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
                    [self.linkedInClient GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.socialNetworkButton setAlpha:1.0];
                             [self.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
                             [self animatePropertySwitchVisibilityTo:1.0];
                         });
                         NSDictionary *profileRequest = [result valueForKey:@"siteStandardProfileRequest"];
                         NSString *url = [profileRequest valueForKey:@"url"];
                         
                         //NSRange urlRange = [url rangeOfString:@"&authType"];
                         //NSString *permalink = [[url substringToIndex:urlRange.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                         
                         url = [url substringToIndex:[url rangeOfString:@"&"].location];
                         NSLog(@"Profile url: %@", url);
                         [viewController.myNimpleCode setValue:url forKey:@"linkedin_URL"];
                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         NSLog(@"failed to fetch current user %@", error);
                     }];
                }                   failure:^(NSError *error) {
                    NSLog(@"Quering accessToken failed %@", error);
                }];
            }                      cancel:^{
                NSLog(@"Authorization was cancelled by user");
            }                     failure:^(NSError *error) {
                NSLog(@"Authorization failed %@", error);
            }];
        }
        // Handling log out
        else
        {
            self.actionSheet.title = @"Loggd in using LinkedIn";
            [self.actionSheet showInView:self.superview.superview];
        }
    }
    
    [viewController.myNimpleCode synchronize];
}

# pragma mark XING Oauth calls

//--- XING ---------------------------------------------------------------------
// Authorizes the app calling the XING API
- (void) authorize
{
    [self.networkManager
     fetchRequestTokenWithPath:@"/v1/request_token"
     method:@"POST"
     callbackURL:[NSURL URLWithString:@"oauth://xing"]
     scope:nil
     success:^(BDBOAuthToken *requestToken)
     {
         NSString *authURL = [NSString stringWithFormat:@"https://api.xing.com/v1/authorize?oauth_token=%@", requestToken.token];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
     }
     failure:^(NSError *error)
     {
         NSLog(@"Error: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^
            {
                NSLog(@"ERRROR: %@", error);
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Could not acquire OAuth request token. Please try again later."
                                           delegate:self
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil] show];
            });
    }];
}

// Deauthorized nimple from the XING API
- (void)deauthorizeWithCompletion:(void (^)(void))completion
{
    [[NimpleAppDelegate sharedDelegate].networkManager deauthorize];
    [[NimpleAppDelegate sharedDelegate].networkManager.requestSerializer removeAccessToken];
    
    if(completion)
        completion();
}

//--- LINKEDIN -----------------------------------------------------------------
// Creates the LinkedIn client
- (LIALinkedInHttpClient *)linkedInClient {
    LIALinkedInApplication *application = [LIALinkedInApplication
        applicationWithRedirectURL:@"http://www.nimple.de"
        clientId:@"77pixj2vchhmrj"
        clientSecret:@"XDzQSRgsL1BOO8nm"
        state:@"DCEEFWF45453sdffef424"
        grantedAccess:@[@"r_fullprofile"]];
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:viewController];
}

//--- FACEBOOK -----------------------------------------------------------------
// Logged-out user
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self.socialNetworkButton setAlpha:0.3];
    [self animatePropertySwitchVisibilityTo:0.0];
    [self.connectStatusButton setTitle:@"mit facebook verbinden" forState:UIControlStateNormal];
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode setValue:@"" forKey:@"facebook_ID"];
    [viewController.myNimpleCode setValue:@"" forKey:@"facebook_URL"];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode setValue:user.id forKey:@"facebook_ID"];
    [viewController.myNimpleCode setValue:user.link forKey:@"facebook_URL"];
    [viewController.myNimpleCode synchronize];
    [self.socialNetworkButton setAlpha:1.0];
    [self.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
    [self animatePropertySwitchVisibilityTo:1.0];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
@end
