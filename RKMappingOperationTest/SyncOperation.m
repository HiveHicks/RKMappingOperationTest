//
// Created by Andrey Yutkin on 03.07.14.
//

#import <CoreData/CoreData.h>
#import "SyncOperation.h"
#import "AppDelegate.h"
#import "RKManagedObjectStore.h"
#import "RKInMemoryManagedObjectCache.h"
#import "Employee.h"
#import "_Department.h"
#import "Department.h"
#import "RKMappingOperation.h"
#import "RKManagedObjectMappingOperationDataSource.h"
#import "NSManagedObjectContext+RKAdditions.h"
#import "RKDynamicMapping.h"
#import "RKMapperOperation.h"


@interface SyncOperation () <RKMappingOperationDelegate, RKMapperOperationDelegate>
@end

@implementation SyncOperation {
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
            _context = [APP_DELEGATE syncMOC];

            [self syncObjects:_objects];
            NSLog(@"Sync finished");

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
    RKManagedObjectMappingOperationDataSource *dataSource =
            [[RKManagedObjectMappingOperationDataSource alloc] initWithManagedObjectContext:_context cache:cache];

    RKMapperOperation *mapperOperation = [[RKMapperOperation alloc] initWithRepresentation:objects mappingsDictionary:@{
            [NSNull null] : [self mapping]
    }];
    mapperOperation.mappingOperationDataSource = dataSource;
    mapperOperation.delegate = self;

    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.name = @"Internal SyncOperation queue";

    [operationQueue addOperation:mapperOperation];
    [operationQueue waitUntilAllOperationsAreFinished];

    [_context performBlockAndWait:^{
        NSError *saveError = nil;
        if (![_context saveToPersistentStore:&saveError]) {
            NSLog(@"Error saving to store: %@", saveError);
        }
    }];
}

- (void)mapObject:(NSDictionary *)object withMapping:(RKMapping *)mapping cache:(id<RKManagedObjectCaching>)cache
{
    RKManagedObjectMappingOperationDataSource *dataSource =
            [[RKManagedObjectMappingOperationDataSource alloc] initWithManagedObjectContext:_context cache:cache];
//    dataSource.parentOperation = self;

    RKMappingOperation *mappingOperation =
            [[RKMappingOperation alloc] initWithSourceObject:object destinationObject:nil mapping:mapping];
    mappingOperation.dataSource = dataSource;
    mappingOperation.delegate = self;

    NSError *mappingError;
    if ([mappingOperation performMapping:&mappingError]) {
//        NSLog(@"Mapping succeded!");
    } else {
        NSLog(@"Mapping failed: %@", mappingError);
    }
}

- (RKMapping *)mapping
{
    RKDynamicMapping *mapping = [RKDynamicMapping new];

    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type"
                                                     expectedValue:@"Employee"
                                                     objectMapping:[self employeeMapping]]];

    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type"
                                                     expectedValue:@"Department"
                                                     objectMapping:[self departmentMapping]]];

    return mapping;
}

- (RKObjectMapping *)employeeMapping
{
    RKEntityMapping *employeeMapping = [RKEntityMapping mappingForEntityForName:[Employee entityName]
                                                           inManagedObjectStore:[APP_DELEGATE managedObjectStore]];

    [employeeMapping setIdentificationAttributes:@[EmployeeAttributes.guid]];

    [employeeMapping addAttributeMappingsFromDictionary:@{
            @"guid" : EmployeeAttributes.guid,
            @"name" : EmployeeAttributes.name,
            @"department" : EmployeeAttributes.departmentGuid
    }];

    [employeeMapping addConnectionForRelationship:EmployeeRelationships.department connectedBy:@{
            EmployeeAttributes.departmentGuid : DepartmentAttributes.guid
    }];

    return employeeMapping;
}

- (RKObjectMapping *)departmentMapping
{
    RKEntityMapping *departmentMapping = [RKEntityMapping mappingForEntityForName:[Department entityName]
                                                             inManagedObjectStore:[APP_DELEGATE managedObjectStore]];

    [departmentMapping setIdentificationAttributes:@[DepartmentAttributes.guid]];

    [departmentMapping addAttributeMappingsFromDictionary:@{
            @"guid" : DepartmentAttributes.guid,
            @"name" : DepartmentAttributes.name
    }];

    return departmentMapping;
}

#pragma mark - RKMapperOperationDelegate

- (void)mapperDidFinishMapping:(RKMapperOperation *)mapper
{
    NSLog(@"Mapper did finish mapping");
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