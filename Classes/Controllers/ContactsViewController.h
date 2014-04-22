//
//  ContactsViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

// Framework imports
#import <UIKit/UIKit.h>
// Nimple imports
#import "NimpleContact.h"
#import "BarCodeReaderController.h"
#import "DisplayContactViewController.h"

@interface ContactsViewController : UITableViewController <UITabBarControllerDelegate, DisplayContactViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray                *nimpleContacts;

@end
