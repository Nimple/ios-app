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

static NSMutableDictionary *VCARD_TEMPLATE_DIC;

@interface NimpleCodeViewController ()

@end

@implementation NimpleCodeViewController
{
    BOOL        nimpleCodeExists;
    UIImage     *generatedCodeImage;
    NSString    *vCardTemplate;
    NSString    *vCardString;
    CGImageRef  result;
}

@synthesize editButton;
@synthesize editController;
@synthesize myNimpleCode;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)swipeHandlerRight:(UISwipeGestureRecognizer *)recognizer {
    //NSLog(@"Swipe received.");
    [self.tabBarController setSelectedIndex: 0];
    
    /*
     UIView * fromView = self.tabBarController.selectedViewController.view;
     UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:0] view];
     
     // Transition using a page curl.
     [UIView transitionFromView:fromView
     toView:toView
     duration:0.5
     options:UIViewAnimationOptionTransitionNone
     completion:^(BOOL finished) {
     if (finished) {
     self.tabBarController.selectedIndex = 0;
     }
     }];
     */
}


-(void)swipeHandlerLeft:(UISwipeGestureRecognizer *)recognizer {
    //NSLog(@"Swipe received.");
    [self.tabBarController setSelectedIndex: 2];
    
    /*
     UIView * fromView = self.tabBarController.selectedViewController.view;
     UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:2] view];
     
     // Transition using a page curl.
     [UIView transitionFromView:fromView
     toView:toView
     duration:0.5
     options:UIViewAnimationOptionTransitionNone
     completion:^(BOOL finished) {
     if (finished) {
     self.tabBarController.selectedIndex = 2;
     }
     }];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [myNimpleCode synchronize];
    self.myNimpleCode = [NSUserDefaults standardUserDefaults];
    
    VCARD_TEMPLATE_DIC = [NSMutableDictionary dictionary];
    [VCARD_TEMPLATE_DIC setObject:@"BEGIN:VCARD\nVERSION:3.0\n" forKey:@"vcard_header"];
    [VCARD_TEMPLATE_DIC setObject:@"N:%@;%@\n" forKey:@"vcard_name"];
    [VCARD_TEMPLATE_DIC setObject:@"TEL;CELL:%@\n" forKey:@"vcard_phone"];
    [VCARD_TEMPLATE_DIC setObject:@"EMAIL:%@\n" forKey:@"vcard_email"];
    [VCARD_TEMPLATE_DIC setObject:@"ROLE:%@\n" forKey:@"vcard_role"];
    [VCARD_TEMPLATE_DIC setObject:@"ORG:%@\n" forKey:@"vcard_organisation"];
    [VCARD_TEMPLATE_DIC setObject:@"X-FACEBOOK-ID:%@\n" forKey:@"vcard_facebook_id"];
    [VCARD_TEMPLATE_DIC setObject:@"X-TWITTER-ID:%@\n" forKey:@"vcard_twitter_id"];
    [VCARD_TEMPLATE_DIC setObject:@"URL:%@\n" forKey:@"vcard_url"];
    [VCARD_TEMPLATE_DIC setObject:@"END:VCARD" forKey:@"vcard_end"];
    
    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerRight:)];
    [gestureRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizerRight];
    
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerLeft:)];
    [gestureRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizerLeft];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangedNimpleCode:)
                                                 name:@"nimpleCodeChanged"
                                               object:nil];
    NSString* surname       = [myNimpleCode valueForKey:@"surname"];
    NSString* prename       = [myNimpleCode valueForKey:@"prename"];
    NSString* phone         = [self.myNimpleCode valueForKey:@"phone"];
    NSString* email         = [self.myNimpleCode valueForKey:@"email"];
    NSString* job           = [self.myNimpleCode valueForKey:@"job"];
    NSString* company       = [self.myNimpleCode valueForKey:@"company"];
    NSString* facebook_URL  = [self.myNimpleCode valueForKey:@"facebook_URL"];
    NSString* facebook_ID   = [self.myNimpleCode valueForKey:@"facebook_ID"];
    NSString* twitter_URL   = [self.myNimpleCode valueForKey:@"twitter_URL"];
    NSString* twitter_ID    = [self.myNimpleCode valueForKey:@"twitter_ID"];
    NSString* xing_URL      = [self.myNimpleCode valueForKey:@"xing_URL"];
    NSString* linkedin_URL  = [self.myNimpleCode valueForKey:@"linkedin_URL"];
    if( surname.length == 0 && prename.length == 0 && phone.length == 0 && email.length == 0 && job.length == 0 && company.length == 0 && facebook_ID.length == 0 && facebook_URL.length == 0 && twitter_ID.length == 0 &&
       twitter_URL.length == 0 && xing_URL.length == 0 && linkedin_URL.length == 0)
    {
        [self.nimpleQRCodeImage setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
    }
    else
    {
        [self.welcomeView setHidden:TRUE];
        [self.nimpleQRCodeImage setHidden:FALSE];
        [self updateQRCodeData];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.myNimpleCode synchronize];
    NSString* surname = [self.myNimpleCode valueForKey:@"surname"];
    NSString* prename = [self.myNimpleCode valueForKey:@"prename"];
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
        [self.nimpleQRCodeImage setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
    }
    else
    {
        [self.welcomeView setHidden:TRUE];
        [self.nimpleQRCodeImage setHidden:FALSE];
        [self updateQRCodeData];
    }
}

// Handles the nimpleCodeChanged notifaction
- (void)handleChangedNimpleCode:(NSNotification *)note {
    NSLog(@"Received changed Nimple Code @ Nimple CODE VIEW CONTROLLER");
    
    [self.myNimpleCode synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Fills the vcard with given data
/* Parameters in order of appearance
 0. surname
 1. prename
 2. phone
 3. email
 4. company
 5. job
 6. URL: facebook
 7. X-FACEBOOK-ID
 8. URL: twitter
 9. X-TWITTER-ID
 10. URL: xing
 11. URL: linkedin
 */
- (NSString*) fillVCardCardWithData:(NSArray*)p_data
{
    NSMutableString *filled = [NSMutableString stringWithString:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_header"]];

    if([NSString stringWithString:p_data[0]].length != 0 && [NSString stringWithString:p_data[1]].length != 0)
    {
        NSString *name = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_name"], p_data[0], p_data[1]];
        [filled appendString: name];
    }
    // phone
    if([NSString stringWithString:p_data[2]].length != 0 && [self.myNimpleCode boolForKey:@"phone_switch"])
    {
        NSString *phone = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_phone"], p_data[2]];
        [filled appendString: phone];
    }
    // email
    if([NSString stringWithString:p_data[3]].length != 0 && [self.myNimpleCode boolForKey:@"email_switch"])
    {
        NSString *email = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_email"], p_data[3]];
        [filled appendString: email];
    }
    // company
    if([NSString stringWithString:p_data[4]].length != 0 && [self.myNimpleCode boolForKey:@"company_switch"])
    {
        NSString *company = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_organisation"], p_data[4]];
        [filled appendString: company];
    }
    // job
    if([NSString stringWithString:p_data[5]].length != 0 && [self.myNimpleCode boolForKey:@"job_switch"])
    {
        NSString *job = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_role"], p_data[5]];
        [filled appendString: job];
    }
    // facebook
    if([NSString stringWithString:p_data[6]].length != 0 && [NSString stringWithString:p_data[7]].length != 0 && [self.myNimpleCode boolForKey:@"facebook_switch"])
    {
        NSString *facebook_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[6]];
        NSString *facebook_ID = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_facebook_id"], p_data[7]];
        [filled appendString: facebook_URL];
        [filled appendString: facebook_ID];
    }
    // twitter
    if([NSString stringWithString:p_data[8]].length != 0 && [NSString stringWithString:p_data[9]].length != 0 && [self.myNimpleCode boolForKey:@"twitter_switch"])
    {
        NSString *twitter_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[8]];
        NSString *twitter_ID = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_twitter_id"], p_data[9]];
        [filled appendString: twitter_URL];
        [filled appendString: twitter_ID];
    }
    // xing
    if([NSString stringWithString:p_data[10]].length != 0 && [self.myNimpleCode boolForKey:@"xing_switch"])
    {
        NSString *xing_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[10]];
        [filled appendString: xing_URL];
    }
    // linkedin
    if([NSString stringWithString:p_data[11]].length != 0 && [self.myNimpleCode boolForKey:@"linkedin_switch"])
    {
        NSString *linkedin_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[11]];
        [filled appendString: linkedin_URL];
    }
    [filled appendString:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_end"]];
    
    return filled;
}

