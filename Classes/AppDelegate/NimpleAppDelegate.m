//
//  NimpleAppDelegate.m
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#define XING_CONSUMER_KEY    @"247e95c9f304f6c5aaff"
#define XING_CONSUMER_SECRET @"cebe8869323e6d227257361eeabf05046c243721"

#define NIMPLE_MAIN_COLOR 0x850032
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "NimpleAppDelegate.h"
#import "NimpleCode.h"
#import "NimpleModel.h"
#import "Logging.h"

@implementation NimpleAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"oauth"]) {
        if ([url.host isEqualToString:@"xing"]) {
            // send notification in order to avoid boilerplate code in AppDelegate
            [self handleXingAuthForUrl:url];
        }
        return YES;
    } else if ([FBAppCall handleOpenURL:url sourceApplication:sourceApplication]) {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self bootstrapApplication];
    [self setupNavigationBar];
    [self setupTabs];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSettings setDefaultAppID:@"1451876021700653"];
    [FBAppEvents activateApp];
}

- (void)bootstrapApplication
{
    [Logging sharedLogging];
    [FBLoginView class];
    [NimpleCode sharedCode];
    [[NimpleModel sharedModel] createExampleContact];
}

- (void)setupNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
}

- (UITabBar *)tabBar
{
    return ((UITabBarController *)self.window.rootViewController).tabBar;
}

- (void)setupTabs
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    UINavigationController *nimpleCardController = (UINavigationController *)navigationController.childViewControllers[0];
    nimpleCardController.title = NimpleLocalizedString(@"tab_nimple_card_title");
    
    UINavigationController *nimpleCodeController = (UINavigationController *)navigationController.childViewControllers[1];
    nimpleCodeController.title = NimpleLocalizedString(@"tab_nimple_code_title");
    
    UINavigationController *contactsController = (UINavigationController *)navigationController.childViewControllers[2];
    contactsController.title = NimpleLocalizedString(@"tab_contacts_title");
    
    UINavigationController *settingsController = (UINavigationController *)navigationController.childViewControllers[3];
    settingsController.title = NimpleLocalizedString(@"tab_settings_title");
    
    UITabBarItem *card = ([self tabBar].items)[0];
    UITabBarItem *code = ([self tabBar].items)[1];
    UITabBarItem *contacts = ([self tabBar].items)[2];
    UITabBarItem *settings = ([self tabBar].items)[3];
    
    card.selectedImage = [[UIImage imageNamed:@"tabbar_selected_nimple-card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    card.image = [[UIImage imageNamed:@"tabbar_nimple-card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    code.selectedImage = [[UIImage imageNamed:@"tabbar_selected_nimple-code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    code.image = [[UIImage imageNamed:@"tabbar_nimple-code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    contacts.selectedImage = [[UIImage imageNamed:@"tabbar_selected_contacts"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contacts.image = [[UIImage imageNamed:@"tabbar_contacts"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    settings.selectedImage = [[UIImage imageNamed:@"tabbar_selected_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settings.image = [[UIImage imageNamed:@"tabbar_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[self tabBar] setTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
}

#pragma mark - Core Data integration

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Xing integration (should be moved into XingTableViewCell)

- (void)handleXingAuthForUrl:(NSURL *)url
{
    NSDictionary *parameters = [NSDictionary bdb_dictionaryFromQueryString:url.query];
    if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
        [self.networkManager fetchAccessTokenWithPath:@"/v1/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
            [self receiveXingId];
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not acquire OAuth access token. Please try again later." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            });
        }];
    }
}

- (void)receiveXingId
{
    [self.networkManager GET:@"/v1/users/me/id_card" parameters:nil success:^(NSURLSessionDataTask *task, id response) {
        NSString *permalink = [response valueForKeyPath:@"id_card.permalink"];
        NSLog(@"XING Permalink %@", permalink);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.xingTableViewCell.socialNetworkButton setAlpha:1.0];
            [self.xingTableViewCell animatePropertySwitchVisibilityTo:1.0];
            [self.xingTableViewCell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
        });
        
        [NimpleCode sharedCode].xing = permalink;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
}

@end
