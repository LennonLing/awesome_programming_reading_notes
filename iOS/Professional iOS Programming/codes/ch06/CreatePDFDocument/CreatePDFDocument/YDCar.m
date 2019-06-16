//
//  YDCar.m
//  YDDrillDown
//
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDCar.h"

@implementation YDCar
@synthesize make=_make;
@synthesize model=_model;
@synthesize imageName=_imageName;

-(id)initWithMake: (NSString *)carMake model:(NSString *)carModel imageName:(NSString *)carImageName
{
    self = [super init];
    if (self)
        {
        _make = [carMake copy];
        _model = [carModel copy];
        _imageName = [carImageName copy];
        }
    return self;
}
@end