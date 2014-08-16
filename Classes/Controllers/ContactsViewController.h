//
//  ContactsViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimpleContact.h"
#import "NimpleModel.h"
#import "BarCodeReaderController.h"
#import "DisplayContactViewController.h"

@interface ContactsViewController : UITableViewController <UITabBarControllerDelegate, DisplayContactViewControllerDelegate>

@end
