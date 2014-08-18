//
//  VCardCreator.m
//  nimple-iOS
//
//  Created by Ben John on 17/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "VCardCreator.h"

@interface VCardCreator () {
    NSMutableDictionary *_vcardTemplate;
}

@end

@implementation VCardCreator

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self configureVCardTemplate];
    }
    return self;
}

#pragma mark - VCard Template

- (void)configureVCardTemplate
{
    _vcardTemplate = [NSMutableDictionary dictionary];
    _vcardTemplate[@"vcard_header"] = @"BEGIN:VCARD\nVERSION:3.0\n";
    _vcardTemplate[@"vcard_name"] = @"N:%@;%@\n";
    _vcardTemplate[@"vcard_phone"] = @"TEL;CELL:%@\n";
    _vcardTemplate[@"vcard_email"] = @"EMAIL:%@\n";
    _vcardTemplate[@"vcard_role"] = @"TITLE:%@\n";
    _vcardTemplate[@"vcard_organisation"] = @"ORG:%@\n";
    _vcardTemplate[@"vcard_address"] = @"ADR;type=HOME:%@\n";
    _vcardTemplate[@"vcard_facebook_id"] = @"X-FACEBOOK-ID:%@\n";
    _vcardTemplate[@"vcard_twitter_id"] = @"X-TWITTER-ID:%@\n";
    _vcardTemplate[@"vcard_url"] = @"URL:%@\n";
    _vcardTemplate[@"vcard_note"] = @"NOTE:Created with nimple.de\n";
    _vcardTemplate[@"vcard_end"] = @"END:VCARD";
}

#pragma mark - Create vcard

- (NSString *)createVCardFromNimpleCode:(NimpleCode *)code
{
    NSMutableString *filled = [NSMutableString stringWithString:[_vcardTemplate valueForKey:@"vcard_header"]];
    
    NSString *name = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_name"], code.surname, code.prename];
    [filled appendString:name];
    
    if (code.cellPhone.length > 0 && code.cellPhoneSwitch) {
        NSString *phone = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_phone"], code.cellPhone];
        [filled appendString: phone];
    }
    
    if (code.email.length > 0 && code.emailSwitch) {
        NSString *email = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_email"], code.email];
        [filled appendString: email];
    }
    
    if (code.company != 0 && code.companySwitch) {
        NSString *company = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_organisation"], code.company];
        [filled appendString: company];
    }
    
    if (code.job.length != 0 && code.jobSwitch) {
        NSString *job = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_role"], code.job];
        [filled appendString: job];
    }
    
    if (code.facebookUrl.length != 0 && code.facebookId.length != 0 && code.facebookSwitch) {
        NSString *facebook_URL = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_url"], code.facebookUrl];
        NSString *facebook_ID = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_facebook_id"], code.facebookId];
        [filled appendString:facebook_URL];
        [filled appendString:facebook_ID];
    }
    
    if (code.twitterUrl.length != 0 && code.twitterId.length != 0 && code.twitterSwitch) {
        NSString *twitter_URL = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_url"], code.twitterUrl];
        NSString *twitter_ID = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_twitter_id"], code.twitterId];
        [filled appendString:twitter_URL];
        [filled appendString:twitter_ID];
    }
    
    if (code.xing.length != 0 && code.xingSwitch) {
        NSString *xing_URL = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_url"], code.xing];
        [filled appendString:xing_URL];
    }
    
    if (code.linkedIn.length != 0 && code.linkedInSwitch) {
        NSString *linkedin_URL = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_url"], code.linkedIn];
        [filled appendString:linkedin_URL];
    }
    
    if (code.hasAddress && code.addressSwitch) {
        NSString *address = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_address"], [NSString stringWithFormat:@";;%@;%@;;%@;", code.addressStreet, code.addressCity, code.addressPostal]];
        [filled appendString:address];
    }
    
    if(code.website.length > 0 && code.websiteSwitch) {
        NSString *website = [NSString stringWithFormat:[_vcardTemplate valueForKey:@"vcard_url"], code.website];
        [filled appendString:website];
    }
    
    [filled appendString:[_vcardTemplate valueForKey:@"vcard_note"]];
    [filled appendString:[_vcardTemplate valueForKey:@"vcard_end"]];
    return filled;
}

@end
