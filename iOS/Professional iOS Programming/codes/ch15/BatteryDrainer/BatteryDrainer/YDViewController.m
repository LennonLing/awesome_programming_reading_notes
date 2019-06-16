//
//  YDViewController.m
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

#import "YDViewController.h"
#import "YDAppDelegate.h"
@interface YDViewController ()

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
      
    YDAppDelegate* appDelegate = (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(networkStatusChanged:)
												 name:kReachabilityChangedNotification
											   object:appDelegate.reachability];
    

    
    if ([appDelegate connectedViaWIFI])
        self.connectionLabel.text = @"Connected via WIFI";
    else
        self.connectionLabel.text = @"NOT Connected via WIFI";
}

- (void)networkStatusChanged:(NSNotification*)notification {
   //you know the network status has changed so perform your action here
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
