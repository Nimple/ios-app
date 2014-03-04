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
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];

        // Log to console
        //NSLog(@"\nQR VALUE:\n%@", [metadataObj stringValue]);
        
        // Get data from vcard string
        NSString *vCardString = metadataObj.stringValue;
        
        //@"BEGIN:VCARD\nN:%@;%@\nTEL;Cell:%@\nEMAIL;Internet:%@\nURL:%@\nURL:%@\nEND:VCARD"
        
        
        
        // Decomposing the vCard string
        NSArray        *lines;
        NSMutableArray *tokens = [[NSMutableArray alloc] init];
        
        NSLog(@"Tokenize VCARD:");

        lines = [vCardString componentsSeparatedByString:@"\n"];
        
        for(NSString* token in lines)
        {
            //NSLog(@"%@", token);
            NSArray *keyValuePair = [token componentsSeparatedByString:@":"];
            if([keyValuePair[1] isEqualToString:@"VCARD"])
               continue;
            else
            {
                //NSLog(@"%@", keyValuePair[1]);
                [tokens addObject: keyValuePair[1]];
            }
        }
        //NSLog(@"array length is %lu", (unsigned long)tokens.count);
        
        // Get Data as strings
        NSArray  *name    = [tokens[1] componentsSeparatedByString:@";"];
        NSString *phone   = tokens[2];
        NSString *mail    = tokens[3];
        NSString *job     = tokens[4];
        NSString *company = tokens[5];
        
        NSLog(@"Name: %@ %@", name[1], name[0]);
        NSLog(@"Phone: %@", phone);
        NSLog(@"Mail: %@", mail);
        NSLog(@"Job Title: %@", job);
        NSLog(@"Company: %@", company);
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            /*
             [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
             */
        }
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NimpleContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact" inManagedObjectContext:context];
        [contact SetValueForPrename:name[1] Surname:name[0] PhoneNumber:phone MailAddress:mail JobTitle:job Company:company];
        NSLog(@"Contact created: %@", [contact toString]);
        
        NSError *error;
        [context save:&error];
        
        [self.successLabel setText:@"Contact saved!"];
        [self.successLabel setHidden:FALSE];

        [self stopReading];
    }
}

// Stops the capture session
-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

@end
