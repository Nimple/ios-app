//
//  ContactTableViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *prenameSurnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phuneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saveToContactsView;

@end
