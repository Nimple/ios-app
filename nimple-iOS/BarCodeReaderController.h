//
//  NimpleCodeReaderController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>

@interface BarCodeReaderController : UIViewController
    <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeReaderCameraView;

- (IBAction)startStopReading:(id)sender;

@end
