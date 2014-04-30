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
    [scannedContact setValueForPrename:contactData[1] Surname:contactData[0] PhoneNumber:contactData[2] MailAddress:contactData[3] JobTitle:contactData[4] Company:contactData[5] FacebookURL:contactData[6] FacebookID:contactData[7] TwitterURL:contactData[8] TwitterID:contactData[9] XingURL:contactData[10] LinkedInURL:contactData[11] Created:[NSDate date] ContactHash:contactHash Note: @""];
    
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
