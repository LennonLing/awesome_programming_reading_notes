//
//  YDAppDelegate.m
//  MyPersonalLibrary
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
#import "YDCrashHandler.h"
@implementation YDAppDelegate

- (void)installYDCrashHandler
{
	InstallCrashExceptionHandler();
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (bYDInstallCrashHandler)
    {
        [self performSelector:@selector(installYDCrashHandler) withObject:nil afterDelay:0];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (![YDConfigurationHelper getBoolValueForConfigurationKey:bYDFirstLaunch])
        [YDConfigurationHelper setApplicationStartupDefaults];
    
    if (bYDActivateGPSOnStartUp)
    {
        //Start your CLLocationManager here if you're application needs the GPS
    }
    
    if (bYDRegistrationRequired && ![YDConfigurationHelper getBoolValueForConfigurationKey:bYDRegistered])
    {
        //Create an instance of your RegistrationViewcontroller
        self.registrationVC =[[YDRegistrationViewController alloc] init];
        //Set the delegate
        self.registrationVC.delegate=self;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = _registrationVC;
        self.window.backgroundColor = [UIColor clearColor];
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        // you arrive here if either the registration is not required or yet achieved
        if (bYDLoginRequired)
        {
            self.loginVC= [[YDLoginViewController alloc] init];
            self.loginVC.delegate=self;
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = _loginVC;
            self.window.backgroundColor = [UIColor clearColor];
            [self.window makeKeyAndVisible];
        }
        else
        {
            self.viewController= [[YDViewController alloc] init];
            self.window.rootViewController =self.viewController;
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
}
#pragma Registration Delegates
-(void)registeredWithError
{
    //called from RegistrationViewcontroller if registration failed
}
-(void)registeredWithSuccess
{
    //called from RegistrationViewcontroller if the registration with success
    //
    if (bYDShowLoginAfterRegistration)
    {
        self.loginVC = [[YDLoginViewController alloc] init];
        self.loginVC.delegate=self;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = self.loginVC;
        self.window.backgroundColor = [UIColor clearColor];
        [self.window makeKeyAndVisible];
    }
    else
        {
            self.viewController= [[YDViewController alloc] init];
            self.window.rootViewController =self.viewController;
            [self.window makeKeyAndVisible];
        }
}
-(void)cancelRegistration
{
    //called from RegistrationViewcontroller if cancel is pressed
}
#pragma Login delegates
-(void)loginWithSuccess
{
    //called when login with success
    self.viewController= [[YDViewController alloc] init];
    self.window.rootViewController =self.viewController;
    [self.window makeKeyAndVisible];
}
-(void)loginWithError
{
    //called when login with error
}
-(void)loginCancelled
{
    //called when login is cancelled
}


@end
