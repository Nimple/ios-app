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

- (void)updateData
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
    [cell setContact:[_contacts objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

# pragma mark - DisplayContactViewDelegate

- (void) displayContactViewControllerDidSave:(DisplayContactViewController*)controller
{
    NSLog(@"displayContactViewControllerDidSave");
    [_model save];
}

- (void) displayContactViewControllerDidDelete:(DisplayContactViewController*)controller
{
    NSLog(@"displayContactViewControllerDidDelete");
    
    if (controller.nimpleContact) {
        [_model deleteContact:controller.nimpleContact];
        NSLog(@"Deleted row.");
    }
    
    // reset view
    controller.nimpleContact = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
    [self updateData];
}

@end
