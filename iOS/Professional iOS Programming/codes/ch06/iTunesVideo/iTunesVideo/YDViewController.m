//
//  YDViewController.m
//  iTunesVideo
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

@interface YDViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //create only once
    self.moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:nil];
    [self loadMedia];
    
}
-(void)loadMedia
{
    NSNumber *videoTypeNum = [NSNumber numberWithInteger:MPMediaTypeAnyVideo];
    MPMediaPropertyPredicate *videoPredicate = [MPMediaPropertyPredicate predicateWithValue:videoTypeNum forProperty:MPMediaItemPropertyMediaType];
    MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
    [videoQuery addFilterPredicate: videoPredicate];
    self.allItems =[[NSMutableArray alloc]  initWithArray:[videoQuery collections]];
     [self.mTableView reloadData];
    
}
#pragma mark tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section {
	return [self.allItems count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCellIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MPMediaItem *item = [[self.allItems objectAtIndex:indexPath.row] representativeItem];
    MPMediaItemArtwork *artwork = [item valueForProperty: MPMediaItemPropertyArtwork];
    if (artwork) {
        cell.imageView.image = [artwork imageWithSize: CGSizeMake (100,100)];
    }
    cell.textLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
	return cell;
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    MPMediaItem *item = [[self.allItems objectAtIndex:indexPath.row] representativeItem];
   
    NSURL *assetURL=[item valueForProperty:MPMediaItemPropertyAssetURL];
    
    
    
    [self.moviePlayerView.moviePlayer setContentURL:assetURL];
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