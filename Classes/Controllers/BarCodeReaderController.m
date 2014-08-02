//
//  NimpleCodeReaderController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "BarCodeReaderController.h"
#import "NimpleContact.h"
#import "VCardParser.h"
#import "Crypto.h"
#import "Logging.h"
#import "NimpleContactPersistenceManager.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = FALSE;
    _captureSession = nil;
    [self startReading];
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"msg_box_right_code_header")
                                                message:NimpleLocalizedString(@"msg_box_right_code_text")
                                               delegate:self
                                      cancelButtonTitle:NimpleLocalizedString(@"msg_box_right_code_activity")
                                      otherButtonTitles:nil];
    
    self.alertView2 = [[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"msg_box_wrong_code_header")
                                                 message:NimpleLocalizedString(@"msg_box_wrong_code_header")
                                                delegate:self
                                       cancelButtonTitle:NimpleLocalizedString(@"msg_box_wrong_code_activity")
                                       otherButtonTitles:nil];
    
    self.alertView3 = [[UIAlertView alloc] initWithTitle:nil
                                                 message:NimpleLocalizedString(@"msg_box_duplicated_contact_title")
                                                delegate:self
                                       cancelButtonTitle:NimpleLocalizedString(@"msg_box_duplicated_code_activity")
                                       otherButtonTitles:nil];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self.tabBarController setSelectedIndex: 2];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Stops the capture session when the view will be undloaded from memory
- (void) viewWillUnload {
    [self stopReading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (metadataObjects != nil && [metadataObjects count] == 1) {
        isProcessing = TRUE;
        
        // Stop the bar code reader
        [self stopReading];
        
        // Valid QRCode found
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // Get data from vcard string
            NSString *qrCodeData = metadataObj.stringValue;
            
            // Look for vcard defintion string
            NSRange rangeValue = [qrCodeData rangeOfString:@"BEGIN:VCARD" options:NSCaseInsensitiveSearch];
            if (rangeValue.location == NSNotFound) {
                NSLog(@"ERROR! No valid vCard found!");
                [NSException raise:@"No vcard found" format:@"No valid vcard definition found in string %@ ", qrCodeData];
            } else {
                NSLog(@"Valid vCard found!");
                NSMutableArray *contactData = [VCardParser getContactFromCard:qrCodeData];
                
                // check for at least name
                if([contactData[0] length] == 0 || [contactData[1] length] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.alertView2 show];
                    });
                    
                    return;
                }
                
                NSString* contactHash = [Crypto calculateMd5OfString:metadataObj.stringValue];
                capturedContactData = contactData;
                
                [self saveToDataBase:contactHash];
            }
        } else {
            // No valid QRCode found
            NSLog(@"ERROR! No valid QRCode found!");
        }
    }
}

// Save the scanned contact to database
-(void) saveToDataBase:(NSString*)contactHash {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"NimpleContact" inManagedObjectContext:managedObjectContext];
    fetch.predicate = [NSPredicate predicateWithFormat:@"contactHash == %@", contactHash];
    NSArray *array = [managedObjectContext executeFetchRequest:fetch error:nil];
    
    if(array.count == 0) {
        NimpleContact* nimpleContact = [[NimpleContactPersistenceManager getInstance:managedObjectContext] saveNimpleContactWith:capturedContactData andContactHash:contactHash];
        [Logging sendContactAddedEvent:nimpleContact];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView show];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView3 show];
        });
    }
}

// Stops the capture session
-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

@end
