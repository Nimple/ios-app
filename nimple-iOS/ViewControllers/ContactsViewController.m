//
//  ContactsViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize nimpleContacts;
@synthesize managedObjectContext;

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tab Bar should select: %@", viewController.title);
    return true;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received.");

    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
        [self.tabBarController setSelectedIndex: 1];
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        [self.tabBarController setSelectedIndex: 3];
}

// Will be executed when the view is loaded to memory
- (void)viewDidLoad
{
    [super viewDidLoad];

    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizerRight];
    
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizerLeft];
    
    [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Will be executed when the view appears
- (void) viewWillAppear:(BOOL)animated
{
    [self updateData];
}

// Updates the data by fetchRequest from the managed object context
- (void) updateData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription
                                    entityForName:@"NimpleContact" inManagedObjectContext:managedObjectContext];
    
    // sort nimpleContactsArray by created:NSDate (DESC)
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"created" ascending:NO];
    
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    self.nimpleContacts = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Add default contact
    if([self.nimpleContacts count] == 0)
    {
        NimpleContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact" inManagedObjectContext:self.managedObjectContext];
        [contact setValueForPrename:@"Nimple" Surname:@"App" PhoneNumber:@"" MailAddress:@"feedback.ios@nimple.de" JobTitle:@"" Company:@"Dein erster Kontakt" FacebookURL:@"http://www.facebook.de/nimpleapp" FacebookID:@"286113114869395" TwitterURL:@"http://www.twitter.de/nimpleapp" TwitterID:nil XingURL:@"" LinkedInURL:@"" Created:[NSDate date]];
        NSError *error;
        [self.managedObjectContext save:&error];
        self.nimpleContacts = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    
    [self.tableView reloadData];
}

// Prepare the segue by passing the managed object context
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddContact"])
    {
        BarCodeReaderController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
    }
}

//
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        NimpleContact *nimpleContact = [self.nimpleContacts objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:nimpleContact];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error at deleting row -> fix error pls.");
        }
        
        NSLog(@"Deleted row.");
        
        // update view after delete
        [self updateData];
    }
}

#pragma mark - Table view data source

// Sets the number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [nimpleContacts count];
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NimpleContact *contact = [nimpleContacts objectAtIndex:indexPath.row];
    [cell setContact:contact];
    
    // Set facebook icon state
    NSString *facebook_URL = [contact valueForKey:@"facebook_URL"];
    NSString *facebook_ID = [contact valueForKey:@"facebook_ID"];
    if(facebook_ID.length == 0 || facebook_URL.length == 0)
        [cell.facebookButton setAlpha:0.2];
    else
        [cell.facebookButton setAlpha:1.0];
    
    // Set twitter icon state
    NSString *twitter_URL = [contact valueForKey:@"twitter_URL"];
    NSString *twitter_ID = [contact valueForKey:@"twitter_ID"];
    if(twitter_ID.length == 0 || twitter_URL.length == 0)
        [cell.twitterButton setAlpha:0.2];
    else
        [cell.twitterButton setAlpha:1.0];
    
    // Set xing icon state
    NSString *xing_URL = [contact valueForKey:@"xing_URL"];
    if(xing_URL.length == 0)
        [cell.xingButton setAlpha:0.2];
    else
        [cell.xingButton setAlpha:1.0];

    // Set linkedin icon state
    NSString *linkedin_URL = [contact valueForKey:@"linkedin_URL"];
    if(linkedin_URL.length == 0)
        [cell.linkedinButton setAlpha:0.2];
    else
        [cell.linkedinButton setAlpha:1.0];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
