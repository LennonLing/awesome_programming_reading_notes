//
//  YDViewController.m
//  MyiAdDemo
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
#import <iAd/iAd.h>
@interface YDViewController ()<ADBannerViewDelegate>
{
    ADBannerView* adBannerView;
    BOOL bannerIsVisible;
}
@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,20, self.view.frame.size.width, 50)];
    [adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    adBannerView.delegate=self;
    [self.view addSubview:adBannerView];

}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    bannerIsVisible=YES;
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    bannerIsVisible=NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
          [adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    else
         [adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
