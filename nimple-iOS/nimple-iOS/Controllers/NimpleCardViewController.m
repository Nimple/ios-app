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

@synthesize myNimpleCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    //NSLog(@"Swipe received.");
    [self.tabBarController setSelectedIndex: 1];
    
    /*
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:1] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = 1;
                        }
                    }];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangedNimpleCode:)
                                                 name:@"nimpleCodeChanged"
                                               object:nil];
    
    if(self.checkOwnProperties)
    {
        [self.nimpleCardView setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
    }
    else
    {
        [self.nimpleCardView setHidden:FALSE];
        [self.welcomeView setHidden:TRUE];
        [self handleChangedNimpleCode:nil];
    }
    
}

-(void) viewDidAppear:(BOOL)animated
{
    if( self.checkOwnProperties)
    {
        [self.nimpleCardView setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
    }
    else
    {
        [self.nimpleCardView setHidden:FALSE];
        [self.welcomeView setHidden:TRUE];
    }
}

-(BOOL)checkOwnProperties
{
    if(!myNimpleCode)
    {
        self.myNimpleCode = [NSUserDefaults standardUserDefaults];
        [myNimpleCode synchronize];
    }
    
    return  (((NSString *)[myNimpleCode valueForKey:@"surname"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"prename"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"phone"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"job"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"company"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"facebook_URL"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"facebook_ID"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"twitter_URL"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"twitter_ID"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"xing_URL"]).length == 0) &&
            (((NSString *)[myNimpleCode valueForKey:@"linkedin_URL"]).length == 0);
}



// Handles the nimpleCodeChanged notifaction
- (void)handleChangedNimpleCode:(NSNotification *)note {
    NSLog(@"Received changed Nimple Code @ Nimple CARD VIEW CONTROLLER");

    [self.myNimpleCode synchronize];

    // Fill the nimple card
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", [self.myNimpleCode valueForKey:@"prename"], [self.myNimpleCode valueForKey:@"surname"]]];
    [self.jobLabel setText:[self.myNimpleCode valueForKey:@"job"]];
    [self.companyLabel setText:[self.myNimpleCode valueForKey:@"company"]];
    [self.phoneLabel setText:[self.myNimpleCode valueForKey:@"phone"]];
    [self.emailLabel setText:[self.myNimpleCode valueForKey:@"email"]];
    // facebook
    NSString *facebook_URL = [self.myNimpleCode valueForKey:@"facebook_URL"];
    NSString *facebook_ID  = [self.myNimpleCode valueForKey:@"facebook_ID"];
    if(facebook_URL.length != 0 || facebook_ID.length != 0)
        [self.facebookIcon setAlpha:1.0];
    // twitter
    NSString *twitter_URL = [self.myNimpleCode valueForKey:@"twitter_URL"];
    NSString *twitter_ID  = [self.myNimpleCode valueForKey:@"twitter_ID"];
    if(twitter_URL.length != 0 || twitter_ID.length != 0)
        [self.twitterIcon setAlpha:1.0];
    // xing
    NSString *xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
    if(xing_URL.length != 0)
        [self.xingIcon setAlpha:1.0];
    // linkedin
    NSString *linkedin_URL = [self.myNimpleCode valueForKey:@"linkedin_URL"];
    if(linkedin_URL.length != 0)
        [self.linkedinIcon setAlpha:1.0];
    
    // Blending based on property switches in 'edit nimple code'
    if(![self.myNimpleCode boolForKey:@"phone_switch"])
    {
        [self.phoneLabel setAlpha:0.2];
        [self.phoneIcon setAlpha:0.2];
    }
    else
    {
        [self.phoneLabel setAlpha:1.0];
        [self.phoneIcon setAlpha:1.0];
    }
        
    if(![self.myNimpleCode boolForKey:@"email_switch"])
    {
        [self.emailLabel setAlpha:0.2];
        [self.emailIcon setAlpha:0.2];
    }
    else
    {
        [self.emailLabel setAlpha:1.0];
        [self.emailIcon setAlpha:1.0];
    }
    if(![self.myNimpleCode boolForKey:@"company_switch"])
    {
        [self.companyLabel setAlpha:0.2];
        [self.companyIcon setAlpha:0.2];
    }
    else
    {
        [self.companyLabel setAlpha:1.0];
        [self.companyIcon setAlpha:1.0];
    }
    if(![self.myNimpleCode boolForKey:@"job_switch"])
    {
        [self.jobLabel setAlpha:0.2];
        [self.jobIcon setAlpha:0.2];
    }
    else
    {
        [self.companyLabel setAlpha:1.0];
        [self.companyIcon setAlpha:1.0];
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
