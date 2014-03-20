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
    NSLog(@"Swipe received.");
    //[self.tabBarController setSelectedIndex: 1];
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:1] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = 1;
                        }
                    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.myNimpleCode = [NSUserDefaults standardUserDefaults];
    [myNimpleCode synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangedNimpleCode:)
                                                 name:@"nimpleCodeChanged"
                                               object:nil];
    NSString* surname = [myNimpleCode valueForKey:@"surname"];
    NSString* prename = [myNimpleCode valueForKey:@"prename"];
    NSString* phone = [self.myNimpleCode valueForKey:@"phone"];
    NSString* email = [self.myNimpleCode valueForKey:@"email"];
    NSString* job = [self.myNimpleCode valueForKey:@"job"];
    NSString* company = [self.myNimpleCode valueForKey:@"company"];
    NSString* facebook_URL = [self.myNimpleCode valueForKey:@"facebook_URL"];
    NSString* facebook_ID  = [self.myNimpleCode valueForKey:@"facebook_ID"];
    NSString* twitter_URL = [self.myNimpleCode valueForKey:@"twitter_URL"];
    NSString* twitter_ID  = [self.myNimpleCode valueForKey:@"twitter_ID"];
    NSString* xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
    NSString* linkedin_URL = [self.myNimpleCode valueForKey:@"linkedin_URL"];
    if( surname.length == 0 && prename.length == 0 && phone.length == 0 && email.length == 0 && job.length == 0 && company.length == 0 && facebook_ID.length == 0 && facebook_URL.length == 0 && twitter_ID.length == 0 &&
       twitter_URL.length == 0 && xing_URL.length == 0 && linkedin_URL.length == 0)
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
    NSString* surname = [myNimpleCode valueForKey:@"surname"];
    NSString* prename = [myNimpleCode valueForKey:@"prename"];
    NSString* phone = [self.myNimpleCode valueForKey:@"phone"];
    NSString* email = [self.myNimpleCode valueForKey:@"email"];
    NSString* job = [self.myNimpleCode valueForKey:@"job"];
    NSString* company = [self.myNimpleCode valueForKey:@"company"];
    NSString* facebook_URL = [self.myNimpleCode valueForKey:@"facebook_URL"];
    NSString* facebook_ID  = [self.myNimpleCode valueForKey:@"facebook_ID"];
    NSString* twitter_URL = [self.myNimpleCode valueForKey:@"twitter_URL"];
    NSString* twitter_ID  = [self.myNimpleCode valueForKey:@"twitter_ID"];
    NSString* xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
    NSString* linkedin_URL = [self.myNimpleCode valueForKey:@"linkedin_URL"];
    if( surname.length == 0 && prename.length == 0 && phone.length == 0 && email.length == 0 && job.length == 0 && company.length == 0 && facebook_ID.length == 0 && facebook_URL.length == 0 && twitter_ID.length == 0 &&
       twitter_URL.length == 0 && xing_URL.length == 0 && linkedin_URL.length == 0)
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
        
    NSString *facebook_URL = [self.myNimpleCode valueForKey:@"facebook_URL"];
    NSString *facebook_ID  = [self.myNimpleCode valueForKey:@"facebook_ID"];
    if(facebook_URL.length != 0 || facebook_ID.length != 0)
        [self.facebookIcon setAlpha:1.0];
    
    NSString *twitter_URL = [self.myNimpleCode valueForKey:@"twitter_URL"];
    NSString *twitter_ID  = [self.myNimpleCode valueForKey:@"twitter_ID"];
    if(twitter_URL.length != 0 || twitter_ID.length != 0)
        [self.twitterIcon setAlpha:1.0];
    
    NSString *xing_URL = [self.myNimpleCode valueForKey:@"xing_URL"];
    if(xing_URL.length != 0)
        [self.xingIcon setAlpha:1.0];
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
