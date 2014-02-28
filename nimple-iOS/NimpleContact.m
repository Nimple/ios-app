//
//  NimpleContact.m
//  nimple-iOS
//
//  Created by Sebastian Lang on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContact.h"

@implementation NimpleContact
{
    NSString *surname;
    NSString *prename;
    NSString *_mailAddress;
    NSString *phoneNumber;
}

- (NSString*) print {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.preName, self.surName, self.mailAddress, self.phoneNumer];
}

@end

