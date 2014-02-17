//
//  NimpleViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 18.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleViewController.h"

@interface NimpleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation NimpleViewController

- (IBAction)buttonPress:(id)sender {
    [self.button setTitle:@"Hello Nimple!" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
