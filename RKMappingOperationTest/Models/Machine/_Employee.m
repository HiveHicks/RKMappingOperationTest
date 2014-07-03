// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Employee.m instead.

#import "_Employee.h"

const struct EmployeeAttributes EmployeeAttributes = {
	.departmentGuid = @"departmentGuid",
	.guid = @"guid",
	.name = @"name",
};

const struct EmployeeRelationships EmployeeRelationships = {
	.department = @"department",
};

const struct EmployeeFetchedProperties EmployeeFetchedProperties = {
};

@implementation EmployeeID
@end

@implementation _Employee

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Employee";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:moc_];
}

- (EmployeeID*)objectID {
	return (EmployeeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic departmentGuid;






@dynamic guid;






@dynamic name;






@dynamic department;

	






@end
