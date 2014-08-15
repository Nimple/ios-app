//
//  NimpleContact.m
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContact.h"

@implementation NimpleContact

// schema version 1.0
@dynamic prename;
@dynamic surname;

@dynamic phone;
@dynamic email;
@dynamic job;
@dynamic company;

@dynamic facebook_URL;
@dynamic facebook_ID;
@dynamic twitter_URL;
@dynamic twitter_ID;
@dynamic xing_URL;
@dynamic linkedin_URL;

@dynamic created;

// schema version 2.0
@dynamic contactHash;
@dynamic note;

// schema version 3.0
@dynamic street;
@dynamic postal;
@dynamic city;
@dynamic website;

- (NSString *)description
{
    return [NSString stringWithFormat:@"<NimpleContact: %@ %@, Created: %@>", self.prename, self.surname, self.created];
}

@end
