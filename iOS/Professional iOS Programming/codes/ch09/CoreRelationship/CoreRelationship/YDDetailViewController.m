//
//  YDDetailViewController.m
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

#import "YDDetailViewController.h"
#import "YDAppDelegate.h"
@interface YDDetailViewController ()

@end

@implementation YDDetailViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _thisContinent.name;
    [self loadData];
}
-(void)loadData
{
    if (countryArr)
        countryArr=nil;
    countryArr=[[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"cont == %@",self.thisContinent];
    [fetchRequest setPredicate:pred];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(int i = 0;i<[fetchedObjects count];i++)
        {
        Continent *obj = (Continent *)[fetchedObjects objectAtIndex:i];
        [countryArr addObject:obj];
        }
    [self.mTableView reloadData];
}
#pragma UITableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{     return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return [countryArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Country* thisCountry = [countryArr objectAtIndex:indexPath.row];
    cell.textLabel.text =  thisCountry.name;
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
