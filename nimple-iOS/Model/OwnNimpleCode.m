//
//  OwnNimpleCode.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 05.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "OwnNimpleCode.h"


@implementation OwnNimpleCode

@dynamic surname;
@dynamic prename;
@dynamic phone;
@dynamic email;
@dynamic company;
@dynamic job;

// Concatenates the properties of a contact to a printable string
-(NSString*) toString
{
    NSString* string = [NSString stringWithFormat:@"Contact: %@ %@, %@ @ %@, %@ %@", self.prename, self.surname, self.job, self.company, self.phone, self.email];
    return string;
}

@end
