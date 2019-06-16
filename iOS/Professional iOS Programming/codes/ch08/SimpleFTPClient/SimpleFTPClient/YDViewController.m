//
//  YDViewController.m
//  SimpleFTPClient
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

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t defQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(defQueue, ^{
           ftpmanager=[[FTPManager alloc] initWithServer:@"YOUR_SERVERNAME"
         user:@"YOUR_USERNAME"
         password:@"YOUR_PASSWORD"];
        
        ftpmanager.delegate=self;
      });

}
-(IBAction)uploadFile:(id)sender
{
            [ftpmanager listRemoteDirectory];
}
- (void)ftpDownloadFinishedWithSuccess:(BOOL)success
{
    if (!success)
        {
        //handle your error
        }
}
-(void)ftpError:(NSString *)err
{
//handle your error
}
-(void)directoryListingFinishedWithSuccess:(NSArray *)arr
{
//use the array the way you need it
}
- (void)ftpUploadFinishedWithSuccess:(BOOL)success
{
    if (!success)
        {
        //handle your error
        }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

@end
