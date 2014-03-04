//
//  NimpleContact.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContact.h"


@implementation NimpleContact

@dynamic company;
@dynamic email;
@dynamic job;
@dynamic prename;
@dynamic phone;
@dynamic surname;


// Sets all properties of a contact
-(void) SetValueForPrename:(NSString*)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job Company:(NSString*)p_company
{
    self.prename = p_prename;
    self.surname = p_surname;
    self.phone   = p_phone;
    self.email   = p_mail;
    self.job     = p_job;
    self.company = p_company;
}

// Concatenates the properties of a contact to a printable string
-(NSString*) toString
{
    NSString* string = [NSString stringWithFormat:@"Contact: %@ %@, %@ @ %@, %@ %@", self.prename, self.surname, self.job, self.company, self.phone, self.email];
    return string;
}

@end


