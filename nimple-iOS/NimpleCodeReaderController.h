//
//  NimpleCodeReaderController.h
//  nimple-iOS
//
//  Created by Sebastian Lang on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NimpleCodeReaderController : UIViewController
    <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeReaderCameraView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (IBAction)startStopReading:(id)sender;

@end
