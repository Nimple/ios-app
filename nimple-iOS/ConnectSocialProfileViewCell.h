//
//  ConnectSocialProfileViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ConnectSocialProfileViewCell : UITableViewCell

@property (atomic) NSInteger index;
@property (atomic) NSInteger section;
@property (weak, nonatomic) IBOutlet UIImageView *socialNetworkIcon;
@property (weak, nonatomic) IBOutlet UIButton *connectStatusButton;
@property FBLoginView *fbloginView;

@end
