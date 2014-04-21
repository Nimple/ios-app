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

{
    BOOL isProcessing;
}

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
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Kontakt gefunden"
                                     message:@"Der Kontakt wurde deinen Kontakten hinzugefügt"
                                     delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    
    self.alertView2 = [[UIAlertView alloc] initWithTitle:@"Fehlerhafter Code"
                                                message:@"Der nimple-code konnte nicht gescannt werden."
                                               delegate:self
                                      cancelButtonTitle:@"Zurück"
                                      otherButtonTitles:nil];

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.tabBarController setSelectedIndex: 2];
        [[self navigationController] popViewControllerAnimated:YES];
    }
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
    /*
    if (!_isReading) {
        [self startReading];
    }
    else{
        [self stopReading];
    }
    _isReading = !_isReading;
     */
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
    _videoPreviewLayer.drawsAsynchronously = TRUE;
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_codeReaderCameraView.layer.bounds];
    [_codeReaderCameraView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

// Get the QRcode output
-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // check for current processing
    if(isProcessing) {
        return;
    }
    
    // Valid bar code found
    if (metadataObjects != nil && [metadataObjects count] == 1)
    {
        isProcessing = TRUE;
        
        // Stop the bar code reader
        [self stopReading];
        
        // Valid QRCode found
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
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
                
                NSLog(@"Tokenize VCARD:");
                lines = [qrCodeData componentsSeparatedByString:@"\n"];
                
                NSLog(@"%lu lines found in vCard", (unsigned long)[lines count]);
                NSLog(@"Lines are %@", lines);
                
                for(NSString *line in lines) {
                    // in order to have a clean db entry
                    NSString *newLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if(newLine.length < 3) {
                        continue;
                    }
                    
                    if([newLine hasPrefix:@"N:"]) {
                        newLine = [newLine substringFromIndex:2];
                        NSArray *names = [newLine componentsSeparatedByString:@";"];
                        contactData[0] = names[0];
                        contactData[1] = names[1];
                    } else if ([newLine hasPrefix:@"EMAIL"]) {
                        NSString *email = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
                        contactData[3] = email;
                    } else if ([newLine hasPrefix:@"TEL"]) {
                        NSString *telehone = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
                        contactData[2] = telehone;
                    } else if ([newLine hasPrefix:@"ORG:"]) {
                        // handle organisation
                        // take care of multiple units
                        NSString *company = [newLine substringFromIndex:4];
                        
                        if ([newLine rangeOfString:@";"].location != NSNotFound) {
                            NSArray *orgs = [company componentsSeparatedByString:@";"];
                            
                            for(NSString *org in orgs) {
                                [contactData[5] appendString:[NSString stringWithFormat:@"%@%@", org, @"\n"]];
                            }
                        } else {
                            contactData[5] = company;
                        }
                    } else if ([newLine hasPrefix:@"ROLE"]) {
                        NSString *role = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
                        contactData[4] = role;
                    } else if ([newLine hasPrefix:@"URL"]) {
                        NSString *url = [newLine substringFromIndex:4];
                        
                        // parse urls
                        if([newLine rangeOfString:@"facebook"].location != NSNotFound) {
                            contactData[6] = url;
                        } else if([newLine rangeOfString:@"twitter"].location != NSNotFound) {
                            contactData[8] = url;
                        } else if([newLine rangeOfString:@"xing"].location != NSNotFound) {
                            contactData[10] = url;
                        } else if([newLine rangeOfString:@"linkedin"].location != NSNotFound) {
                            contactData[11] = url;
                        }
                    } else if ([newLine hasPrefix:@"X-FACEBOOK-ID:"]) {
                        contactData[7] = [newLine substringFromIndex:14];
                    } else if ([newLine hasPrefix:@"X-TWITTER-ID:"]) {
                        contactData[9] = [newLine substringFromIndex:13];
                    } else if ([newLine hasPrefix:@"END:VCARD"]) {
                        break;
                    } else {
                        // unrecognized line;
                    }
                }
                
                // check for at least name
                if([contactData[0] length] == 0 || [contactData[1] length] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.alertView2 show];
                    });
                    
                    return;
                }
                
                NSLog(@"Contact found: %@", contactData);
                capturedContactData = contactData;
                [self saveToDataBase];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alertView show];
                });
            }
        } else {
            // No valid QRCode found
            NSLog(@"ERROR! No valid QRCode found!");
        }
    }
}

//
-(void) saveToDataBase
{
     NSManagedObjectContext *context = [self managedObjectContext];
     NimpleContact *scannedContact = [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact" inManagedObjectContext:context];
    
    [scannedContact setValueForPrename:capturedContactData[0] Surname:capturedContactData[1] PhoneNumber:capturedContactData[2] MailAddress:capturedContactData[3] JobTitle:capturedContactData[4] Company:capturedContactData[5] FacebookURL:capturedContactData[6] FacebookID:capturedContactData[7] TwitterURL:capturedContactData[8] TwitterID:capturedContactData[9] XingURL:capturedContactData[10] LinkedInURL:capturedContactData[11] Created:[NSDate date]];
    
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
