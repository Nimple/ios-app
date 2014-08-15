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
#import <FacebookSDK/FacebookSDK.h>
#import <NSDictionary+BDBOAuth1Manager.h>

// Nimple imports
#import "NimpleCode.h"
#import "NimpleContact.h"
#import "NimpleCardViewController.h"
#import "ContactsViewController.h"
#import "BarCodeReaderController.h"
#import "EditNimpleCodeTableViewController.h"
#import "NimpleCodeViewController.h"
#import "ConnectSocialProfileViewCell.h"

@interface NimpleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readwrite) BDBOAuth1SessionManager             *networkManager;
@property (atomic) ConnectSocialProfileViewCell                      *xingTableViewCell;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark Initialization
+ (instancetype)sharedDelegate;

@end
