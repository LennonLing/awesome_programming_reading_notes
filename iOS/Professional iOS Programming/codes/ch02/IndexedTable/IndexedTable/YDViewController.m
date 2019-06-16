//
//  YDViewController.m
//  IndexedTable
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
#import "YDPresident.h"
@interface YDViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YDViewController

 
- (void)viewDidLoad
{
    [super viewDidLoad];
    //create an array of YDPresident objects for each president of the USA
	self.presidents = [[NSArray alloc] initWithObjects:
                   [YDPresident presidentWithFirstName:@"George" lastName:@"Washington"],
                   [YDPresident presidentWithFirstName:@"John" lastName:@"Adams"],
                   [YDPresident presidentWithFirstName:@"Thomas" lastName:@"Jeffeson"],
                   [YDPresident presidentWithFirstName:@"James" lastName:@"Madison"],
                   [YDPresident presidentWithFirstName:@"James" lastName:@"Monroe"],
                   [YDPresident presidentWithFirstName:@"John Quincy" lastName:@"Adams"],
                   [YDPresident presidentWithFirstName:@"Andrew" lastName:@"Jackson"],
                   [YDPresident presidentWithFirstName:@"Martin" lastName:@"Van Buren"],
                   [YDPresident presidentWithFirstName:@"William Henry" lastName:@"Harrison"],
                   [YDPresident presidentWithFirstName:@"John" lastName:@"Tyler"],
                   [YDPresident presidentWithFirstName:@"James K" lastName:@"Polk"],
                   [YDPresident presidentWithFirstName:@"Zachary" lastName:@"Taylor"],
                   [YDPresident presidentWithFirstName:@"Millard" lastName:@"Fillmore"],
                   [YDPresident presidentWithFirstName:@"Franklin" lastName:@"Pierce"],
                   [YDPresident presidentWithFirstName:@"James" lastName:@"Buchanan"],
                   [YDPresident presidentWithFirstName:@"Abraham" lastName:@"Lincoln"],
                   [YDPresident presidentWithFirstName:@"Andrew" lastName:@"Johnson"],
                   [YDPresident presidentWithFirstName:@"Ulysses S" lastName:@"Grant"],
                   [YDPresident presidentWithFirstName:@"Rutherford B" lastName:@"Hayes"],
                   [YDPresident presidentWithFirstName:@"James A" lastName:@"Garfield"],
                   [YDPresident presidentWithFirstName:@"Chester A" lastName:@"Arthur"],
                   [YDPresident presidentWithFirstName:@"Grover" lastName:@"Cleveland"],
                   [YDPresident presidentWithFirstName:@"Bejamin" lastName:@"Harrison"],
                   [YDPresident presidentWithFirstName:@"Grover" lastName:@"Cleveland"],
                   [YDPresident presidentWithFirstName:@"William" lastName:@"McKinley"],
                   [YDPresident presidentWithFirstName:@"Theodore" lastName:@"Roosevelt"],
                   [YDPresident presidentWithFirstName:@"William Howard" lastName:@"Taft"],
                   [YDPresident presidentWithFirstName:@"Woodrow" lastName:@"Wilson"],
                   [YDPresident presidentWithFirstName:@"Warren G" lastName:@"Harding"],
                   [YDPresident presidentWithFirstName:@"Calvin" lastName:@"Coolidge"],
                   [YDPresident presidentWithFirstName:@"Herbert" lastName:@"Hoover"],
                   [YDPresident presidentWithFirstName:@"Franklin D" lastName:@"Roosevelt"],
                   [YDPresident presidentWithFirstName:@"Harry S" lastName:@"Truman"],
                   [YDPresident presidentWithFirstName:@"Dwight D" lastName:@"Eisenhower"],
                   [YDPresident presidentWithFirstName:@"John F" lastName:@"Kennedy"],
                   [YDPresident presidentWithFirstName:@"Lyndon B" lastName:@"Johnson"],
                   [YDPresident presidentWithFirstName:@"Richard" lastName:@"Nixon"],
                   [YDPresident presidentWithFirstName:@"Gerald" lastName:@"Ford"],
                   [YDPresident presidentWithFirstName:@"Jimmy" lastName:@"Carter"],
                   [YDPresident presidentWithFirstName:@"Ronald" lastName:@"Reagan"],
                   [YDPresident presidentWithFirstName:@"George H W" lastName:@"Bush"],
                   [YDPresident presidentWithFirstName:@"Bill" lastName:@"Clinton"],
                   [YDPresident presidentWithFirstName:@"George W" lastName:@"Bush"],
                   [YDPresident presidentWithFirstName:@"Barack" lastName:@"Obama"],
                   nil];
    
     
    //create a NSMutableArray
    self.alphabetArr = [[NSMutableArray  alloc] init];
    for (int i=0; i<[self.presidents count]-1; i++){
            //get the first char of persons lastname
        YDPresident *president = [self.presidents objectAtIndex:i];
        char letter = [president.lastName characterAtIndex:0];
        NSString *uniChar = [NSString stringWithFormat:@"%c", letter];
            //add each letter to your array
        if (![self.alphabetArr containsObject:uniChar])
            {
            [self.alphabetArr addObject:uniChar];
            }
    }
        //Create a sortDescriptor so we can sort alphabetically
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                                    ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
        //sortedArray will contain the sorted alphabetArr contents
    sortedArray = [self.alphabetArr sortedArrayUsingDescriptors:sortDescriptors];
 
        //Recreate it with initWihtArray from sortedArray
    self.alphabetArr = [[NSMutableArray alloc] initWithArray:sortedArray copyItems:YES];
    
}

#pragma mark for Indexing UITableView
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.alphabetArr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.alphabetArr count];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.alphabetArr objectAtIndex:section];
}

#pragma mark Table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   NSString *alphabet = [self.alphabetArr objectAtIndex:section];
    //---build a predicate to filter---
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastName BEGINSWITH  [cd] %@", alphabet];
    NSArray *tmp = [_presidents filteredArrayUsingPredicate:predicate];
        //---return the number of Presidents beginning with the letter---
    return [tmp count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    YDPresident* president;
    //get the letter in the current section
    NSString *alphabet = [_alphabetArr objectAtIndex:[indexPath section]];
    //get all president who's lastname begins with this letter
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"lastName BEGINSWITH [cd] %@", alphabet];
    NSArray *tmp = [self.presidents filteredArrayUsingPredicate:predicate];
    if ([tmp count]>0)
        president = [tmp objectAtIndex:indexPath.row];
    
    if (president)
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",president.firstName, president.lastName];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end