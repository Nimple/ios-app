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

#pragma mark - Core Data initialization

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
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

#pragma mark - Core Data operations

- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID
{
    return [_mainContext objectWithID:objectID];
}

- (id)addObjectWithEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_mainContext];
}

- (void)removeObjectWithID:(NSManagedObjectID *)objectID
{
    NSManagedObject *object = [self objectWithID:objectID];
    [_mainContext deleteObject:object];
}

- (void)save
{
    NSError *error;
    if (![_mainContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Contacts

- (NSArray *)contacts
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"NimpleContact" inManagedObjectContext:_mainContext];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    NSArray* contacts = [_mainContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Contacts fetch error %@", error);
        return nil;
    }
    return contacts;
}

@end
