//
//  YDViewController.m
//  VideoPlayer
//
//  Created by Peter van de Put on 17/02/13.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import "YDViewController.h"

@interface YDViewController ()
@property (weak, nonatomic) IBOutlet UIButton *moviePlayButton;
- (IBAction)playVideo:(UIButton *)sender;

@end

@implementation YDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    self.moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"]]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(thumbnailReady:)
     name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
     object:nil];
    
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    [timeArr addObject:[NSNumber numberWithFloat:1.f]];
    [self.moviePlayerView.moviePlayer requestThumbnailImagesAtTimes:timeArr timeOption:MPMovieTimeOptionNearestKeyFrame];

}
- (void) thumbnailReady:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
	UIImage *image =
    [userInfo objectForKey: @"MPMoviePlayerThumbnailImageKey"];
	[self.moviePlayButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)playVideo:(UIButton *)sender
{
    
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerView];
    self.moviePlayerView.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self.moviePlayerView.moviePlayer play];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end