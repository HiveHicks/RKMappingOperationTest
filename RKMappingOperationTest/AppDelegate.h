//
//  AppDelegate.h
//  RKMappingOperationTest
//
//  Created by Andrey Yutkin on 03.07.14.
//
//

#import <UIKit/UIKit.h>

@class RKManagedObjectStore;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong, readonly) NSManagedObjectContext *syncMOC;
@property (nonatomic, strong, readonly) RKManagedObjectStore *managedObjectStore;

@end
