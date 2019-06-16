//
//  YDAnnotationsArray.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDAnnotationsArray.h"
#import "YDClusterPin.h"
@implementation YDAnnotationsArray

@synthesize collection;
- (id) init
{
    self = [super init];
    if( self )
        {
        collection = [[NSMutableArray alloc] init];
        totalX = 0;
        totalY = 0;

        }
    return self;
}

- (void) addObject:(id<MKAnnotation>)annotation;
{
    [collection addObject:annotation];
    MKMapPoint mapPoint = MKMapPointForCoordinate( [annotation coordinate] );
    //increase totalX with the mappoint x coordinate for this annotation
    totalX += mapPoint.x;
    //do the same for the y coordinate
    totalY += mapPoint.y;
}
-(double)xPoint
{
  return   totalX / [collection count];
}
-(double)yPoint
{
   return  totalY / [collection count];
}
- (id) objectAtIndex:(NSUInteger)index
{
    return [collection objectAtIndex:index];
}
- (NSUInteger) count
{
    return [collection count];
}

@end
