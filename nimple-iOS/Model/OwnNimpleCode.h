//
//  OwnNimpleCode.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 05.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OwnNimpleCode : NSManagedObject

@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * prename;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * job;

-(NSString*) toString;

@end
