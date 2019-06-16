//
//  YDViewController.m
//  WebPDFViewer
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

@interface YDViewController ()<UIWebViewDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load PDF file from the Bundle
    NSString *fileToLoad = [[NSBundle mainBundle] pathForResource:@"MobileHIG" ofType:@"pdf"];
    NSData *data1 = [[NSData alloc] initWithContentsOfFile:fileToLoad];
    [self.pdfViewer loadData:data1 MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
