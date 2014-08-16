//
//  NimpleCodeViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCodeViewController.h"
#import "BarCodeReaderController.h"

static NSMutableDictionary *VCARD_TEMPLATE_DIC;

@interface NimpleCodeViewController () {
    __weak IBOutlet UILabel *_tutorialAddLabel;
    __weak IBOutlet UILabel *_tutorialEditLabel;
    __weak IBOutlet UINavigationItem *_navigationLabel;
    __weak IBOutlet UILabel *_barcodeNoteLabel;
    
    NimpleCode *_code;
}
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code = [NimpleCode sharedCode];
    [self setupNotificationCenter];
    [self localizeViewAttributes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateView];
}

- (void)setupNotificationCenter
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(handleChangedNimpleCode:) name:@"nimpleCodeChanged" object:nil];
}

-(void)localizeViewAttributes
{
    _tutorialAddLabel.text = NimpleLocalizedString(@"tutorial_add_text");
    _tutorialEditLabel.text = NimpleLocalizedString(@"tutorial_edit_text");
    _navigationLabel.title = NimpleLocalizedString(@"nimple_code_title");
    _barcodeNoteLabel.text = NimpleLocalizedString(@"nimple_code_footer");
}

- (void)updateView
{
    VCARD_TEMPLATE_DIC = [NSMutableDictionary dictionary];
    [VCARD_TEMPLATE_DIC setObject:@"BEGIN:VCARD\nVERSION:3.0\n" forKey:@"vcard_header"];
    [VCARD_TEMPLATE_DIC setObject:@"N:%@;%@\n" forKey:@"vcard_name"];
    [VCARD_TEMPLATE_DIC setObject:@"TEL;CELL:%@\n" forKey:@"vcard_phone"];
    [VCARD_TEMPLATE_DIC setObject:@"EMAIL:%@\n" forKey:@"vcard_email"];
    [VCARD_TEMPLATE_DIC setObject:@"TITLE:%@\n" forKey:@"vcard_role"];
    [VCARD_TEMPLATE_DIC setObject:@"ORG:%@\n" forKey:@"vcard_organisation"];
    [VCARD_TEMPLATE_DIC setObject:@"ADR;type=HOME:%@\n" forKey:@"vcard_address"];
    [VCARD_TEMPLATE_DIC setObject:@"X-FACEBOOK-ID:%@\n" forKey:@"vcard_facebook_id"];
    [VCARD_TEMPLATE_DIC setObject:@"X-TWITTER-ID:%@\n" forKey:@"vcard_twitter_id"];
    [VCARD_TEMPLATE_DIC setObject:@"URL:%@\n" forKey:@"vcard_url"];
    [VCARD_TEMPLATE_DIC setObject:@"END:VCARD" forKey:@"vcard_end"];
    
    NSString* surname       = _code.surname;
    NSString* prename       = _code.prename;
    NSString* phone         = _code.cellPhone;
    NSString* email         = _code.email;
    NSString* job           = _code.job;
    NSString* company       = _code.company;
    NSString* facebook_URL  = _code.facebookUrl;
    NSString* facebook_ID   = _code.facebookId;
    NSString* twitter_URL   = _code.twitterUrl;
    NSString* twitter_ID    = _code.twitterId;
    NSString* xing_URL      = _code.xing;
    NSString* linkedin_URL  = _code.linkedIn;
    if (surname.length == 0 && prename.length == 0 && phone.length == 0 && email.length == 0 && job.length == 0 && company.length == 0 && facebook_ID.length == 0 && facebook_URL.length == 0 && twitter_ID.length == 0 && twitter_URL.length == 0 && xing_URL.length == 0 && linkedin_URL.length == 0) {
        [self.nimpleQRCodeImage setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
        _barcodeNoteLabel.hidden = YES;
    } else {
        [self.welcomeView setHidden:TRUE];
        [self.nimpleQRCodeImage setHidden:FALSE];
        [self updateQRCodeData];
        _barcodeNoteLabel.hidden = NO;
    }
}

- (void)handleChangedNimpleCode:(NSNotification *)note {
    NSLog(@"Nimple code changed received in NimpleCodeViewController");
    [self.nimpleQRCodeImage setAlpha:0.0];
    [self updateQRCodeData];
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
    if([NSString stringWithString:p_data[2]].length != 0 && _code.cellPhoneSwitch)
    {
        NSString *phone = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_phone"], p_data[2]];
        [filled appendString: phone];
    }
    // email
    if([NSString stringWithString:p_data[3]].length != 0 && _code.emailSwitch)
    {
        NSString *email = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_email"], p_data[3]];
        [filled appendString: email];
    }
    // company
    if([NSString stringWithString:p_data[4]].length != 0 && _code.companySwitch)
    {
        NSString *company = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_organisation"], p_data[4]];
        [filled appendString: company];
    }
    // job
    if([NSString stringWithString:p_data[5]].length != 0 && _code.jobSwitch)
    {
        NSString *job = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_role"], p_data[5]];
        [filled appendString: job];
    }
    // facebook
    if([NSString stringWithString:p_data[6]].length != 0 && [NSString stringWithString:p_data[7]].length != 0 && _code.facebookSwitch)
    {
        NSString *facebook_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[6]];
        NSString *facebook_ID = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_facebook_id"], p_data[7]];
        [filled appendString: facebook_URL];
        [filled appendString: facebook_ID];
    }
    // twitter
    if([NSString stringWithString:p_data[8]].length != 0 && [NSString stringWithString:p_data[9]].length != 0 && _code.twitterSwitch)
    {
        NSString *twitter_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[8]];
        NSString *twitter_ID = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_twitter_id"], p_data[9]];
        [filled appendString: twitter_URL];
        [filled appendString: twitter_ID];
    }
    // xing
    if([NSString stringWithString:p_data[10]].length != 0 && _code.xingSwitch)
    {
        NSString *xing_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[10]];
        [filled appendString: xing_URL];
    }
    // linkedin
    if([NSString stringWithString:p_data[11]].length != 0 && _code.linkedInSwitch)
    {
        NSString *linkedin_URL = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[11]];
        [filled appendString: linkedin_URL];
    }
    
    // address
    //;;Werderstr. 10;Mannheim;;68165;   12/13/14
    if([NSString stringWithString:p_data[12]].length != 0 && [NSString stringWithString:p_data[13]].length != 0 && [NSString stringWithString:p_data[14]].length != 0 && _code.addressSwitch)
    {
        NSString *address = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_address"], [NSString stringWithFormat:@";;%@;%@;;%@;", p_data[12], p_data[13], p_data[14]]];
        [filled appendString:address];
    }
    
    // website
    if([NSString stringWithString:p_data[15]].length != 0 && _code.websiteSwitch)
    {
        NSString *website = [NSString stringWithFormat:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_url"], p_data[15]];
        [filled appendString:website];
    }

    [filled appendString:[VCARD_TEMPLATE_DIC valueForKey:@"vcard_end"]];
    return filled;
}

