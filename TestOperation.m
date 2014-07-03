//
// Created by Andrey Yutkin on 03.07.14.
//

#import <CoreData/CoreData.h>
#import "TestOperation.h"
#import "AppDelegate.h"
#import "RKManagedObjectStore.h"
#import "RKInMemoryManagedObjectCache.h"
#import "Employee.h"
#import "_Department.h"
#import "Department.h"
#import "RKMappingOperation.h"
#import "RKManagedObjectMappingOperationDataSource.h"
#import "NSManagedObjectContext+RKAdditions.h"


@interface TestOperation () <RKMappingOperationDelegate>
@end

@implementation TestOperation {
    NSArray *_objects;
    NSManagedObjectContext *_context;
}

- (instancetype)initWithObjects:(NSArray *)objects
{
    self = [super init];
    if (self) {
        _objects = objects;
    }
    return self;
}

- (void)main
{
    @try
    {
        @autoreleasepool
        {
            _context = [[APP_DELEGATE managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType
                                                                                           tracksChanges:NO];

            [_context performBlockAndWait:^{
                [self syncObjects:_objects];
                NSLog(@"Sync finished");
            }];
        }
    }
    @catch (NSException *ex)
    {
        NSLog(@"%@", ex);
    }
}

#pragma mark - Helpers

- (void)syncObjects:(NSArray *)objects
{
    id<RKManagedObjectCaching> cache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:_context];

    for (NSDictionary *object in objects) {
        [self mapObject:object withMapping:[self mappingForObject:object] cache:cache];
    }

    NSError *error;
    if (![_context saveToPersistentStore:&error]) {
        NSLog(@"Error saving to store: %@", error);
    }
}

- (void)mapObject:(NSDictionary *)object
      withMapping:(RKEntityMapping *)mapping
            cache:(id<RKManagedObjectCaching>)cache
{
    RKMappingOperation *mappingOperation =
            [[RKMappingOperation alloc] initWithSourceObject:object destinationObject:nil mapping:mapping];

    RKManagedObjectMappingOperationDataSource *dataSource =
            [[RKManagedObjectMappingOperationDataSource alloc] initWithManagedObjectContext:_context cache:cache];
    mappingOperation.dataSource = dataSource;
    mappingOperation.delegate = self;

    NSError *mappingError;
    if ([mappingOperation performMapping:&mappingError]) {
//        NSLog(@"Mapping succeded!");
    } else {
        NSLog(@"Mapping failed: %@", mappingError);
    }
}

- (RKEntityMapping *)mappingForObject:(id)object
{
    if ([object[@"type"] isEqual:@"Employee"])
    {
        RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[Employee entityName]
                                                       inManagedObjectStore:[APP_DELEGATE managedObjectStore]];

        [mapping setIdentificationAttributes:@[EmployeeAttributes.guid]];

        [mapping addAttributeMappingsFromDictionary:@{
                @"guid" : EmployeeAttributes.guid,
                @"name" : EmployeeAttributes.name,
                @"department" : EmployeeAttributes.departmentGuid
        }];

        [mapping addConnectionForRelationship:EmployeeRelationships.department connectedBy:@{
                EmployeeAttributes.departmentGuid : DepartmentAttributes.guid
        }];

        return mapping;
    }
    else if ([object[@"type"] isEqual:@"Department"])
    {
        RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[Department entityName]
                                                       inManagedObjectStore:[APP_DELEGATE managedObjectStore]];

        [mapping setIdentificationAttributes:@[DepartmentAttributes.guid]];

        [mapping addAttributeMappingsFromDictionary:@{
                @"guid" : DepartmentAttributes.guid,
                @"name" : DepartmentAttributes.name
        }];

        return mapping;
    }

    return nil;
}

#pragma mark - RKMappingOperationDelegate

- (void)mappingOperation:(RKMappingOperation *)operation
  didConnectRelationship:(NSRelationshipDescription *)relationship
                 toValue:(id)value
         usingConnection:(RKConnectionDescription *)connection
{
    NSLog(@"Did connect relationship %@ to %@", relationship.name, value);
}

- (void)    mappingOperation:(RKMappingOperation *)operation
didFailToConnectRelationship:(NSRelationshipDescription *)relationship
             usingConnection:(RKConnectionDescription *)connection
{
    NSLog(@"Failed to connect relationship %@", relationship.name);
}

@end