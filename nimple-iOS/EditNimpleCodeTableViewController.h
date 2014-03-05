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
#import "OwnNimpleCode.h"

@interface EditNimpleCodeTableViewController : UITableViewController

@property (nonatomic, strong) OwnNimpleCode          *myNimpleCode;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
