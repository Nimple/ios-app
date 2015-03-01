//
//  NimpleProViewController.m
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import "NimpleProViewController.h"
#import "NimplePurchaseModel.h"

@interface NimpleProViewController ()

@end

@implementation NimpleProViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)unlockProClicked:(id)sender
{
    NSLog(@"unlock pro clicked");
    [[NimplePurchaseModel sharedPurchaseModel] requestPurchase];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
