//
//  YDViewController.m
//  MyTunesPlayer
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
    self.musicPlayer=[MPMusicPlayerController applicationMusicPlayer];
    [self loadMedia];
}

-(void)loadMedia
{
    //query all songs
    MPMediaQuery *allSongsQuery = [MPMediaQuery songsQuery];
    self.allItems =[[NSMutableArray alloc]  initWithArray:[allSongsQuery collections]];
    [self.mTableView reloadData];
}
#pragma mark tableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section
{
	return [self.allItems count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCellIdentifier"];
    }
    MPMediaItem *item = [[self.allItems objectAtIndex:indexPath.row] representativeItem];
    MPMediaItemArtwork *artwork = [item valueForProperty: MPMediaItemPropertyArtwork];
    if (artwork) {
        cell.imageView.image = [artwork imageWithSize: CGSizeMake (30, 30)];
    }
    cell.textLabel.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
	return cell;
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self.musicPlayer stop];
    [self.musicPlayer setQueueWithItemCollection:nil];
    MPMediaItem *item = [[self.allItems objectAtIndex:indexPath.row] representativeItem];
    MPMediaPropertyPredicate *myPredicate =
    [MPMediaPropertyPredicate predicateWithValue:[item valueForProperty:MPMediaItemPropertyAlbumPersistentID]
                                     forProperty:MPMediaItemPropertyAlbumPersistentID
                                  comparisonType:MPMediaPredicateComparisonContains];
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    [songsQuery addFilterPredicate:myPredicate];
    //set Query direct to Queue
    [self.musicPlayer setQueueWithQuery:songsQuery];
    [self.musicPlayer prepareToPlay];
    [self.musicPlayer play];
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
