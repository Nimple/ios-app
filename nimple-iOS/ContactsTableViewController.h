//
//  ContactsTableViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ContactTableViewCell.h"

@interface ContactsTableViewController : UITableViewController
    <MFMailComposeViewControllerDelegate>

@end
