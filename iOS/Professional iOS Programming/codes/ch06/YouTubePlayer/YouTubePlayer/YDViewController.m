//
//  YDViewController.m
//  YouTubePlayer
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
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <iframe title=\"YouTube Video\" class=\"youtube-player\" type=\"text/html\"\
    width=\"320\" height=\"460\" src=\"%@\"\
    frameborder=\"0\" allowFullScreen ></iframe>";
    NSString *urlToOpen = @"http://www.youtube.com/embed/u1zgFlCw8Aw?autoplay=1";
    NSString *html = [NSString stringWithFormat:embedHTML, urlToOpen];
 
    [self.youtubeViewer loadHTMLString:html baseURL:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end