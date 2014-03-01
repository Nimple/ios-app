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
@dynamic surname, prename, phone, email, company, job;

- (NSString*) print {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.prename, self.surname, self.email, self.phone];
}


+ (NimpleContact *) createContact {
    NSManagedObjectContext *contact = [DKCoreDataManager sharedManager].managedObjectContext;
    return [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact"
                                         inManagedObjectContext:contact];
}

// Creates a nimple contact with all contact parameters
/*
    Prename
    Surname
    PhoneNumber
    MailAddress
    CompanyName
    JobTitle
*/
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

@end

