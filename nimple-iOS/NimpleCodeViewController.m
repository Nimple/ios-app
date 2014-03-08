//
//  NimpleCodeViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCodeViewController.h"

// Static template for generating vCards
static NSString *VCARD_TEMPLATE = @"BEGIN:VCARD\nVERSION:3.0\nN:%@;%@\nTEL;CELL:%@\nEMAIL:%@\nORG:%@\nROLE:%@\nURL:%@\nX-FACEBOOK-ID:%@\nURL:%@\nX-TWITTER-ID:%@\nURL:%@\nURL:%@\nEND:VCARD";

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
@synthesize editController;

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
    [self updateQRCodeImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Fills the vcard with given data
/* Parameters in order of appearance
  1. surname
  2. prename
  3. phone
  4. email
  5. company
  6. job
  7. URL: facebook
  8. X-FACEBOOK-ID
  9. URL: twitter
 10. X-TWITTER-ID
 11. URL: xing
 12. URL: linkedin
 */
- (NSString*) fillVCardCardWithData:(NSArray*)p_data
{
    return [NSString stringWithFormat:VCARD_TEMPLATE, p_data[0], p_data[1], p_data[2], p_data[3], p_data[4], p_data[5], p_data[6], p_data[7], p_data[8], p_data[9], p_data[10], p_data[11]];
}

//
- (void) updateQRCodeImage
{
    generatedCodeImage  = [[UIImage alloc] initWithCIImage:result scale:100.0f orientation: UIImageOrientationUp];
    self.nimpleQRCodeImage.image = generatedCodeImage;
}

// Generates a nimple QR code with given parameters
- (void) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail
{
    NSArray *vcard_data = [NSArray arrayWithObjects:@"surname", @"prename", @"phone", @"email", @"company", @"job", @"facebookURL", @"facebookID", @"twitterURL", @"twitterID", @"xingURL", @"linkedinURL", nil];
    
    NSLog(@"VCARD, %i",[vcard_data count]);
    
    // Fill vcard template & create NSData for QRCode generation
    NSString *asciiString = [self fillVCardCardWithData:vcard_data];
    NSLog(@"\"%@\" - Length: %ld", asciiString, (long)[asciiString length]);
    NSData *asciiData = [asciiString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Data length: %ld", (unsigned long)[asciiData length]);
    
    // Create core image context & filter and set properties
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:asciiData forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    // Log the filter
    //NSLog(@"%@: %@", filter.name, filter.description);
    
    // Get generated QRCode and convert to UIImage
    CIImage *filtered   = [filter valueForKey:kCIOutputImageKey];
    result              = [filtered imageByCroppingToRect:CGRectMake(0, 0, self.nimpleQRCodeImage.bounds.size.width*20.0, self.nimpleQRCodeImage.bounds.size.height*20.0)];
    generatedCodeImage  = [[UIImage alloc] initWithCIImage:result scale:100.0f orientation: UIImageOrientationUp];
    
    NSLog(@"QRCode size is: (%f, %f)", generatedCodeImage.size.width, generatedCodeImage.size.height);
    
    [self updateQRCodeImage];
}

//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        EditNimpleCodeTableViewController *editNimpleCodeController = [navigationController viewControllers][0];
        editNimpleCodeController.delegateCode = self;
    }
}

#pragma mark - EditNimpleCodeTableControllerDelegate

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
