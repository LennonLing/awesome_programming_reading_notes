//
//  YDViewController.m
//  GPSSimulator
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
@interface YDViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@end

@implementation YDViewController
#if TARGET_IPHONE_SIMULATOR
 YDLocationSimulator* locationManager;
#else
 CLLocationManager* locationManager;
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.showsUserLocation=YES;
    CLLocationDegrees lat = (double)40.709881;
    CLLocationDegrees lon = (double)-74.014771;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(lat,lon);
    self.mapView.delegate=self;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat,lon), 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
    YDLocationSimulator* simulator = [YDLocationSimulator sharedInstance];
    [simulator loadLocationFile:[[NSBundle mainBundle] pathForResource:@"coordinates" ofType:@"txt"]];
    locationManager = simulator;
    locationManager.delegate=self;
    simulator.mapView=self.mapView;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //wait 5 seconds for the map to draw itself
    [self performSelector:@selector(startUpdating) withObject:nil afterDelay:5.0f];
}
-(void)startUpdating
{
    [locationManager startUpdatingLocation];
}
#pragma mark CLLocationManager delegates

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* oldLocation = [locations objectAtIndex:0];
    CLLocation* newLocation = [locations lastObject];
    [self updateMap:oldLocation andNewLocation:newLocation];
}

-(void)updateMap:(CLLocation*)oldLocation andNewLocation:(CLLocation*) newLocation
{
    if (newLocation)
        {
        // make sure the old and new coordinates are different
        if ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
            (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
            { MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100);
              [self.mapView setRegion:region animated:YES];
            }
        }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end