//
//  YDRestaurantAnnotation.h
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

#import <MapKit/MapKit.h>

@interface YDRestaurantAnnotation : NSObject<MKAnnotation>
 
-(id)initWithLat:(float)lat longitude:(float)lon title:(NSString *)restaurantTitle address:(NSString *)restaurantAddress category:(NSString *)restaurantCategory;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

