//
//  DisplayContactViewController.h
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimpleContact.h"

@interface DisplayContactViewController : UIViewController

@property (nonatomic, strong) NimpleContact *nimpleContact;

-(void)commitNimpleContact:(NimpleContact*)contact;

@end
