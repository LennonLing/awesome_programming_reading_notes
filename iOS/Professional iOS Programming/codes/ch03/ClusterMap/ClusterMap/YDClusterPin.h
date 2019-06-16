//
//  YDClusterPin.h
//  ClusteredMap
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//The YDClusterPin object holds an annotation and possibly an array of pinnodes below (hidden)
@interface YDClusterPin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString* title;
    NSString* subtitle;
    NSArray*  pinnodes;
}
@property(nonatomic, retain) NSArray* pinnodes;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSString* subtitle;
- (NSUInteger) nodeCount;
@end
