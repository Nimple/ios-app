//
//  VCardParser.m
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "VCardParser.h"

@implementation VCardParser

+(NSMutableArray*)getContactFromCard:(NSString*)card {
    NSMutableArray *contactData = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    NSArray *lines = [card componentsSeparatedByString:@"\n"];
    
    NSLog(@"Tokenize VCARD.");
    NSLog(@"%lu lines found in vCard", (unsigned long)[lines count]);
    NSLog(@"Lines are %@", lines);

    NSString *role = @"";
    NSString *title = @"";
    
    for(NSString *line in lines) {
        // in order to have a clean db entry
        NSString *newLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(newLine.length < 3) {
            continue;
        }
        
        if([newLine hasPrefix:@"N:"]) {
            newLine = [newLine substringFromIndex:2];
            NSArray *names = [newLine componentsSeparatedByString:@";"];
            if(names.count > 1) {
                contactData[0] = names[0];
                contactData[1] = names[1];
            } else {
                break;
            }
        } else if ([newLine hasPrefix:@"EMAIL"]) {
            NSString *email = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
            contactData[3] = email;
        } else if ([newLine hasPrefix:@"TEL"]) {
            NSString *telehone = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
            contactData[2] = telehone;
        } else if ([newLine hasPrefix:@"ORG:"]) {
            // handle organisation
            // take care of multiple units
            NSString *company = [newLine substringFromIndex:4];
            
            if ([newLine rangeOfString:@";"].location != NSNotFound) {
                NSArray *orgs = [company componentsSeparatedByString:@";"];
                
                for(NSString *org in orgs) {
                    [contactData[5] appendString:[NSString stringWithFormat:@"%@%@", org, @"\n"]];
                }
            } else {
                contactData[5] = company;
            }
        } else if ([newLine hasPrefix:@"TITLE"]) {
            title = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
        } else if ([newLine hasPrefix:@"ROLE"]) {
            role = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
        } else if ([newLine hasPrefix:@"URL"]) {
            NSString *url = [newLine substringFromIndex:4];
            
            // parse urls
            if([newLine rangeOfString:@"facebook"].location != NSNotFound) {
                contactData[6] = url;
            } else if([newLine rangeOfString:@"twitter"].location != NSNotFound) {
                contactData[8] = url;
            } else if([newLine rangeOfString:@"xing"].location != NSNotFound) {
                contactData[10] = url;
            } else if([newLine rangeOfString:@"linkedin"].location != NSNotFound) {
                contactData[11] = url;
            }
        } else if ([newLine hasPrefix:@"X-FACEBOOK-ID:"]) {
            contactData[7] = [newLine substringFromIndex:14];
        } else if ([newLine hasPrefix:@"X-TWITTER-ID:"]) {
            contactData[9] = [newLine substringFromIndex:13];
        } else if ([newLine hasPrefix:@"END:VCARD"]) {
            break;
        } else {
            // unrecognized line;
        }
    }
    
    // check for ROLE instead of TITLE
    if(role.length != 0 && title.length == 0) {
        contactData[4] = role;
    } else {
        contactData[4] = title;
    }
    
    NSLog(@"Contact parsed: %@", contactData);
    return contactData;
}

@end
