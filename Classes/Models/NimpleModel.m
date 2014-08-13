//
//  NimpleModel.m
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleAppDelegate.h"
#import "NimpleModel.h"

@interface NimpleModel () {
    NSManagedObjectContext *_mainContext;
}

@end

@implementation NimpleModel

+ (id)sharedModel
{
    static id sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        _mainContext = [self managedObjectContext];
    }
    
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:coordinator];
    }
    return context;
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSURL *storeURL = [self storeURL];
    NSError *error = nil;
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return storeCoordinator;
}

- (NSURL *)storeURL
{
    NimpleAppDelegate *appDelegate = (NimpleAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"NimpleContact.sqlite"];
}

@end
