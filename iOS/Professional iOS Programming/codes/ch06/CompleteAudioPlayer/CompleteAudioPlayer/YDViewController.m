//
//  YDViewController.m
//  CompleteAudioPlayer
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

@interface YDViewController ()<AVAudioPlayerDelegate>
- (IBAction)trackSliderMoved:(UISlider *)sender;
- (IBAction)volumeSliderMoved:(UISlider *)sender;
- (IBAction)playOrPause:(UIBarButtonItem *)sender;


@end

@implementation YDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sample2ch" ofType:@"m4a"]];
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	if (self.player)
        {
          [self updateViewForPlayerInfo:self.player];
          [self updateViewForPlayerState:self.player];
          [self.player prepareToPlay];
		  self.player.delegate = self;
        }
       
}
- (IBAction)playOrPause:(UIBarButtonItem *)sender
{
    if (self.player)
        {
        if (self.player.playing)
            {
            [self.player pause];
           
            [self.playButton setImage:[UIImage imageNamed:@"play.png"] ];
            [self updateViewForPlayerState:self.player];
            }
        else
            {
            [self.player play];
            [self.playButton setImage:[UIImage imageNamed:@"pause"]];
            [self updateViewForPlayerState:self.player];
            }
        }
}
 
- (IBAction)volumeSliderMoved:(UISlider *)sender
{
	self.player.volume = [sender value];
}
- (IBAction)trackSliderMoved:(UISlider *)sender
{
    self.player.currentTime = sender.value;
	[self updateCurrentTimeForPlayer:self.player];
}
-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
 	self.trackStatus.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
	self.trackSlider.maximumValue = p.duration;
	self.volumeSlider.value = p.volume;
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
	if (self.updateTimer!=nil)
		[self.updateTimer invalidate];
    
	if (p.playing)
        {
        [self.playButton setImage:[UIImage imageNamed:@"pause.png"]];
		self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self
                            selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
        }
	else
        {
        [self.playButton setImage:[UIImage imageNamed:@"play.png"]];
        self.updateTimer = nil;
        }
    
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    self.trackStatus.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
	self.trackSlider.value = p.currentTime;
    
}

- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.player];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
        // [self.playButton setImage:[UIImage imageNamed:@"play.png"]];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end