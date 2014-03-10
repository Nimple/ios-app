//
//  NimpleCodeReaderController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "BarCodeReaderController.h"
#import "NimpleContact.h"

@interface BarCodeReaderController ()

@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
-(BOOL)startReading;
-(void)stopReading;

@end

@implementation BarCodeReaderController
{
    AVCaptureSession *mCaptureSession;
    NSMutableString *mCode;
}

@synthesize managedObjectContext;
@synthesize capturedContactData;


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
    _isReading = FALSE;
    _captureSession = nil;
    
    [self startReading];
}

// Starts the capture session when the view is currently presented
- (void) viewDidAppear:(BOOL)animated {
    [self startReading];
}

// Stops the capture session when the view is not presented
- (void) viewWillDisappear:(BOOL)animated {
    [self stopReading];
}

// Stops the capture session when the view will be undloaded from memory
- (void) viewWillUnload {
    [self stopReading];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Toggles the capture session
- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        [self startReading];
    }
    else{
        [self stopReading];
    }
    _isReading = !_isReading;
}

// Starts the capture session
- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_codeReaderCameraView.layer.bounds];
    [_codeReaderCameraView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

// Get the QRcode output
-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // Valid bar code found
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        // Valid QRCode found
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            //[self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        
            // Stop the bar code reader
            [self stopReading];
            
            // Get data from vcard string
            NSString *qrCodeData = metadataObj.stringValue;
            // Look for vcard defintion string
            NSRange rangeValue = [qrCodeData rangeOfString:@"BEGIN:VCARD" options:NSCaseInsensitiveSearch];
            if (rangeValue.location == NSNotFound)
            {
                NSLog(@"ERROR! No valid vCard found!");
                [NSException raise:@"No vcard found" format:@"No valid vcard defintion found in string %@ ", qrCodeData];
            }
            else
            {
                NSLog(@"Valid vCard found!");
                NSMutableArray *contactData = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
                NSArray        *lines       = [[NSArray alloc] init];
                NSString       *url;
                
                NSLog(@"Tokenize VCARD:");
                lines = [qrCodeData componentsSeparatedByString:@"\n"];
                
                NSLog(@"%lu lines found in vCard", (unsigned long)[lines count]);
                NSLog(@"Lines are %@", lines);
                
                for(NSString *line in lines)
                {
                    NSArray *keyValuePair = [line componentsSeparatedByString:@":"];
                    // Skip first two vcard entires
                    if([keyValuePair[0] isEqualToString:@"BEGIN"] |
                       [keyValuePair[0] isEqualToString:@"VERSION"])
                    {
                        continue;
                    }
                    // End found
                    NSRange endFound = [line rangeOfString:@"END:VCARD"];
                    if(endFound.location != NSNotFound)
                        break;
                    
                    // Check if vcard entry is URL
                    if([keyValuePair[0] isEqualToString:@"URL"])
                    {
                        NSString *cleanURL = [keyValuePair[2] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                        // URLs have to concatened because they have another ':' at http://
                        url = [NSString stringWithFormat:@"%@:%@", keyValuePair[1], cleanURL];
                        // facebook URL
                        if([url rangeOfString:@"facebook"].location != NSNotFound)
                            contactData[6] = url;
                        // twitter URL
                        if([url rangeOfString:@"twitter"].location != NSNotFound)
                            contactData[8] = url;
                        // xing URL
                        if([url rangeOfString:@"xing"].location != NSNotFound)
                            contactData[10] = url;
                        // linkedin URL
                        if([url rangeOfString:@"linkedin"].location != NSNotFound)
                            contactData[11] = url;
                    }
                    
                    // Name
                    if([keyValuePair[0] isEqualToString:@"N"])
                    {
                        // Seperate sur- and prename and add them to contact data
                        NSArray  *fullName = [keyValuePair[1] componentsSeparatedByString:@";"];
                        contactData[0] = fullName[1];
                        contactData[1] = fullName[0];
                    }
                    // Telephone
                    NSRange telephoneFound = [keyValuePair[0] rangeOfString:@"TEL"];
                    if(telephoneFound.location != NSNotFound)
                    {
                        contactData[2] = keyValuePair[1];
                    }
                    // Email
                    if([keyValuePair[0] isEqualToString:@"EMAIL"])
                    {
                        contactData[3] = keyValuePair[1];
                    }
                    // Job Title
                    if([keyValuePair[0] isEqualToString:@"ROLE"])
                    {
                        contactData[4] = keyValuePair[1];
                    }
                    // Company
                    if([keyValuePair[0] isEqualToString:@"ORG"])
                    {
                        contactData[5] = keyValuePair[1];
                    }
                    // facebook
                    if([keyValuePair[0] isEqualToString:@"X-FACEBOOK-ID"])
                    {
                        contactData[7] = keyValuePair[1];
                    }
                    // twitter
                    if([keyValuePair[0] isEqualToString:@"X-TWITTER-ID"])
                    {
                        contactData[9] = keyValuePair[1];
                    }
                }
                
                NSLog(@"Contact found: %@", contactData);
                capturedContactData = contactData;
                [self saveToDataBase];
            }
        }
        // No valid QRCode found
        else
        {
            NSLog(@"ERROR! No valid QRCode found!");
        }
    }
}

-(void) saveToDataBase
{
     NSManagedObjectContext *context = [self managedObjectContext];
     NimpleContact *scannedContact = [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact" inManagedObjectContext:context];
    
    [scannedContact setValueForPrename:capturedContactData[0] Surname:capturedContactData[1] PhoneNumber:capturedContactData[2] MailAddress:capturedContactData[3] JobTitle:capturedContactData[4] Company:capturedContactData[5] FacebookURL:capturedContactData[6] FacebookID:capturedContactData[7] TwitterURL:capturedContactData[8] TwitterID:capturedContactData[9] XingURL:capturedContactData[10] LinkedInURL:capturedContactData[11]];
    
     NSError *error;
     [context save:&error];
    NSLog(@"Contact successfully saved to database!");
}

// Stops the capture session
-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

@end
