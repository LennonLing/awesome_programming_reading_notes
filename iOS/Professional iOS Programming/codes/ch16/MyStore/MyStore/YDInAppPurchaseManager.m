//
//  YDInAppPurchaseManager.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDInAppPurchaseManager.h"
#import "URLRequest.h"
#import "NSString+base64.h"

//private constants
const NSString* kSKTransactionReceiptVerifierURL = @"https://buy.itunes.apple.com/verifyReceipt";
const NSString* kSKSandboxTransctionReceiptVerifierURL = @"https://sandbox.itunes.apple.com/verifyReceipt";

@interface YDInAppPurchaseManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSMutableArray* productList;
}

@end
@implementation YDInAppPurchaseManager
{
 
}
#pragma mark Singleton Methods

+ (id)sharedInstance {
    static YDInAppPurchaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}

-(void)retrieveProductListFromURL:(NSURL *)urlToJsonFile applicationName:(NSString *)appName;
{
    if (productList)
        productList=nil;
     productList=[[NSMutableArray alloc] init];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlToJsonFile
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    URLRequest *urlRequest = [[URLRequest alloc] initWithRequest:request];
    [urlRequest startWithCompletion:^(URLRequest *request, NSData *data, BOOL success) {
        if (success)
            {
            NSError* error=nil;
            NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions  error:&error];
            NSDictionary* applications = (NSDictionary *)[resultDict objectForKey:@"applications"];
            for (NSDictionary* applicationDict in (NSDictionary* )[applications objectForKey:@"application"])
            {
                NSString* thisAppName = [applicationDict objectForKey:@"name"];
                //check if this is the appname we are looking for
                if ([thisAppName isEqualToString:appName])
                {
                    NSDictionary* appProducts = (NSDictionary*)[applicationDict objectForKey:@"products"];
                    for (NSDictionary* product in (NSDictionary*)[appProducts objectForKey:@"product"])
                    {
                    NSString* productIdentifier = [product objectForKey:@"product_identifier"];
                        [productList addObject:productIdentifier];
                    }
                }
            }
                [self requestProductDetails];
            }
        else
            {
            NSLog(@"error  %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
    }];
}

 

- (void)requestProductDetails
{
    NSSet *productIdentifiers =   [NSSet setWithArray:productList];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];

}


#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.availableProducts = response.products;
    self.invalidProducts= response.invalidProductIdentifiers;
    //notify the products have been fetched
    [[NSNotificationCenter defaultCenter] postNotificationName:kYDInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"ERR %@",error);
}
#pragma -
#pragma mark public methods

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseProduct:(SKProduct*)productToPurchase
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPayment* payment = [SKPayment paymentWithProduct:productToPurchase];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma mark Purchase helpers

 
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {

    //Verify the transaction receipt if it really came from Apple
    NSError *jsonSerializationError = nil;
    
    NSString *transactionReceiptAsString = [NSString base64StringFromData:transaction.transactionReceipt length:[transaction.transactionReceipt length]];
    NSDictionary *receiptDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:transactionReceiptAsString, @"receipt-data", nil];
    id receiptDictionaryAsData = [NSJSONSerialization dataWithJSONObject:receiptDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    NSURL *sandboxStoreURL = [[NSURL alloc] initWithString:kSKSandboxTransctionReceiptVerifierURL];
 //USE FOR STORE
    //   NSURL *storeURL = [[NSURL alloc] initWithString: kSKTransactionReceiptVerifierURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sandboxStoreURL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:receiptDictionaryAsData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    URLRequest *urlRequest = [[URLRequest alloc] initWithRequest:request];
    
    [urlRequest startWithCompletion:^(URLRequest *request, NSData *data, BOOL success) {
        if (success)
            {
            NSError* error=nil;
            NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions  error:&error];
            NSLog(@"JOSON: %@",resultDict);
            [[NSUserDefaults standardUserDefaults] setObject:resultDict forKey:transaction.payment.productIdentifier];
            [[NSUserDefaults standardUserDefaults] synchronize];
            }
        else
            {
            NSLog(@"error  %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
    }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kYDInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYDInAppPurchaseManagerDeliverProduct object:self userInfo:userInfo];
 
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kYDInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

- (BOOL)productPurchased:(NSString *)productIdentifier
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary* transactionDict =  [[NSUserDefaults standardUserDefaults] objectForKey:productIdentifier];
   if (transactionDict)
       {
           NSNumber* s = [transactionDict valueForKey:@"status"];
           return [s intValue ] == 0;
       }
    else
        return NO;
}

#pragma mark SKPaymentTransactionObserver methods

// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
        {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                default:
                break;
            }
        }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction wasSuccessful:YES];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}






@end























