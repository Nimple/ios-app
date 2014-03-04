//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NimpleContact : NSManagedObject

@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * surname;

@end
