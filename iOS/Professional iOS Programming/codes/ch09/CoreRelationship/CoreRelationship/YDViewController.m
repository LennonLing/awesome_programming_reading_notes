//
//  YDViewController.m
//  CoreRelationship
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
#import "YDAppDelegate.h"
#import "Continent.h"
#import "YDDetailViewController.h"
@interface YDViewController ()

@end

@implementation YDViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Continents";
        // Set up the edit and add buttons.
        //    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    [self loadData];
}
-(void)loadData
{
    if (continentArr)
        continentArr=nil;
    continentArr=[[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Continent"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(int i = 0;i<[fetchedObjects count];i++)
        {
        Continent *obj = (Continent *)[fetchedObjects objectAtIndex:i];
        [continentArr addObject:obj];
        }
    [self.mTableView reloadData];
}
#pragma UITableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{     return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return [continentArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Continent* thisContinent = [continentArr objectAtIndex:indexPath.row];
    cell.textLabel.text =  thisContinent.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Continent* thisContinent = [continentArr objectAtIndex:indexPath.row];
        //pass it on
    YDDetailViewController* dvc = [[YDDetailViewController alloc] initWithNibName:@"YDDetailViewController" bundle:nil];
    dvc.thisContinent=thisContinent;
    [self.navigationController pushViewController:dvc animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
