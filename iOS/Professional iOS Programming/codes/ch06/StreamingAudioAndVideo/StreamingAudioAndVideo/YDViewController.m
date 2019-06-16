//
//  YDViewController.m
//  StreamingAudioAndVideo
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
- (IBAction)playStream:(UIButton *)sender;

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (IBAction)playStream:(UIButton *)sender
{
    NSURL *streamURL = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:streamURL];


    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

 
@end
