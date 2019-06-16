//
//  YDViewController.m
//  ComplexFTPClient
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
        self.ftpClient=[[YDFTPClient alloc]  initClient];
        self.ftpClient.delegate=self;
        [self.ftpClient connect];
    });
}
#pragma delegates
-(void)loggedOn
{
        //[self.ftpClient sendRAWCommand:@"LIST"];
}
-(void)logginFailed
{
    
}
-(void)ftpError:(NSString *)err
{
    
}
-(void)serverResponseReceived:(NSString *)lastResponseCode message:(NSString *)lastResponseMessage 
{

}
    //write your raw commands and logic use like



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
