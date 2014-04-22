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
    // Do any additional setup after loading the view
    NSLog(@"Display contact view loaded");
    NSLog(@"With contact %@", self.nimpleContact.objectID);
    
    // Set nagigation bar title
    NSString* newTitle = [NSString stringWithFormat:@"%@ %@", self.nimpleContact.prename, self.nimpleContact.surname];
    [self.navBar setTitle:newTitle];
    
    // Set labels
    [self.nameLabel setText:newTitle];
    [self.phoneLabel setText:self.nimpleContact.phone];
    [self.emailLabel setText:self.nimpleContact.email];
    [self.companyLabel setText:self.nimpleContact.company];
    [self.jobLabel setText:self.nimpleContact.job];
    [self.facebookURL setTitle:self.nimpleContact.facebook_URL forState:UIControlStateNormal];
    [self.twitterURL setTitle:self.nimpleContact.twitter_URL forState:UIControlStateNormal];
    [self.xingURL setTitle:self.nimpleContact.xing_URL forState:UIControlStateNormal];
    [self.linkedinURL setTitle:self.nimpleContact.linkedin_URL forState:UIControlStateNormal];
    
    // Add Navigation Bar button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveButton;
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
- (IBAction)save:(id)sender {
    
}


//
- (IBAction)cancel:(id)sender
{
    [self.delegate displayContactViewControllerDidCancel:self];
}

//
- (IBAction)done:(id)sender
{
    [self.delegate displayContactViewControllerDidSave:self];
}

-(IBAction)delete:(id)sender
{
    [self.delegate displayContactViewControllerDidDelete:self];
}

@end
