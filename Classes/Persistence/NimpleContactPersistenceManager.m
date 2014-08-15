//
//  NimpleContactPersistenceManager.m
//  nimple-iOS
//
//  Created by Ben John on 26/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContactPersistenceManager.h"

@implementation NimpleContactPersistenceManager

static NSManagedObjectContext *_managedObjectContext = nil;
static NimpleContactPersistenceManager *_sharedContext = nil;

+ (NimpleContactPersistenceManager *) getInstance:(NSManagedObjectContext *)managedObjectContext {
    if (!_sharedContext) {
        _sharedContext = [[self alloc] init];
        _managedObjectContext = managedObjectContext;
    }
    return _sharedContext;
}

- (NimpleContact *)saveNimpleContactWith:(NSArray *)contactData andContactHash:(NSString *)contactHash {
    NimpleContact *scannedContact = [NSEntityDescription insertNewObjectForEntityForName:@"NimpleContact" inManagedObjectContext:_managedObjectContext];
    scannedContact.prename = contactData[1];
    scannedContact.surname = contactData[0];
    
    scannedContact.phone = contactData[2];
    scannedContact.email = contactData[3];
    scannedContact.job = contactData[4];
    scannedContact.company = contactData[5];
    
    scannedContact.facebook_URL = contactData[6];
    scannedContact.facebook_ID = contactData[7];
    scannedContact.twitter_URL = contactData[8];
    scannedContact.twitter_ID = contactData[9];
    scannedContact.xing_URL = contactData[10];
    scannedContact.linkedin_URL = contactData[11];
    
    scannedContact.created = [NSDate date];
    scannedContact.contactHash = contactHash;
    scannedContact.note = @"";
    
    scannedContact.street = contactData[12];
    scannedContact.postal = contactData[13];
    scannedContact.city = contactData[14];
    scannedContact.website = contactData[15];
        
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Contact successfully saved to database!");
    } else {
        NSLog(@"Contact could not be saved to database!");
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return scannedContact;
}

@end
