//
//  EditNimpleCodeTableViewController.h
//  
//
//  Created by Guido Schmidt on 01.03.14.
//
//

// Framework imports
#import <UIKit/UIKit.h>
// Nimple imports
#import "EditInputViewCell.h"
#import "ConnectSocialProfileViewCell.h"

@class EditNimpleCodeTableViewController;

@protocol EditNimpleCodeTableControllerDelegate <NSObject>
@required
- (void) editNimpleCodeTableViewControllerDidCancel:(EditNimpleCodeTableViewController*)controller;
- (void) editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController*)controller;
@end

@interface EditNimpleCodeTableViewController : UITableViewController

@property (nonatomic, weak) id <EditNimpleCodeTableControllerDelegate> delegate;

@property (atomic) BOOL ownNimpleCodeExists;
@property (nonatomic, strong) NSMutableArray *cells;
@property (atomic, strong) NSUserDefaults    *myNimpleCode;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
