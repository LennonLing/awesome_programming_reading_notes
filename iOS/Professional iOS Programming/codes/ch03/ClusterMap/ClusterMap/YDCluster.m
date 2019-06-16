//
//  YDCluster.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDCluster.h"
#import "YDClusterPin.h"
#import "YDCluster.h"
@implementation YDCluster
- (void) addAnnotation:(id<MKAnnotation>)annotation
{   //if annotationsArray is not initialized, create it first
    if( !annotationsArray )
        {
        annotationsArray = [[YDAnnotationsArray alloc] init];
        }
    [annotationsArray addObject:annotation];
}
 
- (id<MKAnnotation>) getClusteredAnnotation
{
    if( [self count] == 1 )
        {
        //if only one simply return it from the array
        return [annotationsArray objectAtIndex:0];
        } else if ( [self count] > 1 )
            {
            //create a new location based on the xPoint and yPoint from the annotationsArray which are basically average x and y points
            CLLocationCoordinate2D location = MKCoordinateForMapPoint(MKMapPointMake([annotationsArray xPoint], [annotationsArray yPoint]));
            YDClusterPin *pin = [[YDClusterPin alloc] init];
            pin.coordinate = location;
            pin.pinnodes = [annotationsArray collection];
            return pin;
            }
    return nil;
}

- (NSInteger) count
{
    return [annotationsArray count];
}

@end