// Update the QR code data
-(void) updateQRCodeData
{
    [self generateNimpleQRCodeSurname:_code.surname Prename:_code.prename Phone:_code.cellPhone Mail:_code.email JobTitle:_code.job CompanyName:_code.company FacebookURL:_code.facebookUrl FacebookID:_code.facebookId TwitterURL:_code.twitterUrl TwitterID:_code.twitterId XingURL:_code.xing LinkedInURL:_code.linkedIn withStreet:_code.addressStreet andPostal:_code.addressPostal andCity:_code.addressCity andWebsite:_code.website];
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
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 1.3];
    
    [self.nimpleQRCodeImage setAlpha: 1.0];
    
    [UIView commitAnimations];
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
- (void) generateNimpleQRCodeSurname:(NSString*)p_surname Prename:(NSString*)p_prename Phone:(NSString*)p_phone Mail:(NSString*)p_mail JobTitle:(NSString*)p_job CompanyName:(NSString*)p_company FacebookURL:(NSString*)p_facebookURL FacebookID:(NSString*)p_facebookID TwitterURL:(NSString*)p_twitterURL TwitterID:(NSString*)p_twitterID XingURL:(NSString*)p_xingURL LinkedInURL:(NSString *)p_linkedinURL withStreet:(NSString*)p_street andPostal:(NSString*)p_postal andCity:(NSString*)p_city andWebsite:(NSString*)p_website
{
    NSArray *vcard_data = [NSArray arrayWithObjects:p_surname, p_prename, p_phone, p_mail, p_company, p_job, p_facebookURL, p_facebookID, p_twitterURL, p_twitterID, p_xingURL, p_linkedinURL, p_street, p_postal, p_city, p_website, nil];
    
    // NSLog(@"count = %@", vcard_data);
    
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
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    
    // Get generated QRCode and convert to UIImage
    CIImage *output   = [filter valueForKey:kCIOutputImageKey];
    result = [context createCGImage:output fromRect:[output extent]];
    
    [self updateQRCodeImage];
}

// Prepare the segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        EditNimpleCodeTableViewController *editNimpleCodeController = segue.destinationViewController;
        editNimpleCodeController.delegate = self;
    }
}

#pragma mark - EditNimpleCodeTableControllerDelegate

// Edit nimple code saved
- (void)editNimpleCodeTableViewControllerDidSave:(EditNimpleCodeTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
