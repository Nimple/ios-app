//
//  NimpleCodeViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditNimpleCodeTableViewController.h"

@interface NimpleCodeViewController : UIViewController<EditNimpleCodeTableControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem                     *editButton;
@property (retain, nonatomic) IBOutlet UIImageView                       *nimpleQRCodeImage;
@property (retain, nonatomic) IBOutlet EditNimpleCodeTableViewController *editController;
@property (atomic, strong) NSUserDefaults                                *myNimpleCode;

- (void) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail JobTitle:(NSString*)p_job CompanyName:(NSString*)p_company TwitterURL:(NSString*)p_twitterURL;
- (NSString*) fillVCardCardWithData:(NSArray*)p_data;
- (void) updateQRCodeImage;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;

@end