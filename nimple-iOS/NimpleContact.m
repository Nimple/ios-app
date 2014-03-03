//
//  NimpleContact.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContact.h"
#import <DKCoreDataManager/DKCoreDataManager.h>

@implementation NimpleContact
@dynamic surname;
@dynamic prename;
@dynamic phone;
@dynamic email;
@dynamic company;
@dynamic job;

// Initalizes a contact with all properties nil
- (id) init
{
    self = [super init];
    if (self) {
        self.surname    = nil;
        self.prename    = nil;
        self.phone      = nil;
        self.email      = nil;
        self.company    = nil;
        self.job        = nil;
    }
    return self;
}

// Returns a string representation of the contact
- (NSString*) toString {
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", self.prename, self.surname, self.email, self.phone, self.company, self.job];
}


/*
+ (NimpleContact *) createContact {
    NSManagedObjectContext *contact = [DKCoreDataManager sharedManager].managedObjectContext;
    return [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact"
                                         inManagedObjectContext:contact];
}
*/

// Creates a nimple contact with all contact parameters
//
// Prename
// Surname
// PhoneNumber
// MailAddress
// CompanyName
// JobTitle
/*
+ (NimpleContact *) createContactWithPrename:(NSString *)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone EmailAddress:(NSString*)p_email CompanyName:(NSString*)p_company JobTitle:(NSString*)p_job {
    
    NimpleContact *contact = [NimpleContact createContact];
    
    contact.prename = p_prename;
    contact.surname = p_surname;
    contact.phone   = p_phone;
    contact.email   = p_email;
    contact.company = p_company;
    contact.job     = p_job;
    
    return contact;
}
*/

/*
// Creates a default contact
+ (void) createDefaultContact {
    [self createContactWithPrename:@"default" Surname:@"default" PhoneNumber:@"default" EmailAddress:@"default" CompanyName:@"default" JobTitle:@"default"];
    [[DKCoreDataManager sharedManager] saveContext];
}
*/

@end

