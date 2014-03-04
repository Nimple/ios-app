//
//  NimpleCodeViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NimpleCodeViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *nimpleQRCodeImage;

- (UIImage*) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail;
- (void) SetQRCodeImageSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail;
- (void) updateQRCodeImageSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail;

@end