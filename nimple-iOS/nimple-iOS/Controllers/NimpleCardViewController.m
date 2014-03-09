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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangedNimpleCode:)
                                                 name:@"nimpleCodeChanged"
                                               object:nil];
}

// Handles the nimpleCodeChanged notifaction
- (void)handleChangedNimpleCode:(NSNotification *)note {
    NSLog(@"Received changed Nimple Code @ Nimple CARD VIEW CONTROLLER");
    
    NSDictionary *theData = [note userInfo];
    if (theData != nil) {
        NSUserDefaults *nimpleCode = [theData objectForKey:@"nimpleCode"];
        NSLog(@"%@", [nimpleCode valueForKey:@"surname"]);
        
        // Fill the nimple card
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", [nimpleCode valueForKey:@"prename"], [nimpleCode valueForKey:@"surname"]]];
        [self.jobLabel setText:[nimpleCode valueForKey:@"job"]];
        [self.companyLabel setText:[nimpleCode valueForKey:@"company"]];
        [self.phoneLabel setText:[nimpleCode valueForKey:@"phone"]];
        [self.emailLabel setText:[nimpleCode valueForKey:@"email"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        EditNimpleCodeTableViewController *editNimpleCodeController = [navigationController viewControllers][0];
        editNimpleCodeController.delegate = self;
    }
}

#pragma mark - EditNimpleCodeTableControllerDelegate

// Edit nimple code canceled
- (void)editNimpleCodeTableViewControllerDidCancel:(EditNimpleCodeTableViewController *)controller
{
    //NSLog(@"Nimple Card Delegation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Edit nimple code saved
- (void)editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController *)controller
{
    //NSLog(@"Nimple Card Delegation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
