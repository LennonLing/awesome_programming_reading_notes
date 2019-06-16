//
//  YDGPSLocationSimulator.h
//  YDLocationSimulator
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface YDLocationSimulator : CLLocationManager

@property (nonatomic, strong) CLLocation* currentlocation;
@property (nonatomic, strong) CLLocation* previousLocation;
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic,assign) BOOL bKeepRunning;
    //You can use the class as a singleton

+ (YDLocationSimulator*)sharedInstance;

    //this methods loads data from a file in your NSBundle
- (void)loadLocationFile:(NSString *)pathToFile;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

