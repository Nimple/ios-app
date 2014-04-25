//
//  SettingsTableViewController.m
//  nimple-iOS
//
//  Created by Ben John on 23/03/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

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
        [self.tabBarController setSelectedIndex: 2];
}

// Will be executed when the view is loaded to memory
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizerRight];
    
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizerLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tap Gesture Action

- (IBAction)faqClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/faq/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)termsClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/terms/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)disclaimerClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/disclaimer/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)impressumClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/imprint/"];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)visitFacebookClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/facebook/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)shareNimpleClicked:(id)sender {
    NSString *shareText = NSLocalizedStringFromTable(@"settings.share-text", @"Main_iPhone", nil);
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:shareText, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
