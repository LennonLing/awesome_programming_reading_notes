//
//  YDClusterMapView.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //Copyright (c) 2013 YourDeveloper. All rights reserved.
//
#import "YDClusterManager.h"
#import "YDClusterMapView.h"
@interface YDClusterMapView (Private)
- (void) setup;
- (BOOL) mapViewDidZoom;
@end
@implementation YDClusterMapView
@synthesize minimumClusterLevel;
@synthesize tiles;
@synthesize delegate;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        {
        [self setup];
        }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
        [self setup];
        }
    return self;
}

- (void) setup
{
    copiedAnnotations = nil;
    self.minimumClusterLevel = 100000;
    self.tiles = 4;
    super.delegate = self;
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if( [self mapViewDidZoom] )
        {
        //remove all the annotations
        [super removeAnnotations:self.annotations];
        self.showsUserLocation = self.showsUserLocation;
        }
    //Call YDClusterManager to return visible annotations clustered and normal
    NSArray *add = [YDClusterManager clusterAnnotationsForMapView:self forAnnotations:copiedAnnotations tiles:self.tiles minClusterLevel:self.minimumClusterLevel];
    [super addAnnotations:add];
    if( [delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)] )
        {
        [delegate mapView:mapView regionDidChangeAnimated:animated];
        }
}

- (BOOL) mapViewDidZoom
{
    if( zoomLevel == self.visibleMapRect.size.width * self.visibleMapRect.size.height )
        {
        zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
        return NO;
        }
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
    return YES;
}

- (void) addAnnotations:(NSArray *)annotations
{
    if (copiedAnnotations!=nil)
        copiedAnnotations=nil;
    //copy to our private array
    copiedAnnotations = [annotations copy];
     //Call YDClusterManager to return visible annotations clustered and normal
    NSArray *add = [YDClusterManager clusterAnnotationsForMapView:self forAnnotations:annotations tiles:self.tiles minClusterLevel:self.minimumClusterLevel];
    [super addAnnotations:add];
}
 

- (void) setMaximumClusterLevel:(NSUInteger)value
{
    if ( value > 100000 )
        minimumClusterLevel = 100000;
    else
        minimumClusterLevel = round(value);
}

- (void) setTiles:(NSUInteger)value
{
    if( value > 1024 )
        tiles = 1024;
    else if ( value < 2 )
        tiles = 2;
    else
        tiles = round(value);
    
}




#pragma implement standard delegates
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if( [delegate respondsToSelector:@selector(mapView:viewForOverlay:)] )
        {
        return [delegate mapView:mapView viewForOverlay:overlay];
        }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if( [delegate respondsToSelector:@selector(mapView:viewForAnnotation:)] )
        {
        return [delegate mapView:mapView viewForAnnotation:annotation];
        }
    return nil;
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if( [delegate respondsToSelector:@selector(mapView:regionWillChangeAnimated:)] )
        {
        [delegate mapView:mapView regionWillChangeAnimated:animated];
        }
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewWillStartLoadingMap:)] )
        {
        [delegate mapViewWillStartLoadingMap:mapView];
        }
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)] )
        {
        [delegate mapViewDidFinishLoadingMap:mapView];
        }
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    if( [delegate respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)] )
        {
        [delegate mapViewDidFailLoadingMap:mapView withError:error];
        }
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if( [delegate respondsToSelector:@selector(mapView:didAddAnnotationViews:)] )
        {
        [delegate mapView:mapView didAddAnnotationViews:views];
        }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if( [delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)] )
        {
        [delegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
        }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if( [delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)] )
        {
        [delegate mapView:mapView didSelectAnnotationView:view];
        }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if( [delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)] )
        {
        [delegate mapView:mapView didDeselectAnnotationView:view];
        }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)] )
        {
        [delegate mapViewWillStartLocatingUser:mapView];
        }
}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)] )
        {
        [delegate mapViewDidStopLocatingUser:mapView];
        }
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if( [delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)] )
        {
        [delegate mapView:mapView didUpdateUserLocation:userLocation];
        }
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if( [delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)] )
        {
        [delegate mapView:mapView didFailToLocateUserWithError:error];
        }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if( [delegate respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)] )
        {
        [delegate mapView:mapView annotationView:view didChangeDragState:newState fromOldState:oldState];
        }
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    if( [delegate respondsToSelector:@selector(mapView:didAddOverlayViews:)] )
        {
        [delegate mapView:mapView didAddOverlayViews:overlayViews];
        }
}



@end