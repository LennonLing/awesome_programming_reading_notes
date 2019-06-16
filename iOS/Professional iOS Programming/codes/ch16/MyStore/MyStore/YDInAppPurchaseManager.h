//
//  YDInAppPurchaseManager.h

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

#import <StoreKit/StoreKit.h>

//Purchase

//Public
#define kYDInAppPurchaseManagerProductsFetchedNotification   @"kInAppPurchaseManagerProductsFetchedNotification"
#define kYDInAppPurchaseManagerTransactionFailedNotification  @"kInAppPurchaseManagerTransactionFailedNotification"
#define kYDInAppPurchaseManagerTransactionSucceededNotification  @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kYDInAppPurchaseManagerProductListRetrievedNotification  @"kYDInAppPurchaseManagerProductListRetrievedNotification"
#define kYDInAppPurchaseManagerDeliverProduct  @"kYDInAppPurchaseManagerDeliverProduct"


@interface YDInAppPurchaseManager : NSObject 
//This class is a singleton class
+ (id)sharedInstance;


@property(nonatomic,strong)NSArray* availableProducts;
@property(nonatomic,strong)NSArray* invalidProducts;


// public methods
- (void)retrieveProductListFromURL:(NSURL *)urlToJsonFile applicationName:(NSString *)appName;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (BOOL)canMakePurchases;
- (void)purchaseProduct:(SKProduct*)productToPurchase;
@end