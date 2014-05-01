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

#define MIXPANEL_TOKEN @"6e3eeca24e9b2372e8582b381295ca0c"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "NimpleAppDelegate.h"
#import "Logging.h"
#import "NimpleContactPersistenceManager.h"

@implementation NimpleAppDelegate

static NimpleAppDelegate * _sharedDelegate = nil;

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize xingTableViewCell;

+ (instancetype)sharedDelegate {
    return _sharedDelegate;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _sharedDelegate = self;
    }
    return self;
}

// Application launched
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init Logging/Mixpanel
    [Logging initMixpanel];
    
    // Setup social network APIs
    [FBLoginView class];
    
    // Set nimple tint color for navigation bar
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(NIMPLE_MAIN_COLOR)];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Init Persistence Manager
    [NimpleContactPersistenceManager getInstance:context];
    
    // Find and setup view controllers
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    // Nimple card view controller
    UINavigationController *nimpleCardController = (UINavigationController*) navigationController.childViewControllers[0];
    NSLog(@"Controller 0  is %@", nimpleCardController.title);
    NimpleCardViewController *nimpleCardViewController = (NimpleCardViewController*)nimpleCardController.childViewControllers[0];
    nimpleCardViewController.managedObjectContext = context;
    
    // Nimple code view controller
    UINavigationController *presentedController1 = (UINavigationController*) navigationController.childViewControllers[1];
    NSLog(@"Controller 1 is %@", presentedController1.title);
    NimpleCodeViewController *nimpleCodeViewController = (NimpleCodeViewController*)presentedController1.childViewControllers[0];
    nimpleCodeViewController.managedObjectContext = context;
    
    // Nimple code view controller
    UINavigationController *contactsController = (UINavigationController*) navigationController.childViewControllers[2];
    NSLog(@"Controller 2 is %@", contactsController.title);
    ContactsViewController *contactsViewController = (ContactsViewController*)contactsController.childViewControllers[0];
    contactsViewController.managedObjectContext = context;
    
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
    
    NSLog(@"Nimple launched successfully!");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
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
                                                                   
                                                                   [self.xingTableViewCell.connectStatusButton setTitle:NSLocalizedStringFromTable(@"connected_label", @"Localizable", nil) forState:UIControlStateNormal];
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NimpleContact.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // we use lightweight core-data migration, should fit in our case
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
