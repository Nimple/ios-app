//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Sebastian Lang on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NimpleContact : NSManagedObject

@property NSString *prename;
@property NSString *surname;
@property NSString *phone;
@property NSString *email;
@property NSString *company;
@property NSString *job;

- (NSString*) print;

@end
