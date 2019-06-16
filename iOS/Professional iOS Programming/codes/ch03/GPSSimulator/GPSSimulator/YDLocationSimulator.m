//
//  YDLocationSimulator.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //


#import "YDLocationSimulator.h"

@implementation YDLocationSimulator
{
@private
    id<CLLocationManagerDelegate> delegate;
    YDLocationSimulator* sharedInstance;
    BOOL                 updatingLocation;
    NSMutableArray*      fakeLocations;
    NSInteger            index;
    NSTimeInterval       updateInterval;
    CLLocationDistance   distanceFilter;
}
static YDLocationSimulator *sharedInstance = nil;

+ (YDLocationSimulator*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];

    }
    return sharedInstance;
}
-(void)loadLocationFile:(NSString *)pathToFile
{
    // read everything from the file
    NSString* fileContents =
    [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:nil];
    // first, separate by new line
    NSArray* allLines =
    [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //If the fakeLocations array is nil create it
    if (fakeLocations == nil)
        fakeLocations = [[NSMutableArray alloc] init];
    //Parse each line and add the coordinate to the array
    for (int i=0;i<[allLines count];i++)
    {
        NSString *line = [[allLines objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *latLong = [line componentsSeparatedByString:@","];
		CLLocationDegrees lat = [[latLong objectAtIndex:1] doubleValue];
        CLLocationDegrees lon = [[latLong objectAtIndex:0] doubleValue];
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [fakeLocations addObject:loc];
    }
}
- (void)fakeNewLocation {
	if((!self.previousLocation || [self.currentlocation distanceFromLocation:self.previousLocation] > distanceFilter) ) {
        if (!self.previousLocation)
            self.previousLocation= self.currentlocation;
        //Create an NSArray with the old location and new location and call the delegate
        NSArray* locs = [[NSArray alloc] initWithObjects:self.previousLocation,self.currentlocation,nil];
        [self.delegate locationManager:nil didUpdateLocations:locs];
        self.previousLocation = self.currentlocation;
         
    }
    // update the userlocation in the mapview if one is assigned
	if (_mapView) {
		[self.mapView.userLocation setCoordinate:self.currentlocation.coordinate];
	}
    // iterate to the next fake location
	if (updatingLocation) {
		index++;
		if (index == fakeLocations.count) {
			index = 0;
            if (!_bKeepRunning)
                {
                [self stopUpdatingLocation];
                updatingLocation = NO;
                }
            else
                self.currentlocation = [fakeLocations objectAtIndex:index];
		}
        else
            {
            self.currentlocation = [fakeLocations objectAtIndex:index];
            }
		[self performSelector:@selector(fakeNewLocation) withObject:nil afterDelay:updateInterval];
	}
}

- (void)startUpdatingLocation {
	updatingLocation = YES;
        //updateInterval in seconds will trigger a new location every xx seconds
    updateInterval = 1.0f;
    if ([fakeLocations count]>0)
        self.currentlocation = [fakeLocations objectAtIndex:0];
	[self fakeNewLocation];
}

- (void)stopUpdatingLocation {
	updatingLocation = NO;
}

@end
