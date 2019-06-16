//
//  YDAppDelegate.m
//  BatteryDrainer
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
#import "Flurry.h"
@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.locmanager = [[CLLocationManager alloc] init];
    self.locmanager.delegate=self;
    [self.locmanager startUpdatingLocation];
    
    [Flurry startSession:@"YOUR_API_KEY"];
  	
	self.reachability = [Reachability reachabilityForInternetConnection];
	[self.reachability startNotifier];
	[self.reachability currentReachabilityStatus];
    
    // Override point for customization after application launch.
    self.viewController = [[YDViewController alloc] initWithNibName:@"YDViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


-(BOOL)connectedViaWIFI
{
    return  [self.reachability currentReachabilityStatus]== ReachableViaWiFi;
}

#pragma mark CoreLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userlocation=[locations lastObject];
    [self.locmanager stopUpdatingLocation];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.locmanager stopUpdatingLocation];
     
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
    [self.locmanager stopUpdatingLocation];
}

@end
