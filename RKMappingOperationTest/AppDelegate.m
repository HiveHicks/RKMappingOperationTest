//
//  AppDelegate.m
//  RKMappingOperationTest
//
//  Created by Andrey Yutkin on 03.07.14.
//
//

#import <RestKit/CoreData/RKManagedObjectStore.h>
#import "AppDelegate.h"
#import "RKManagedObjectStore.h"
#import "SyncOperation.h"
#import "RKLog.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@implementation AppDelegate {
    RKManagedObjectStore *_managedObjectStore;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    RKLogConfigureByName("RestKit", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);

    [self runTest];

    return YES;
}

- (void)runTest
{
    NSArray *objects = @[
            @{@"type":@"Department",@"guid":@"7",@"name":@"DepA"},
            @{@"type":@"Department",@"guid":@"8",@"name":@"DepB"},
            @{@"type":@"Employee",@"guid":@"1",@"name":@"Alex",@"department":@"7"},
            @{@"type":@"Employee",@"guid":@"2",@"name":@"Blex",@"department":@"8"},
            @{@"type":@"Employee",@"guid":@"3",@"name":@"Clex",@"department":@"7"},
            @{@"type":@"Employee",@"guid":@"4",@"name":@"Dlex",@"department":@"8"},
            @{@"type":@"Employee",@"guid":@"5",@"name":@"Elex",@"department":@"7"},
            @{@"type":@"Employee",@"guid":@"6",@"name":@"Flex",@"department":@"8"}
    ];

    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.name = @"Sync queue";
    operationQueue.maxConcurrentOperationCount = 1;

    SyncOperation *operation = [[SyncOperation alloc] initWithObjects:objects];
    [operationQueue addOperation:operation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data

- (NSString *)pathToDatabase
{
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    return [libraryDir stringByAppendingPathComponent:@"cache.sqlite"];
}

- (NSManagedObjectContext *)mainMOC
{
    return self.managedObjectStore.mainQueueManagedObjectContext;
}

- (NSManagedObjectContext *)privateMOC
{
    return self.managedObjectStore.persistentStoreManagedObjectContext;
}

- (RKManagedObjectStore *)managedObjectStore
{
    if (_managedObjectStore == nil)
    {
        _managedObjectStore =
                [[RKManagedObjectStore alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];

        NSError *error;
        NSString *path = [self pathToDatabase];

        NSPersistentStore *persistentStore =
                [_managedObjectStore addSQLitePersistentStoreAtPath:path
                                             fromSeedDatabaseAtPath:nil
                                                  withConfiguration:nil
                                                            options:nil
                                                              error:&error];
        if (persistentStore == nil) {
            NSLog(@"Failed adding persistent store at path '%@': %@", path, error);
        }

        [_managedObjectStore createManagedObjectContexts];
    }

    return _managedObjectStore;
}

@end
