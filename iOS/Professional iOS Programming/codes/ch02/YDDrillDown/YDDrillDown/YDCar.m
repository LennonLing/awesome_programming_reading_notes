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

-(id)initWithMake: (NSString *)carMake model:(NSString *)carModel imageName:(NSString *)carImageName;
{
    self = [super init];
    if (self)
        {
        self.make = [carMake copy];
        self.model = [carModel copy];
        self.imageName = [carImageName copy];
        }
    return self;
}
@end