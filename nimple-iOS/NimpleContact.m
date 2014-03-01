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

- (id)init
{
    self = [super init];
    if (self) {
        self.surName = nil;
        self.preName = nil;
        self.mailAddress = nil;
        self.phoneNumer = nil;
    }
    return self;
}

-(id) initWithSurname:(NSString *)p_surname Prename:(NSString *)p_prename Mail:(NSString*)p_mailaddress Phone:(NSString*)p_phonenumber
{
    self = [super init];
    if (self) {
        self.surName     = p_surname;
        self.preName     = p_prename;
        self.mailAddress = p_mailaddress;
        self.phoneNumer  = p_phonenumber;
    }
    return self;
}

- (NSString*) print {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.preName, self.surName, self.mailAddress, self.phoneNumer];
}

@end

