//
//  NimpleAppDelegate.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 19.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
// Framework imports
#import <CoreImage/CoreImage.h>
#import <Mixpanel/Mixpanel.h>
#import <FacebookSDK/FacebookSDK.h>
//#import <XNGAPIClient/XNGAPIClient.h>
// Nimple imports
#import "NimpleContact.h"
#import "NimpleCardViewController.h"
#import "ContactsViewController.h"
#import "BarCodeReaderController.h"
#import "EditNimpleCodeTableViewController.h"
#import "NimpleCodeViewController.h"

@interface NimpleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)   saveContext;
- (NSURL*) applicationDocumentsDirectory;

@end
