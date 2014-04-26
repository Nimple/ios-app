//
//  NimpleContactPersistenceManager.h
//  nimple-iOS
//
//  Created by Ben John on 26/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimpleContact.h"

@interface NimpleContactPersistenceManager : NSObject

+ (NimpleContactPersistenceManager *) getInstance:(NSManagedObjectContext *) managedObjectContext;
- (NimpleContact*)saveNimpleContactWith:(NSArray *)contactData andContactHash:(NSString *)contactHash;

@end
