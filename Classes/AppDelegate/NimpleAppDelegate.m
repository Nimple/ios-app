//
//  NimpleAppDelegate.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 19.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#define NIMPLE_MAIN_COLOR 0x850032

#define XING_CONSUMER_KEY    @"247e95c9f304f6c5aaff"
#define XING_CONSUMER_SECRET @"cebe8869323e6d227257361eeabf05046c243721"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "NimpleAppDelegate.h"
#import "Logging.h"

@implementation NimpleAppDelegate

@synthesize xingTableViewCell;

- (void)setupNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
}

- (void)setupTabs
{
    // Find and setup view controllers
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    // Nimple card view controller
    UINavigationController *nimpleCardController = (UINavigationController*) navigationController.childViewControllers[0];
    nimpleCardController.title = NimpleLocalizedString(@"tab_nimple_card_title");
    NSLog(@"Controller 0  is %@", nimpleCardController.title);
    
    // Nimple code view controller
    UINavigationController *presentedController1 = (UINavigationController*) navigationController.childViewControllers[1];
    presentedController1.title = NimpleLocalizedString(@"tab_nimple_code_title");
    NSLog(@"Controller 1 is %@", presentedController1.title);
    
    // Nimple code view controller
    UINavigationController *contactsController = (UINavigationController*) navigationController.childViewControllers[2];
    contactsController.title = NimpleLocalizedString(@"tab_contacts_title");
    NSLog(@"Controller 2 is %@", contactsController.title);
    
    // Settings controller
    UINavigationController *settingsController = (UINavigationController*) navigationController.childViewControllers[3];
    settingsController.title = NimpleLocalizedString(@"tab_settings_title");
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabbar = tabBarController.tabBar;
    UITabBarItem *tabbar_card     = [tabbar.items objectAtIndex:0];
    UITabBarItem *tabbar_code     = [tabbar.items objectAtIndex:1];
    UITabBarItem *tabbar_contacts = [tabbar.items objectAtIndex:2];
    UITabBarItem *tabbar_settings = [tabbar.items objectAtIndex:3];
    
    tabbar_card.selectedImage = [[UIImage imageNamed:@"tabbar_selected_nimple-card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabbar_card.image = [[UIImage imageNamed:@"tabbar_nimple-card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabbar_code.selectedImage = [[UIImage imageNamed:@"tabbar_selected_nimple-code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabbar_code.image = [[UIImage imageNamed:@"tabbar_nimple-code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabbar_contacts.selectedImage = [[UIImage imageNamed:@"tabbar_selected_contacts"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabbar_contacts.image = [[UIImage imageNamed:@"tabbar_contacts"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabbar_settings.selectedImage = [[UIImage imageNamed:@"tabbar_selected_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabbar_settings.image = [[UIImage imageNamed:@"tabbar_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    [tabbar setTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
}

- (void)bootstrapApplication
{
    [Logging initMixpanel];
    [FBLoginView class];
    [NimpleCode sharedCode];
    [NimpleModel sharedModel];
    [self createExampleContact];
}

- (void) createExampleContact
{
    // TODO move to NimpleModel
    
    // bootstrap -> create initial contact
    // Add default contact
    BOOL exampleUserDidExist =[[NSUserDefaults standardUserDefaults] boolForKey:@"example_contact_once_existed"];
    if(!exampleUserDidExist) {
        // NimpleContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact" inManagedObjectContext:self.managedObjectContext];
        
        NimpleContact *contact = [[NimpleContact alloc] init];
        
        contact.prename = @"Nimple";
        contact.surname = @"App";
        contact.phone = @"";
        contact.email = @"feedback.ios@nimple.de";
        contact.job = @"";
        contact.company = NimpleLocalizedString(@"company_first_contact_label");
        contact.facebook_URL = @"http://www.facebook.de/nimpleapp";
        contact.facebook_ID = @"286113114869395";
        contact.twitter_URL = @"https://twitter.com/Nimpleapp";
        contact.twitter_ID = @"2444364654";
        contact.xing_URL = @"https://www.xing.com/companies/appstronautengbr";
        contact.linkedin_URL = @"https://www.linkedin.com/company/appstronauten-gbr";
        contact.created = [NSDate date];
        contact.website = @"http://www.nimple.de";
        
        NSError *error;
        // [self.managedObjectContext save:&error];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"example_contact_once_existed"];
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self bootstrapApplication];
    [self setupNavigationBar];
    [self setupTabs];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"oauth"]) {
        if ([url.host isEqualToString:@"xing"]) {
            NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                [self.networkManager fetchAccessTokenWithPath:@"/v1/access_token"
                                                       method:@"POST"
                                                 requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                                      success:^(BDBOAuthToken *accessToken) {
                                                          [self.networkManager GET:@"/v1/users/me/id_card" parameters:nil
                                                                           success:^(NSURLSessionDataTask *task, id response)
                                                           {
                                                               NSLog(@"Response %@", response);
                                                               NSArray *permalink = [response valueForKeyPath:@"id_card.permalink"];
                                                               NSLog(@"XING Permalink %@", permalink);
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [self.xingTableViewCell.socialNetworkButton setAlpha:1.0];
                                                                   [self.xingTableViewCell animatePropertySwitchVisibilityTo:1.0];
                                                                   
                                                                   [self.xingTableViewCell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
                                                               });
                                                               
                                                               NSUserDefaults *myNimpleCode = [NSUserDefaults standardUserDefaults];
                                                               [myNimpleCode setValue:permalink forKeyPath:@"xing_URL"];
                                                           }
                                                                           failure:^(NSURLSessionDataTask *task, NSError * error)
                                                           {
                                                               NSLog(@"ERROR: %@", error);
                                                           }];
                                                      }
                                                      failure:^(NSError *error) {
                                                          NSLog(@"Error: %@", error.localizedDescription);
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                          message:@"Could not acquire OAuth access token. Please try again later."
                                                                                         delegate:self
                                                                                cancelButtonTitle:@"Dismiss"
                                                                                otherButtonTitles:nil] show];
                                                          });
                                                      }];
            }
        }
        
        return YES;
    }
    // Call facebook API URL handler
    else if( [FBAppCall handleOpenURL:url sourceApplication:sourceApplication] )
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Core Data integration

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
