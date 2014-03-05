//
//  NimpleCodeViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

// return true if the device has a retina display, false otherwise
#define IS_RETINA_DISPLAY() [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 10.0f

// return the scale value based on device's display (2 retina, 1 other)
#define DISPLAY_SCALE IS_RETINA_DISPLAY() ? 10.0f : 5.0f

// if the device has a retina display return the real scaled pixel size, otherwise the same size will be returned
#define PIXEL_SIZE(size) IS_RETINA_DISPLAY() ? CGSizeMake(size.width/10.0f, size.height/10.0f) : size

#import "NimpleCodeViewController.h"

@interface NimpleCodeViewController ()

@end

@implementation NimpleCodeViewController
{
    BOOL        nimpleCodeExists;
    UIImage     *generatedCodeImage;
    NSString    *vCardTemplate;
    NSString    *vCardString;
    CIImage     *result;
}

@synthesize editButton;

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
    
    [self generateNimpleQRCodeSurname:@"init" Prename:@"init" Phone:@"init" Mail:@"init"];
    [self UpdateQRCodeImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
- (void) UpdateQRCodeImage
{
    generatedCodeImage  = [[UIImage alloc] initWithCIImage:result scale:20.0f orientation: UIImageOrientationUp];
    self.nimpleQRCodeImage.image = generatedCodeImage;
}

// Generates a nimple QR code with given parameters
- (UIImage*) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail{
    
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
    //NSLog(@"%@: %@", filter.name, filter.description);
    
    // Get generated QRCode and convert to UIImage
    result     = [filter valueForKey:kCIOutputImageKey];
    generatedCodeImage  = [[UIImage alloc] initWithCIImage:result scale:100.0f orientation: UIImageOrientationUp];
    
    NSLog(@"QRCode size is: (%f, %f)", generatedCodeImage.size.width, generatedCodeImage.size.height);
    
    return generatedCodeImage;
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

#pragma mark - PlayerDetailsViewControllerDelegate

// Edit nimple code canceled
- (void)editNimpleCodeTableViewControllerDidCancel:(EditNimpleCodeTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Edit nimple code saved
- (void)editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController *)controller
{
    NSString* prename = [controller.myNimpleCode valueForKey:@"prename"];
    NSString* surname = [controller.myNimpleCode valueForKey:@"surname"];
    NSString* phone   = [controller.myNimpleCode valueForKey:@"phone"];
    NSString* email   = [controller.myNimpleCode valueForKey:@"email"];
    NSString* job     = [controller.myNimpleCode valueForKey:@"job"];
    NSString* company = [controller.myNimpleCode valueForKey:@"company"];
    [self generateNimpleQRCodeSurname:surname Prename:prename Phone:phone Mail:email];
    [self UpdateQRCodeImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
