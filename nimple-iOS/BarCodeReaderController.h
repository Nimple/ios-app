//
//  NimpleCodeReaderController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

// Framework imports
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>

@interface BarCodeReaderController : UIViewController
    <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIView          *codeReaderCameraView;
@property (weak, nonatomic) IBOutlet UILabel         *successLabel;
@property (weak, atomic) NSMutableArray              *capturedContactData;

- (IBAction)startStopReading:(id)sender;

@end
