//
//  YDAnnotationsArray.h
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
@interface YDAnnotationsArray : NSObject {
    NSMutableArray *collection;
    double totalX;
    double totalY;
}

@property (nonatomic,readonly) NSMutableArray *collection;
- (void) addObject:(id<MKAnnotation>)annotation;
- (id) objectAtIndex:(NSUInteger)index;
- (NSUInteger) count;
-(double) xPoint;
-(double) yPoint;
@end
