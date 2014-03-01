//
//  NimpleCodeReaderController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NimpleCodeReaderController : UIViewController
    <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeReaderCameraView;

- (IBAction)startStopReading:(id)sender;

@end
