//
//  EditNimpleCodeTableViewController.h
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInputViewCell.h"
#import "EditAddressInputViewCell.h"
#import "ConnectSocialProfileViewCell.h"

@class EditNimpleCodeTableViewController;

@protocol EditNimpleCodeTableControllerDelegate <NSObject>

@required
- (void) editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController*)controller;
@end

@interface EditNimpleCodeTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <EditNimpleCodeTableControllerDelegate> delegate;
@property (atomic, weak) NSUserDefaults                                *myNimpleCode;

- (IBAction)done:(id)sender;

@end
