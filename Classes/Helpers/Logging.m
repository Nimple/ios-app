//
//  Logging.m
//  nimple-iOS
//
//  Created by Ben John on 24/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "Logging.h"
#import "NimpleAppDelegate.h"

// dev token
#define MIXPANEL_TOKEN @"6e3eeca24e9b2372e8582b381295ca0c"

// prod token
// #define MIXPANEL_TOKEN @"c0d8c866df9c197644c6087495151c7e"

// hash of flyer contact
#define FLYER_CONTACT_HASH @"9d2b064c3d89c867916c5329f079fa66"

@implementation Logging

+ (void)initMixpanel {
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    [self sendApplicationStartedEvent];
}

#pragma mark - Sending events block

+ (void)sendApplicationStartedEvent {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"app started"];
}

+ (void)sendContactAddedEvent:(NimpleContact*)nimpleContact {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSString *isFlyerContact = @"false";
    
    if([nimpleContact.contactHash isEqualToString:FLYER_CONTACT_HASH]) {
        isFlyerContact = @"true";
    }
    
    NSLog(@"isFlyerContact = %@", isFlyerContact);
    
    NSDictionary *properties = @{
                                 @"has phone number": [self checkForEmptyStringAndFormatOutput:nimpleContact.phone],
                                 @"has mail address": [self checkForEmptyStringAndFormatOutput:nimpleContact.email],
                                 @"has company": [self checkForEmptyStringAndFormatOutput:nimpleContact.company],
                                 @"has job title": [self checkForEmptyStringAndFormatOutput:nimpleContact.job],
                                 @"has facebook": [self checkForEmptyStringAndFormatOutput:nimpleContact.facebook_URL],
                                 @"has twitter": [self checkForEmptyStringAndFormatOutput:nimpleContact.twitter_URL],
                                 @"has xing": [self checkForEmptyStringAndFormatOutput:nimpleContact.xing_URL],
                                 @"has linkedin": [self checkForEmptyStringAndFormatOutput:nimpleContact.linkedin_URL],
                                 @"is flyer contact": isFlyerContact
                                 };
    [mixpanel track:@"contact scanned" properties:properties];
}

+ (void)sendContactTransferredEvent {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"contact saved in adress book"];
}

+ (void)sendNimpleCodeChangedEvent:(NSDictionary*)ownNimpleCode {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    //    for (id key in ownNimpleCode) {
    //        NSLog(@"key: %@, value: %@ \n", key, [ownNimpleCode objectForKey:key]);
    //    }
    
    NSDictionary *properties = @{
                                 @"has phone number": ownNimpleCode[@"phone"],
                                 @"has mail address": ownNimpleCode[@"email"],
                                 @"has company": ownNimpleCode[@"company"],
                                 @"has job title": ownNimpleCode[@"job"],
                                 @"has facebook": ownNimpleCode[@"facebook_URL"],
                                 @"has twitter": ownNimpleCode[@"twitter_URL"],
                                 @"has xing": ownNimpleCode[@"xing_URL"],
                                 @"has linkedin": ownNimpleCode[@"linkedin_URL"]
                                 };
    [mixpanel track:@"nimple code edited" properties:properties];
}

#pragma mark - Small helper for Mixpanel

+ (NSString*)checkForEmptyStringAndFormatOutput:(NSString*)needle {
    if([needle length] == 0) {
        return @"false";
    } else {
        return @"true";
    }
}

@end
