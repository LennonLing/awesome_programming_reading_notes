    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDClusterManager.h"

@implementation YDClusterManager


+ (NSArray *) clusterAnnotationsForMapView:(MKMapView *)mapView forAnnotations:(NSArray *)pins tiles:(NSUInteger)tiles minClusterLevel:(NSUInteger)minClusterLevel
{
    NSMutableArray *visibleAnnotations = [NSMutableArray array];
    double tileX = mapView.visibleMapRect.origin.x;
    double tileY = mapView.visibleMapRect.origin.y;
    float tileWidth = mapView.visibleMapRect.size.width/tiles;
    float tileHeight = mapView.visibleMapRect.size.height/tiles;
    MKMapRect mapRect = MKMapRectWorld;
    NSUInteger maxWidthBlocks = round(mapRect.size.width / tileWidth);
    float zoomLevel = maxWidthBlocks / tiles;
    float tileStartX = floorf(tileX/tileWidth)*tileWidth;
    float tileStartY = floorf(tileY/tileHeight)*tileHeight;
    MKMapRect visibleMapRect = MKMapRectMake(tileStartX, tileStartY, tileWidth*(tiles+1), tileHeight*(tiles+1));
    for (id<MKAnnotation> point in pins)
    {
        MKMapPoint mapPoint = MKMapPointForCoordinate(point.coordinate);
        if( MKMapRectContainsPoint(visibleMapRect,mapPoint) )
        {
            if( ![mapView.annotations containsObject:point] )
            {
                [visibleAnnotations addObject:point];
            }   
        }
    }
    if( zoomLevel > minClusterLevel )
    {
        return visibleAnnotations;
    }
    
    NSMutableArray *clusteredTiles = [NSMutableArray array];
    
    int length = (tiles+1)*(tiles+1);
    for (int i=0 ; i < length ; i ++ )
    {
        YDCluster *block = [[YDCluster alloc] init];
        [clusteredTiles addObject:block];
    }
    for (YDClusterPin *pin in visibleAnnotations)
    {
        MKMapPoint mapPoint = MKMapPointForCoordinate(pin.coordinate);
        double localPointX = mapPoint.x - tileStartX;
        double localPointY = mapPoint.y - tileStartY;
        int localTileNumberX = floor( localPointX / tileWidth );
        int localTileNumberY = floor( localPointY / tileHeight );
        int localTileNumber = localTileNumberX + (localTileNumberY * (tiles+1));
        [(YDCluster *)[clusteredTiles objectAtIndex:localTileNumber] addAnnotation:pin];
    }
    
    //create New Pins
    NSMutableArray *newPins = [NSMutableArray array];
    for ( YDCluster *cluster in clusteredTiles )
    {
        if( [cluster count] > 0 )
        {
            if( ![self clusterAlreadyExistsForMapView:mapView andCluster:cluster] )
            {
              [newPins addObject:[cluster getClusteredAnnotation]];
            }
        }
    }
    return newPins;
}

+ (BOOL) clusterAlreadyExistsForMapView:(MKMapView *)mapView andCluster:(YDCluster *)cluster
{
    for ( YDClusterPin *pin in mapView.annotations )
    {   //if YDClusterPin doesn't have pinnodes we can skip
        if( [pin isKindOfClass:[YDClusterPin class]] && [[pin pinnodes] count] > 0 )
        {
            MKMapPoint point1 =  MKMapPointForCoordinate([pin coordinate]);
            MKMapPoint point2 =  MKMapPointForCoordinate([[cluster getClusteredAnnotation] coordinate]);
            if( MKMapPointEqualToPoint(point1,point2) )
            {
                return YES;
            }
        }
    }
    return NO;
}

@end
