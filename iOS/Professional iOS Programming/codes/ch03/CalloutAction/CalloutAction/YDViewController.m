//
//  YDViewController.m
//  CustomAnnotation
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
#import "YDRestaurantAnnotation.h"
#import "YDDetailViewController.h"
@interface YDViewController ()<MKMapViewDelegate>

@end

@implementation YDViewController
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myMapView.showsUserLocation=YES;
    //Center your map in SF
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.799052;
    newRegion.center.longitude = -122.408187;
    newRegion.span.latitudeDelta = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    [self.myMapView setRegion:newRegion animated:YES];
    [self loadRestaurants];
}
-(void)loadRestaurants
{   //Initialize your Array
    self.restaurants = [[NSMutableArray alloc] initWithObjects:
                        [[YDRestaurantAnnotation alloc] initWithLat:37.799052
                                                          longitude:-122.408187
                                                              title:@"Calzone's Pizza Cucina‎"
                                                            address:@"430 Columbus Ave, San Francisco, CA"
                                                           category:@"pizza"],
                        [[YDRestaurantAnnotation alloc] initWithLat:37.799770 longitude:-122.408936
                                                              title:@"North Beach Restaurant"
                                                            address:@"512 Stockton Street San Francisco, CA"
                                                           category:@"fastfood"]
                        , nil] ;
    [self.myMapView addAnnotations:self.restaurants];
}
#pragma mark delegates
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
        // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[YDRestaurantAnnotation class]])
        {
        YDRestaurantAnnotation *thisRestaurant = (YDRestaurantAnnotation*)annotation;
        static NSString *RestaurantAnnotationIdentifier = @"RestaurantAnnotationIdentifier";
        MKAnnotationView *restaurantAnnotationView =
        [self.myMapView dequeueReusableAnnotationViewWithIdentifier:RestaurantAnnotationIdentifier];
        if (restaurantAnnotationView == nil)
            {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:RestaurantAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            if ([thisRestaurant.category isEqualToString:@"pizza"])
                {
                annotationView.image = [UIImage imageNamed:@"pizza.png"];
                }
            else  if ([thisRestaurant.category isEqualToString:@"fastfood"])
                {
                annotationView.image = [UIImage imageNamed:@"fastfood.png"];
                }
            annotationView.opaque = NO;
            //Add this line to set a UIButton to the rightCalloutAccessoryView
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            return annotationView;

            }
        else
            {
            restaurantAnnotationView.annotation = annotation;
            }
        return restaurantAnnotationView;
        }
    return nil;
}
- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {
    YDRestaurantAnnotation *thisRestaurantAnnotation = ((YDRestaurantAnnotation *)pin.annotation);
    YDDetailViewController *dvc = [[YDDetailViewController alloc] initWithNibName:@"YDDetailViewController" bundle:nil];
    dvc.annotation=thisRestaurantAnnotation;
    [self presentViewController:dvc animated:YES completion:nil];
   
 
    
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end