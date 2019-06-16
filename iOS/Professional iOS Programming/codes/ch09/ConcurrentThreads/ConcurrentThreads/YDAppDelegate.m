//
//  YDAppDelegate.m
//  ConcurrentThreads
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
#import "YDPeopleViewController.h"
 

@implementation YDAppDelegate
 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    _managedObjectContext = [self appContext];
    
   UIViewController *vc1 = [[YDPeopleViewController alloc] initWithNibName:@"YDPeopleViewController" bundle:nil];
 
    self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = @[vc1];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark COREDATA
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Core Data stack
- (NSManagedObjectContext *)appContext
{
    if (self.managedObjectContext != nil) {
        return self.managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self appStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
      //  [self.managedObjectContext setUndoManager:nil];
    //[self.managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
            // subscribe to change notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    return self.managedObjectContext;
}

- (void)mocDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *savedContext = [notification object];
    
        // ignore change notifications for the main MOC
    if (self.managedObjectContext == savedContext)
        {
        return;
        }
    
    if (self.managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
        {
            // that's another database
        return;
        }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}


- (NSManagedObjectModel *)appModel
{
    if (self.managedObjectModel != nil) {
        return self.managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CT" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return self.managedObjectModel;
}

- (NSPersistentStoreCoordinator *)appStoreCoordinator
{
    if (self.persistentStoreCoordinator != nil) {
        return self.persistentStoreCoordinator;
    }
      NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CT.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self appModel]];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        abort();
    }
    
    return self.persistentStoreCoordinator;
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
 

 
 



@end
