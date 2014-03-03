//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Sebastian Lang on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NimpleContact : NSObject

@property NSString *prename;
@property NSString *surname;
@property NSString *phone;
@property NSString *email;
@property NSString *company;
@property NSString *job;

- (id) init;
- (NSString*) toString;

//+ (NimpleContact *) createContact;
//+ (void) createDefaultContact;
//+ (NimpleContact *) createContactWithPrename:(NSString *)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone EmailAddress:(NSString*)p_email CompanyName:(NSString*)p_company JobTitle:(NSString*)p_job;

@end