// Update the QR code data
-(void) updateQRCodeData
{
    
    [self generateNimpleQRCodeSurname:[self.myNimpleCode valueForKey:@"surname"] Prename:[self.myNimpleCode valueForKey:@"prename"] Phone:[self.myNimpleCode valueForKey:@"phone"] Mail:[self.myNimpleCode valueForKey:@"email"] JobTitle:[self.myNimpleCode valueForKey:@"job"] CompanyName:[self.myNimpleCode valueForKey:@"company"] FacebookURL:[self.myNimpleCode valueForKey:@"facebook_URL"] FacebookID:[self.myNimpleCode valueForKey:@"facebook_ID"] TwitterURL:[self.myNimpleCode valueForKey:@"twitter_URL"] TwitterID:[self.myNimpleCode valueForKey:@"twitter_ID"] XingURL:[self.myNimpleCode valueForKey:@"xing_URL"] LinkedInURL:[self.myNimpleCode valueForKey:@"linkedin_URL"]];
}

//
- (void) updateQRCodeImage
{
    generatedCodeImage  = [UIImage imageWithCGImage:result scale:1.0 orientation: UIImageOrientationUp];
    //NSLog(@"QRCode size is: (%f, %f)", generatedCodeImage.size.width, generatedCodeImage.size.height);
    
    UIImage *resized = [self resizeImage:generatedCodeImage withQuality:kCGInterpolationNone rate:5.0];
    //NSLog(@"QRCode size after resizing is: (%f, %f)", resized.size.width, resized.size.height);
    
    // free memory
    CGImageRelease(result);
    
    self.nimpleQRCodeImage.image = resized;
}

