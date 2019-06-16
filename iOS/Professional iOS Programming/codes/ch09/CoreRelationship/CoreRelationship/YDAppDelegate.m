//
//  YDAppDelegate.m
//  CoreRelationship
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDAppDelegate.h"

#import "YDViewController.h"
#import "Continent.h"
#import "Country.h"
@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     _managedObjectContext = [self appContext];
     [self setupSomeData];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    YDViewController* vc = [[YDViewController alloc] initWithNibName:@"YDViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)setupSomeData
{
    
    Continent* continent = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Continent" inManagedObjectContext:_managedObjectContext];
    continent.name = @"Europe";
    
    Country* france = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Country" inManagedObjectContext:_managedObjectContext];
    france.name = @"France";
    //here we set the relationship
    france.cont = continent;
        //another country
    Country* spain = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Country" inManagedObjectContext:_managedObjectContext];
    spain.name = @"Spain";
        //here we set the relationship
    spain.cont = continent;
        //and one more
    Country* unitedkingdom = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Country" inManagedObjectContext:_managedObjectContext];
    unitedkingdom.name = @"United Kingdom";
        //here we set the relationship
    unitedkingdom.cont = continent;
        //Save them
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
            //handle error
    }
    
    
}
#pragma mark - Core Data stack
- (NSManagedObjectContext *)appContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self appStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    return _managedObjectContext;
}
- (NSManagedObjectModel *)appModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"World" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)appStoreCoordinator
{
    if (self.persistentStoreCoordinator != nil) {
        return self.persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"world.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self appModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        abort();
    }
    
    return self.persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext =_managedObjectContext;
    if (managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            
            abort();
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

@end