//
//  NimpleCode.m
//  nimple-iOS
//
//  Created by Ben John on 15/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCode.h"

@interface NimpleCode () {
    NSUserDefaults *_defaults;
}

@end

@implementation NimpleCode

+ (id)sharedCode
{
    static id sharedCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCode = [[self alloc] init];
    });
    return sharedCode;
}

- (id)init
{
    self = [super init];
    if (self) {
        _defaults = [self standardUserDefaults];
    }
    
    return self;
}

#pragma mark - User Defaults initialization

- (NSUserDefaults *)standardUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (NSString *)stringForKey:(NSString *)key
{
    NSString *value = [_defaults stringForKey:key];
    if (value) {
        return value;
    } else {
        return @"";
    }
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
    if (value) {
        [_defaults setObject:value forKey:key];
    }
}

- (BOOL)boolForKey:(NSString *)key
{
    return [_defaults boolForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [_defaults setBool:value forKey:key];
}

#pragma mark - Basic code

- (void)setPrename:(NSString *)prename
{
    [self setString:prename forKey:NimpleCodePrenameKey];
}

- (NSString *)prename
{
    return [self stringForKey:NimpleCodePrenameKey];
}

- (void)setSurname:(NSString *)surname
{
    [self setString:surname forKey:NimpleCodeSurnameKey];
}

- (NSString *)surname
{
    return [self stringForKey:NimpleCodeSurnameKey];
}

- (void)setCellPhone:(NSString *)cellPhone
{
    [self setString:cellPhone forKey:NimpleCodeCellPhoneKey];
}

- (NSString *)cellPhone
{
    return [self stringForKey:NimpleCodeCellPhoneKey];
}

- (void)setEmail:(NSString *)email
{
    [self setString:email forKey:NimpleCodeEmailKey];
}

- (NSString *)email
{
    return [self stringForKey:NimpleCodeEmailKey];
}

- (void)setJob:(NSString *)job
{
    [self setString:job forKey:NimpleCodeJobKey];
}

- (NSString *)job
{
    return [self stringForKey:NimpleCodeJobKey];
}

- (void)setCompany:(NSString *)company
{
    [self setString:company forKey:NimpleCodeCompanyKey];
}

- (NSString *)company
{
    return [self stringForKey:NimpleCodeCompanyKey];
}

#pragma mark - Address

- (void)setAddressStreet:(NSString *)street
{
    [self setString:street forKey:NimpleCodeAddressStreetKey];
}

- (NSString *)addressStreet
{
    return [self stringForKey:NimpleCodeAddressStreetKey];
}

- (void)setAddressPostal:(NSString *)postal
{
    [self setString:postal forKey:NimpleCodeAddressPostalKey];
}

- (NSString *)addressPostal
{
    return [self stringForKey:NimpleCodeAddressPostalKey];
}

- (void)setAddressCity:(NSString *)city
{
    [self setString:city forKey:NimpleCodeAddressCityKey];
}

- (NSString *)addressCity
{
    return [self stringForKey:NimpleCodeAddressCityKey];
}

- (void)setWebsite:(NSString *)website
{
    [self setString:website forKey:NimpleCodeWebsiteKey];
}

- (NSString *)website
{
    return [self stringForKey:NimpleCodeWebsiteKey];
}

#pragma mark - Social networks

- (void)setFacebookUrl:(NSString *)facebookUrl
{
    [self setString:facebookUrl forKey:NimpleCodeFacebookUrlKey];
}

- (NSString *)facebookUrl
{
    return [self stringForKey:NimpleCodeFacebookUrlKey];
}

- (void)setFacebookId:(NSString *)facebookId
{
    [self setString:facebookId forKey:NimpleCodeFacebookIdKey];
}

- (NSString *)facebookId
{
    return [self stringForKey:NimpleCodeFacebookIdKey];
}

- (void)setTwitterUrl:(NSString *)twitterUrl
{
    [self setString:twitterUrl forKey:NimpleCodeTwitterUrlKey];
}

- (NSString *)twitterUrl
{
    return [self stringForKey:NimpleCodeTwitterUrlKey];
}

- (void)setTwitterId:(NSString *)twitterId
{
    [self setString:twitterId forKey:NimpleCodeTwitterIdKey];
}

- (NSString *)twitterId
{
    return [self stringForKey:NimpleCodeTwitterIdKey];
}

- (void)setXing:(NSString *)xing
{
    [self setString:xing forKey:NimpleCodeXingKey];
}

- (NSString *)xing
{
    return [self stringForKey:NimpleCodeXingKey];
}

- (void)setLinkedIn:(NSString *)linkedIn
{
    [self setString:linkedIn forKey:NimpleCodeLinkedInKey];
}

- (NSString *)linkedIn
{
    return [self stringForKey:NimpleCodeLinkedInKey];
}

#pragma mark - Switches

- (void)setCellPhoneSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeCellPhoneSwitch];
}

- (BOOL)cellPhoneSwitch
{
    return [self boolForKey:NimpleCodeCellPhoneSwitch];
}

- (void)setEmailSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeEmailSwitch];
}

- (BOOL)emailSwitch
{
    return [self boolForKey:NimpleCodeEmailSwitch];
}

- (void)setJobSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeJobSwitch];
}

- (BOOL)jobSwitch
{
    return [self boolForKey:NimpleCodeJobSwitch];
}

- (void)setCompanySwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeCompanySwitch];
}

- (BOOL)companySwitch
{
    return [self boolForKey:NimpleCodeCompanySwitch];
}

- (void)setAddressSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeAddressSwitch];
}

- (BOOL)addressSwitch
{
    return [self boolForKey:NimpleCodeAddressSwitch];
}

- (void)setWebsiteSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeWebsiteSwitch];
}

- (BOOL)websiteSwitch
{
    return [self boolForKey:NimpleCodeWebsiteSwitch];
}

- (void)setFacebookSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeFacebookSwitch];
}

- (BOOL)facebookSwitch
{
    return [self boolForKey:NimpleCodeFacebookSwitch];
}

- (void)setTwitterSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeTwitterSwitch];
}

- (BOOL)twitterSwitch
{
    return [self boolForKey:NimpleCodeTwitterSwitch];
}

- (void)setXingSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeXingSwitch];
}

- (BOOL)xingSwitch
{
    return [self boolForKey:NimpleCodeXingSwitch];
}

- (void)setLinkedInSwitch:(BOOL)state
{
    [self setBool:state forKey:NimpleCodeLinkedInSwitch];
}

- (BOOL)linkedInSwitch
{
    return [self boolForKey:NimpleCodeLinkedInSwitch];
}

@end
