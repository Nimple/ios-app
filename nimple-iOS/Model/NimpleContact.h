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

-(NSString*) toString;
-(void) setValueForPrename:(NSString*)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job Company:(NSString*)p_company FacebookURL:(NSString*)p_facebookURL FacebookID:(NSNumber*)p_facebookID TwitterURL:(NSString*)p_twitterURL TwitterID:(NSNumber*)p_twitterID XingURL:(NSString*)p_xingURL LinkedInURL:(NSString*)p_linkedinURL Created:(NSDate*)p_created;

@end
