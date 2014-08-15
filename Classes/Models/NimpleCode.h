//
//  NimpleCode.h
//  nimple-iOS
//
//  Created by Ben John on 15/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NimpleCodePrenameKey @"prename"
#define NimpleCodeSurnameKey @"surname"
#define NimpleCodeCellPhoneKey @"phone"
#define NimpleCodeEmailKey @"email"
#define NimpleCodeJobKey @"job"
#define NimpleCodeCompanyKey @"company"

#define NimpleCodeAddressStreetKey @"street"
#define NimpleCodeAddressPostalKey @"postal"
#define NimpleCodeAddressCityKey @"city"
#define NimpleCodeWebsiteKey @"website"

#define NimpleCodeFacebookUrlKey @"facebook_URL"
#define NimpleCodeFacebookIdKey @"facebook_ID"
#define NimpleCodeTwitterUrlKey @"twitter_URL"
#define NimpleCodeTwitterIdKey @"twitter_ID"
#define NimpleCodeXingKey @"xing_URL"
#define NimpleCodeLinkedInKey @"linkedin_URL"

@interface NimpleCode : NSObject

+ (NimpleCode *)sharedCode;

- (void)setPrename:(NSString *)prename;
- (NSString *)prename;
- (void)setSurname:(NSString *)surname;
- (NSString *)surname;
- (void)setCellPhone:(NSString *)cellPhone;
- (NSString *)cellPhone;
- (void)setEmail:(NSString *)email;
- (NSString *)email;
- (void)setJob:(NSString *)job;
- (NSString *)job;
- (void)setCompany:(NSString *)company;
- (NSString *)company;

- (void)setAddressStreet:(NSString *)street;
- (NSString *)addressStreet;
- (void)setAddressPostal:(NSString *)postal;
- (NSString *)addressPostal;
- (void)setAddressCity:(NSString *)city;
- (NSString *)addressCity;

- (void)setFacebookUrl:(NSString *)facebookUrl;
- (NSString *)facebookUrl;
- (void)setFacebookId:(NSString *)facebookId;
- (NSString *)facebookId;
- (void)setTwitterUrl:(NSString *)twitterUrl;
- (NSString *)twitterUrl;
- (void)setTwitterId:(NSString *)twitterId;
- (NSString *)twitterId;
- (void)setXing:(NSString *)xing;
- (NSString *)xing;
- (void)setLinkedIn:(NSString *)linkedIn;
- (NSString *)linkedIn;

@end
