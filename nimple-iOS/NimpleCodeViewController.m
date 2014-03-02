//
//  NimpleCodeViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCodeViewController.h"

@interface NimpleCodeViewController ()

@end

@implementation NimpleCodeViewController
{
    BOOL        nimpleCodeExists;
    UIImage     *generatedCodeImage;
    NSString    *vCardTemplate;
    NSString    *vCardString;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"NimpleCodeViewLoaded");
    [self updateQRCodeImageSurname:@"init" Prename:@"init" Phone:@"init" Mail:@"init"];
}

- (void) updateQRCodeImageSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail {
    
    generatedCodeImage = [self generateNimpleQRCodeSurname:p_surname Prename:p_prename Phone:p_phone Mail:p_mail];
    self.nimpleQRCodeImage.image = generatedCodeImage;
    nimpleCodeExists = true;
}


- (void) SetQRCodeImageSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail {
    
    generatedCodeImage = [self generateNimpleQRCodeSurname:p_surname Prename:p_prename Phone:p_phone Mail:p_mail];
    if(generatedCodeImage)
        NSLog(@"QRCode image generated successfull");
    [self.nimpleQRCodeImage setImage: generatedCodeImage];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated {

}


- (UIImage*) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail{
    
    // 1. Surname
    // 2. Prename
    // 3. Cellphone
    // 4. Mail
    // 5. facebook
    // 6. twitter
    vCardTemplate = @"BEGIN:VCARD\nN:%@;%@\nTEL;Cell:%@\nEMAIL;Internet:%@\nURL:%@\nURL:%@\nEND:VCARD";
    
    // Fill vcard template & create NSData for QRCode generation
    NSString *asciiString = [NSString stringWithFormat:vCardTemplate, p_surname, p_prename, p_phone, p_mail, @"www.facebook.de/nimple", @"twitter.de/nimple"];
    NSLog(@"\"%@\" - Length: %ld", asciiString, (long)[asciiString length]);
    NSData *asciiData = [asciiString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Data length: %ld", (unsigned long)[asciiData length]);
    
    // Create core image context & filter and set properties
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:asciiData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Log the filter
    NSLog(@"%@: %@", filter.name, filter.description);
    
    // Get generated QRCode and convert to UIImage
    CIImage *result     = [filter valueForKey:kCIOutputImageKey];
    generatedCodeImage  = [[UIImage alloc] initWithCIImage:result];
    
    NSLog(@"QRCode size is: (%f, %f)", generatedCodeImage.size.width, generatedCodeImage.size.height);
    
    return generatedCodeImage;
}

@end
