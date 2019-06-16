//
//  YDViewController.m
//  AudioRecorder
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

@interface YDViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
- (IBAction)startRecording:(UIButton *)sender;
- (IBAction)startPlaying:(UIButton *)sender;
- (IBAction)stopRecording:(UIButton *)sender;

@end

@implementation YDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.stopButton setHidden:YES];
    [self.playButton setHidden:YES];
    
}
-(NSURL *)soundFileURL
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(  NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recording.m4a"];
    return  [NSURL fileURLWithPath:soundFilePath];
    
}
- (IBAction)startRecording:(UIButton *)sender
{
    [self.recordButton setHidden:YES];
    [self.stopButton setHidden:NO];
    [self.playButton setHidden:YES];
        //Create a dictionary for the recording settings
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];//mpeg 4 aac
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];//sample rate
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];//2 channels
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//16 bits
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    NSError *error = nil;
    
    self.audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:[self soundFileURL]
                     settings:recordSetting
                     error:&error];
    self.audioRecorder.delegate=self;
    if (error)
        {
        NSLog(@"error: %@", [error localizedDescription]);
        
        } else {
            [self.audioRecorder prepareToRecord];
        }
    if (!self.audioRecorder.recording)
        {
        self.recordButton.enabled = NO;
        self.stopButton.enabled = YES;
        [self.audioRecorder record];
        }
}
- (IBAction)stopRecording:(UIButton *)sender
{
    [self.stopButton setHidden:YES];
    [self.recordButton setHidden:NO];
    self.recordButton.enabled = YES;
    self.stopButton.enabled = NO;
    [self.audioRecorder stop];
    self.audioRecorder=nil;
    [self.playButton setHidden:NO];
}
- (IBAction)startPlaying:(UIButton *)sender
{
    [self.playButton setUserInteractionEnabled:NO];
    NSURL *url =  [self soundFileURL];
    NSError *error = nil;;
    self.audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
        {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
        } else {
            self.audioPlayer.delegate = self;
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
        }
    
}
#pragma mark delegates
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audioPlayer = nil;
    
    [self.playButton setUserInteractionEnabled:YES];
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thanks" message:@"Your recording has finished" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void)audioRecorderEncodeErrorDidOccur: (AVAudioRecorder *)recorder error:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end