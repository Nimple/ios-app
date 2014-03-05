//
//  EditNimpleCodeTableViewController.m
//  
//
//  Created by Guido Schmidt on 01.03.14.
//
//

#import "EditNimpleCodeTableViewController.h"

@interface EditNimpleCodeTableViewController ()

@end

@implementation EditNimpleCodeTableViewController

@synthesize myNimpleCode;
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Returns the number of sections used in this table view
// 1. personal section
// 2. social section
// 3. business section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// Returns the number of cells in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount = 0;
    // 1. section (personal): 1. prename 2. surname 3. phone 4. mail
    if(section == 0)
        cellCount = 4;
    // 2. section (social)
    else if (section == 1)
        cellCount = 0;
    // 3. section (business): 1. job title 2. company
    else if(section == 2)
        cellCount = 2;
    
    return cellCount;
}

// Returns the cell for a given row index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactInputCell";
    EditInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.row == 0)
        [cell.inputField setPlaceholder:@"Dein Vorname"];
    else if(indexPath.row == 1)
        [cell.inputField setPlaceholder:@"Dein Nachname"];
    else if(indexPath.row == 2)
        [cell.inputField setPlaceholder:@"Dein Telefonnummer"];
    else if(indexPath.row == 3)
        [cell.inputField setPlaceholder:@"Deine E-Mail-Adresse"];
    
    return cell;
}

// Returns the title for a given section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionName = @"";
    
    if(section == 0)
        sectionName = @"Personal";
    else if(section == 1)
        sectionName = @"Social";
    else if(section == 2)
        sectionName = @"Business";
    
    return sectionName;
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
