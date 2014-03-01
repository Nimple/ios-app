//
//  EditNimpleCodeViewController.m
//  nimple-iOS
//
//  Created by Sebastian Lang on 01.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditNimpleCodeViewController.h"

@interface EditNimpleCodeViewController (
)

@end

@implementation EditNimpleCodeViewController


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
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickSaveButton:(id)sender {
    NSLog(@"Pressed Save Button");

    NSString* prename = self.prenameField.text;
    NSString* surname = self.surnameField.text;
    NSString* mail = self.mailField.text;
    NSString* phone = self.phoneField.text;

    NSLog(@"Edited to: %@, %@, %@, %@,", prename, surname, mail, phone);
}

@end
