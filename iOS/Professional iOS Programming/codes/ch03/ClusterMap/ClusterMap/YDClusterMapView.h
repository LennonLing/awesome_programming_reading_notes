//
//  YDClusterMapView.h
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

//Custom MKMApView object
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
@interface YDClusterMapView : MKMapView<MKMapViewDelegate>
{
   NSUInteger tiles;
   NSUInteger minimumClusterLevel;
   NSArray *copiedAnnotations;
   double zoomLevel;
}
@property (nonatomic,assign) NSUInteger tiles;
@property (nonatomic,assign) NSUInteger minimumClusterLevel;
@property(nonatomic,assign) id<MKMapViewDelegate> delegate;

@end