// Resizes image properly
- (UIImage *)resizeImage:(UIImage *)image withQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate
{
	UIImage *resized = nil;
	CGFloat width = image.size.width * rate;
	CGFloat height = image.size.height * rate;
    
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context, quality);
	[image drawInRect:CGRectMake(0, 0, width, height)];
	resized = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return resized;
}

// Generates a nimple QR code with given parameters
- (void) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail JobTitle:(NSString*)p_job CompanyName:(NSString*)p_company FacebookURL:(NSString*)p_facebookURL FacebookID:(NSString*)p_facebookID TwitterURL:(NSString*)p_twitterURL TwitterID:(NSString*)p_twitterID XingURL:(NSString*)p_xingURL LinkedInURL:(NSString *)p_linkedinURL
{
    NSArray *vcard_data = [NSArray arrayWithObjects:p_surname, p_prename, p_phone, p_mail, p_company, p_job, p_facebookURL, p_facebookID, p_twitterURL, p_twitterID, p_xingURL, p_linkedinURL, nil];
    
    NSLog(@"count = %@", vcard_data);
    
    // Fill vcard template & create NSData for QRCode generation
    NSString *asciiString = [self fillVCardCardWithData:vcard_data];
    //NSLog(@"\"%@\" - Length: %ld", asciiString, (long)[asciiString length]);
    NSData *asciiData = [asciiString dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"Data length: %ld", (unsigned long)[asciiData length]);
    
    // Create core image context & filter and set properties
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:asciiData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // Get generated QRCode and convert to UIImage
    CIImage *output   = [filter valueForKey:kCIOutputImageKey];
    result = [context createCGImage:output fromRect:[output extent]];
    
    [self updateQRCodeImage];
}

// Prepare the segue
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Edit nimple code saved
- (void)editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
