//
//  ContactsViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import "DisplayContactViewController.h"

@interface ContactsViewController () {
    __weak IBOutlet UINavigationItem *_navigationLabel;
    NimpleModel *_model;
    NSArray *_contacts;
}

@end

@implementation ContactsViewController

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tab Bar should select: %@", viewController.title);
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _model = [NimpleModel sharedModel];
    [self localizeViewAttributes];
    [self configureTableView];
    [self updateData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateData];
}

- (void)localizeViewAttributes
{
    _navigationLabel.title = NimpleLocalizedString(@"contacts_title");
}

- (void)configureTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
}

- (void) updateData
{
    _contacts = [_model contacts];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailView"]) {
        DisplayContactViewController *destViewController = segue.destinationViewController;
        destViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NimpleContact *contact = [_contacts objectAtIndex:indexPath.row];
        [destViewController setNimpleContact:contact];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

# pragma mark DisplayContactViewDelegate

- (void) displayContactViewControllerDidSave:(DisplayContactViewController*)controller
{
    NSLog(@"displayContactViewControllerDidSave");
    [_model save];
}

- (void) displayContactViewControllerDidDelete:(DisplayContactViewController*)controller
{
    NSLog(@"displayContactViewControllerDidDelete");
    
    // Remove contact and segueBack
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    if (controller.nimpleContact) {
        [_model deleteContact:controller.nimpleContact];
    }
    
    NSLog(@"Deleted row.");
    
    // reset view
    controller.nimpleContact = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
    // update view after delete
    [self updateData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    NimpleContact *contact = [_contacts objectAtIndex:indexPath.row];
    [cell setContact:contact];
    
    if (contact.facebook_ID.length == 0 && contact.facebook_URL.length == 0)
        [cell.facebookButton setAlpha:0.2];
    else
        [cell.facebookButton setAlpha:1.0];
    
    if (contact.twitter_ID.length == 0 && contact.twitter_URL.length == 0)
        [cell.twitterButton setAlpha:0.2];
    else
        [cell.twitterButton setAlpha:1.0];
    
    if (contact.xing_URL.length == 0)
        [cell.xingButton setAlpha:0.2];
    else
        [cell.xingButton setAlpha:1.0];
    
    if (contact.linkedin_URL.length == 0)
        [cell.linkedinButton setAlpha:0.2];
    else
        [cell.linkedinButton setAlpha:1.0];
    return cell;
}

@end
