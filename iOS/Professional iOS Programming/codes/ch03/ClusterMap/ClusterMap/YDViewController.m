//
//  YDViewController.m
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
#import "YDClusterMapView.h"
#import "YDClusterPin.h"
#import "YDClusterAnnotationView.h"
@interface YDViewController ()<MKMapViewDelegate>

@end

@implementation YDViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    self.myMapView.showsUserLocation=YES;
    [self loadLocationFile:[[NSBundle mainBundle] pathForResource:@"coordinates" ofType:@"txt"]];
    //Center your map in NY - Manhattan
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 40.713951;
    newRegion.center.longitude = -74.005821;
    newRegion.span.latitudeDelta = 0.1;
    newRegion.span.longitudeDelta = 0.1;
    [self.myMapView setRegion:newRegion animated:YES];
}

-(void)loadLocationFile:(NSString *)pathToFile
{
    // read everything from the file
    NSString* fileContents =
    [NSString stringWithContentsOfFile:pathToFile
                              encoding:NSUTF8StringEncoding error:nil];
        // first, separate by new line
    NSArray* allLines =
    [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        //If the fakeLocations array is nil create it
    if (self.someLocations == nil)
        self.someLocations = [[NSMutableArray alloc] init];
        //Parse each line and add the coordinate to the array
    for (int i=0;i<[allLines count];i++)
        {
        NSString *line = [[allLines objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *latLong = [line componentsSeparatedByString:@","];
		CLLocationDegrees lat = [[latLong objectAtIndex:1] doubleValue];
        CLLocationDegrees lon = [[latLong objectAtIndex:0] doubleValue];
        CLLocationCoordinate2D coord = {lat,lon};
        YDClusterPin *pin = [[YDClusterPin alloc] init];
        pin.coordinate=coord;
        pin.title = [NSString stringWithFormat:@"Pin %i",i];;
        pin.subtitle = [NSString stringWithFormat:@"item %i",i];
        [self.someLocations addObject:pin];
        }
    [self.myMapView addAnnotations:self.someLocations];
}
#pragma mark Map view delegate
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{   //Since we are changing the region let's remove all annotations and reload them so again only visibles remain in memory
    [self.myMapView removeAnnotations:self.someLocations] ;
    [self.myMapView addAnnotations:self.someLocations];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
        //skip the User location
    if([annotation class] == MKUserLocation.class) {
		return nil;
	}
    
    YDClusterPin *pin = (YDClusterPin *)annotation;
    MKAnnotationView *annView;
    if( [pin nodeCount] > 0 ){
        annView = (YDClusterAnnotationView*)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"YDclusterAnnotation"];
        if( !annView )
            annView = (YDClusterAnnotationView*)
            [[YDClusterAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:@"YDclusterAnnotation"];
        annView.image = [UIImage imageNamed:@"cluster.png"];
        [(YDClusterAnnotationView*)annView setClusterAnnotationText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
        annView.canShowCallout = NO;
    } else {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"YDpin"];
        if( !annView )
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:@"YDpin"];
        
        annView.image = [UIImage imageNamed:@"pinPurple.png"];
        annView.canShowCallout = YES;
            //re-align the offset for the callout
        annView.calloutOffset = CGPointMake(-6.0, 0.0);
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{    if (![view isKindOfClass:[YDClusterAnnotationView class]])
    return;
    
    CLLocationCoordinate2D centerCoordinate = [(YDClusterPin *)view.annotation coordinate];
    MKCoordinateSpan newSpan =
    MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0,
                         mapView.region.span.longitudeDelta/2.0);
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
              animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end