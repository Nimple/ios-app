//
//  NimpleContact.m
//  nimple-iOS
//
//  This class represents a Contact in Nimple with the specified attributes.
//
//  Created by Sebastian Lang on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContact.h"


@implementation NimpleContact

@dynamic company;
@dynamic email;
@dynamic job;
@dynamic phone;
@dynamic prename;
@dynamic surname;
@dynamic facebook_URL;
@dynamic facebook_ID;
@dynamic twitter_URL;
@dynamic twitter_ID;
@dynamic xing_URL;
@dynamic linkedin_URL;
@dynamic created;
@dynamic contactHash;
@dynamic note;

// Sets all properties of a contact
-(void) setValueForPrename:(NSString*)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job Company:(NSString*)p_company FacebookURL:(NSString*)p_facebookURL FacebookID:(NSString*)p_facebookID TwitterURL:(NSString*)p_twitterURL TwitterID:(NSString*)p_twitterID XingURL:(NSString*)p_xingURL LinkedInURL:(NSString*)p_linkedinURL Created:(NSDate *)p_created ContactHash:(NSString*)p_contactHash Note:(NSString*)p_note {
    self.prename        = p_prename;
    self.surname        = p_surname;
    self.phone          = p_phone;
    self.email          = p_mail;
    self.job            = p_job;
    self.company        = p_company;
    self.facebook_URL   = p_facebookURL;
    self.facebook_ID    = p_facebookID;
    self.twitter_URL    = p_twitterURL;
    self.twitter_ID     = p_twitterID;
    self.xing_URL       = p_xingURL;
    self.linkedin_URL   = p_linkedinURL;
    self.created        = p_created;
    self.contactHash    = p_contactHash;
    self.note           = p_note;
}

// Concatenates the properties of a contact to a printable string
-(NSString*) toString {
    NSString* string = [NSString stringWithFormat:@"Contact: %@ %@, %@ @ %@, %@ %@ %@ %@", self.prename, self.surname, self.job, self.company, self.phone, self.email, self.created, self.contactHash];
    return string;
}

@end
