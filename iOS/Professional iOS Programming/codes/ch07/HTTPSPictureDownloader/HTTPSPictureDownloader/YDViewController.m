//
//  YDViewController.m
//  FotoDownloader
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

@interface YDViewController ()
{
    NSInteger fileSize;
    NSInteger bytesDownloaded;
    BOOL shouldAllowSelfSignedCert;
   
}
- (IBAction)startDownload:(UIButton *)sender;

@end

@implementation YDViewController
    //static CFArrayRef certs;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startDownload:(UIButton *)sender
{
    BOOL                success;
    NSURL *             url;
    NSURLRequest *      request;
    url = [NSURL URLWithString:@"https://www.cacert.org/images/cacert4.png"];
    shouldAllowSelfSignedCert = YES;
    success = (url != nil);
    // Open a stream for the file we're going to receive into.
    self.filePath = [self createFileName];
    //create the output stream
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
    //open the stream
    [self.fileStream open];
    // create the request
    request = [NSURLRequest requestWithURL:url];
    //create the connection with the request
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    //clear the image
    self.receivedImage.image = nil;
    self.progressView.progress =0;

}

- (void)stopReceiveWithStatus:(NSString *)statusString
// Shuts down the connection and displays the result
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    self.statusLabel.text=statusString;
    self.receivedImage.image = [UIImage imageWithContentsOfFile:self.filePath];
    self.filePath = nil;
}
- (NSString*) createFileName {
    //create a file name based on timestamp
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddmmyyyy-HHmmssSSS"];
    return[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]]];
}
#pragma mark Challenge delegates

- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
// This delegate method called by the NSURLConnection when something happens with the
// connection security-wise.
{
    if([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if(shouldAllowSelfSignedCert) {
            return YES; // Self-signed cert will be accepted
        } else {
            return NO;  // Self-signed cert will be rejected
        }
    }
        // If no other authentication is required, return NO
    return NO;
}
static NSMutableDictionary * sSiteToCertificateMap;
static SecCertificateRef SecTrustGetLeafCertificate(SecTrustRef trust)
    // Returns the leaf certificate from a SecTrust object (that is always the
    // certificate at index 0).
{
    SecCertificateRef   result;
    if (SecTrustGetCertificateCount(trust) > 0) {
        result = SecTrustGetCertificateAtIndex(trust, 0);
    } else {
        result = NULL;
    }
    return result;
}
- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
// This delegate method called by the NSURLConnection when you accept a specific
// authentication challenge by returning YES from -connection:canAuthenticateAgainstProtectionSpace:.
{
    NSURLProtectionSpace *protectionSpace   = [challenge protectionSpace];
    SecTrustRef trust                       = [protectionSpace serverTrust];
    NSString *              host;
    SecCertificateRef       serverCert;
    OSStatus                err;
    BOOL                    trusted;
    SecTrustResultType      trustResult;
    CFRetain(trust);  // Make sure it's retained
        //create the credential from the trust
  
    host = [[challenge protectionSpace] host];
    if ( [sSiteToCertificateMap objectForKey:host] == nil ) {
            //get the certificate
        serverCert = SecTrustGetLeafCertificate(trust);
        if (serverCert != NULL) {
                //add to array
            [sSiteToCertificateMap setObject:(__bridge id)serverCert forKey:host];
        }
    }
        //evaluat the certificate
    err = SecTrustEvaluate(trust, &trustResult);
    trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
    if (!trusted)
        {
            // Not trusted
            //check if you trust the domain. this might be managed in an Array of sites you trust
        if (([challenge.protectionSpace.host isEqualToString:@"www.cacert.org"]) && shouldAllowSelfSignedCert)
            {
			NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
                //continue with the credential from the trust
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        }
    else
        {
            //trusted so accept the certificate"
        NSURLCredential *credential =
        [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
            //continue with the credential from the trust
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
}




- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    //create a static NSSet with mime types your download will support
    static NSSet *      sSupportedImageTypes;
    NSHTTPURLResponse * httpResponse;
    if (sSupportedImageTypes == nil) {
        sSupportedImageTypes = [[NSSet alloc] initWithObjects:@"image/jpeg", @"image/png", @"image/gif", nil];
    }
    httpResponse = (NSHTTPURLResponse *) response;
        //read the content length from the header field
    fileSize = [[[httpResponse allHeaderFields] valueForKey:@"Content-Length"] integerValue];
    bytesDownloaded=0;
        //check the status code
    if (httpResponse.statusCode !=200) {
        NSLog(@"error: %@",[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]);
    } else {
        NSString *  fileMIMEType;
        fileMIMEType = [[httpResponse MIMEType] lowercaseString];
        if (fileMIMEType == nil) {
            [self stopReceiveWithStatus:@"No Content-Type!"];
        } else if ( ! [sSupportedImageTypes containsObject:fileMIMEType] ) {
            [self stopReceiveWithStatus:[NSString stringWithFormat:@"Unsupported Content-Type (%@)", fileMIMEType]];
        } else {
            self.statusLabel.text=@"Response OK";
        }
    }
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
// delegate called by the NSURLConnection as data arrives.
// just write the data to the file.
{   //you need some variable to keep track on where you are writing bytes coming in over the data stream
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    dataLength = [data length];
    dataBytes  = [data bytes];
    bytesWrittenSoFar = 0;
    
    do {
        bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        if (bytesWritten == -1) {
            [self stopReceiveWithStatus:@"File write error"];
            break;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
        bytesDownloaded+=bytesWritten;
        self.progressView.progress = ((float)bytesDownloaded / (float)fileSize) ;
        
        
    } while (bytesWrittenSoFar != dataLength);
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [self stopReceiveWithStatus:@"Connection failed"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [self stopReceiveWithStatus:@"download has finished"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
