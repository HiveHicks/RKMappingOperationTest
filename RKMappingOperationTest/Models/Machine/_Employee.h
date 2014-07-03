// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Employee.h instead.

#import <CoreData/CoreData.h>


extern const struct EmployeeAttributes {
	__unsafe_unretained NSString *departmentGuid;
	__unsafe_unretained NSString *guid;
	__unsafe_unretained NSString *name;
} EmployeeAttributes;

extern const struct EmployeeRelationships {
	__unsafe_unretained NSString *department;
} EmployeeRelationships;

extern const struct EmployeeFetchedProperties {
} EmployeeFetchedProperties;

@class Department;





@interface EmployeeID : NSManagedObjectID {}
@end

@interface _Employee : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (EmployeeID*)objectID;





@property (nonatomic, strong) NSString* departmentGuid;



//- (BOOL)validateDepartmentGuid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* guid;



//- (BOOL)validateGuid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Department *department;

//- (BOOL)validateDepartment:(id*)value_ error:(NSError**)error_;





@end

@interface _Employee (CoreDataGeneratedAccessors)

@end

@interface _Employee (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDepartmentGuid;
- (void)setPrimitiveDepartmentGuid:(NSString*)value;




- (NSString*)primitiveGuid;
- (void)setPrimitiveGuid:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (Department*)primitiveDepartment;
- (void)setPrimitiveDepartment:(Department*)value;


@end
