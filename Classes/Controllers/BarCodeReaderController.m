//
//  NimpleCodeReaderController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "BarCodeReaderController.h"
#import "NimpleModel.h"
#import "NimpleContact.h"
#import "VCardParser.h"
#import "Logging.h"

@interface BarCodeReaderController () {
    __weak IBOutlet UINavigationItem *_scannerLabel;
    NimpleModel *_model;
    
    BOOL _isProcessing;
    BOOL _isReading;
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}
@end

@implementation BarCodeReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [NimpleModel sharedModel];
    [self localizeViewAttributes];
    [self initializeAlertViews];
    [self startScanner];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopScanner];
}

- (void)localizeViewAttributes
{
    _scannerLabel.title = NimpleLocalizedString(@"scanner_label");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.tabBarController setSelectedIndex: 2];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initializeAlertViews
{
    self.alertView = [[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"msg_box_right_code_header") message:NimpleLocalizedString(@"msg_box_right_code_text") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_right_code_activity") otherButtonTitles:nil];
    self.alertView2 = [[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"msg_box_wrong_code_header") message:NimpleLocalizedString(@"msg_box_wrong_code_text") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_wrong_code_activity") otherButtonTitles:nil];
    self.alertView3 = [[UIAlertView alloc] initWithTitle:nil message:NimpleLocalizedString(@"msg_box_duplicated_contact_title") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_duplicated_code_activity") otherButtonTitles:nil];
}

#pragma mark - Scanner control

- (void)startScanner
{
    _isReading = FALSE;
    _captureSession = nil;
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _videoPreviewLayer.drawsAsynchronously = TRUE;
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_codeReaderCameraView.layer.bounds];
    [_codeReaderCameraView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
}

- (void)stopScanner
{
    if (_captureSession != nil) {
        [_captureSession stopRunning];
        _captureSession = nil;
        [_videoPreviewLayer removeFromSuperlayer];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (_isProcessing) {
        return;
    }
    
    // Valid bar code found
    if (metadataObjects != nil && [metadataObjects count] == 1) {
        _isProcessing = YES;
        [self stopScanner];
        
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects[0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NimpleContact *contact = [VCardParser getContactFromCard:metadataObj.stringValue];
            
            // check for valid vcard on the basis of prename/surname
            if(contact.prename.length == 0 || contact.surname.length == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alertView2 show];
                });
                return;
            }
            [self saveContact:contact];
        }
    }
}

#pragma mark - Saving contact

- (void)saveContact:(NimpleContact *)contact
{
    if (![_model doesContactExistWithHash:contact.contactHash]) {
        NimpleContact *newContact = [_model getEntityForNewContact];
        [newContact fillWithContact:contact];
        [_model save];
        [[Logging sharedLogging] sendContactAddedEvent:newContact];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView show];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView3 show];
        });
    }
}

@end
