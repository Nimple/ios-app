//
//  NimpleCardViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCardViewController.h"

@interface NimpleCardViewController ()

@end

@implementation NimpleCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.nameLabel setText:@"YOLO"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController *)controller
{
    NSLog(@"SAVED!!!!");
    NSString* prename = [controller.myNimpleCode valueForKey:@"prename"];
    NSString* surname = [controller.myNimpleCode valueForKey:@"surname"];
    NSString* phone   = [controller.myNimpleCode valueForKey:@"phone"];
    NSString* email   = [controller.myNimpleCode valueForKey:@"email"];
    NSString* job     = [controller.myNimpleCode valueForKey:@"job"];
    NSString* company = [controller.myNimpleCode valueForKey:@"company"];

    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", prename, surname]];
    [self.phoneLabel setText:phone];
    [self.emailLabel setText:email];
    [self.companyLabel setText:company];
    [self.jobLabel setText:job];
}*/

@end
