//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Sebastian Lang on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NimpleContact : NSManagedObject

// schema version 1.0
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * prename;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * facebook_URL;
@property (nonatomic, retain) NSString * facebook_ID;
@property (nonatomic, retain) NSString * twitter_URL;
@property (nonatomic, retain) NSString * twitter_ID;
@property (nonatomic, retain) NSString * xing_URL;
@property (nonatomic, retain) NSString * linkedin_URL;
@property (nonatomic, retain) NSDate * created;

// schema version 2.0
@property (nonatomic, retain) NSString * contactHash;
@property (nonatomic, retain) NSString * note;


-(NSString*) toString;
-(void) setValueForPrename:(NSString*)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job Company:(NSString*)p_company FacebookURL:(NSString*)p_facebookURL FacebookID:(NSString*)p_facebookID TwitterURL:(NSString*)p_twitterURL TwitterID:(NSString*)p_twitterID XingURL:(NSString*)p_xingURL LinkedInURL:(NSString*)p_linkedinURL Created:(NSDate*)p_created ContactHash:(NSString*)p_contactHash Note:(NSString*)p_note;

@end
