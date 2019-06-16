//
//  YDPresident.m
//  PresidentSearch
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

#import "YDPresident.h"

@implementation YDPresident;
@synthesize firstName, lastName;

+ (YDPresident *)presidentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
	YDPresident *president = [[YDPresident alloc] init];
	president.firstName = firstName;
	president.lastName = lastName;
	return president;
}
@end
