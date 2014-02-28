//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Sebastian Lang on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NimpleContact : NSObject

@property NSString *preName;
@property NSString *surName;
@property NSString *phoneNumer;
@property NSString *mailAddress;

- (NSString*) print;

@end
