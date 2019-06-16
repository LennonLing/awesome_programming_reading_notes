//
//  URLRequest.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "URLRequest.h"
@interface URLRequest ()
{
    NSURLRequest *request;
    NSURLConnection *connection;
    NSMutableData *webData;
    int httpStatusCode;
    void (^completion)(URLRequest* request, NSData* data, BOOL success);
}
@end

@implementation URLRequest

- (id)initWithRequest:(NSURLRequest*)req
{
    self = [super init];
    if (self != nil)
    {
         request = req;
    }
    return self;
}

- (void)startWithCompletion:(void (^)(URLRequest* request, NSData* data, BOOL success))compl
{
    completion = [compl copy];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
    #if ! __has_feature(objc_arc)
        webData = [[NSMutableData data] retain];
#else
         webData = [[NSMutableData alloc] init];
        #endif
        
    } 
    else
    {
        completion(self, nil, NO);
    }
}
#if ! __has_feature(objc_arc)
- (void)dealloc
{
    if (webData != nil)
        [webData release];
    if (connection != nil)
        [connection release];
    [super dealloc];
}
#endif


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    completion(self, webData, httpStatusCode == 200);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    httpStatusCode = [httpResponse statusCode];
    [webData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    completion(self, webData, NO);
}

@end
