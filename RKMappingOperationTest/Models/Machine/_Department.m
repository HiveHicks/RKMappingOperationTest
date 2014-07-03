// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Department.m instead.

#import "_Department.h"

const struct DepartmentAttributes DepartmentAttributes = {
	.guid = @"guid",
	.name = @"name",
};

const struct DepartmentRelationships DepartmentRelationships = {
	.employees = @"employees",
};

const struct DepartmentFetchedProperties DepartmentFetchedProperties = {
};

@implementation DepartmentID
@end

@implementation _Department

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Department";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Department" inManagedObjectContext:moc_];
}

- (DepartmentID*)objectID {
	return (DepartmentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic guid;






@dynamic name;






@dynamic employees;

	
- (NSMutableSet*)employeesSet {
	[self willAccessValueForKey:@"employees"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"employees"];
  
	[self didAccessValueForKey:@"employees"];
	return result;
}
	






@end
