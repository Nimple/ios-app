//
//  DisplayContactViewController.m
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "DisplayContactViewController.h"

@interface DisplayContactViewController ()

@end

@implementation DisplayContactViewController

@synthesize nimpleContact;
@synthesize scrollView;

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
    
    // Setup scroll view
    [self.scrollView setDelegate:self];
    [self.scrollView setScrollEnabled:TRUE];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.frame = self.view.frame;
    
    // Do any additional setup after loading the view
    NSLog(@"Display contact view loaded");
    NSLog(@"With contact %@", self.nimpleContact.objectID);
    
    // Set labels
    NSString* name = [NSString stringWithFormat:@"%@ %@", self.nimpleContact.prename, self.nimpleContact.surname];
    [self.nameLabel setText:name];
    [self.phoneLabel setText:self.nimpleContact.phone];
    [self.emailLabel setText:self.nimpleContact.email];
    [self.companyLabel setText:self.nimpleContact.company];
    [self.jobLabel setText:self.nimpleContact.job];
    [self.facebookURL setTitle:self.nimpleContact.facebook_URL forState:UIControlStateNormal];
    [self.twitterURL setTitle:self.nimpleContact.twitter_URL forState:UIControlStateNormal];
    [self.xingURL setTitle:self.nimpleContact.xing_URL forState:UIControlStateNormal];
    [self.linkedinURL setTitle:self.nimpleContact.linkedin_URL forState:UIControlStateNormal];
    
    // Set timestamp label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy hh:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.nimpleContact.created];
    [self.timestampLabel setText:[NSString stringWithFormat:@"%@ Uhr", formattedDate]];
    
    // Initalize action sheets
    NSString *destructiveTitle = @"Löschen";
    NSString *cancelTitle = @"Abbrechen";
    self.actionSheetDelete = [[UIActionSheet alloc]
                        initWithTitle:@"Kontakt wirklich löschen?"
                        delegate:self
                        cancelButtonTitle:cancelTitle
                        destructiveButtonTitle:destructiveTitle
                        otherButtonTitles: nil];

    NSString *addNewTitle = @"Neuer Kontakt";
    NSString *contactFusionTitle = @"Bestehender Kontakt";
    self.actionSheetAddressbook = [[UIActionSheet alloc]
                              initWithTitle:@"Kontakt ins Adressbuch speichern"
                              delegate:self
                              cancelButtonTitle:cancelTitle
                              destructiveButtonTitle:nil
                              otherButtonTitles: addNewTitle, contactFusionTitle, nil
                              ];
    
}

-(void)saveAction:(UIBarButtonItem *)sender{
    //perform your action
    NSLog(@"Save button pressed");
    
    // should redirect so cancel
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
/*- (IBAction)done:(id)sender
{
    [self.delegate displayContactViewControllerDidSave:self];
}*/

#pragma mark Button callbacks

- (IBAction)saveToAddressBookButtonClicked:(id)sender {
#pragma mark TODO@BEN
    NSLog(@"Contact will be saved to address book");
    [self.actionSheetAddressbook showInView:self.view];
}

- (IBAction)deleteContactButtonClicked:(id)sender {
    NSLog(@"Contact will be deleted");
    [self.actionSheetDelete showInView:self.view];
}

#pragma mark ActionSheet callbacks
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == self.actionSheetDelete) {
        [self.delegate displayContactViewControllerDidDelete:self];
    }
}


@end
