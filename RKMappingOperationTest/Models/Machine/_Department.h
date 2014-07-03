// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Department.h instead.

#import <CoreData/CoreData.h>


extern const struct DepartmentAttributes {
	__unsafe_unretained NSString *guid;
	__unsafe_unretained NSString *name;
} DepartmentAttributes;

extern const struct DepartmentRelationships {
	__unsafe_unretained NSString *employees;
} DepartmentRelationships;

extern const struct DepartmentFetchedProperties {
} DepartmentFetchedProperties;

@class Employee;




@interface DepartmentID : NSManagedObjectID {}
@end

@interface _Department : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DepartmentID*)objectID;





@property (nonatomic, strong) NSString* guid;



//- (BOOL)validateGuid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *employees;

- (NSMutableSet*)employeesSet;





@end

@interface _Department (CoreDataGeneratedAccessors)

- (void)addEmployees:(NSSet*)value_;
- (void)removeEmployees:(NSSet*)value_;
- (void)addEmployeesObject:(Employee*)value_;
- (void)removeEmployeesObject:(Employee*)value_;

@end

@interface _Department (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveGuid;
- (void)setPrimitiveGuid:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveEmployees;
- (void)setPrimitiveEmployees:(NSMutableSet*)value;


@end
