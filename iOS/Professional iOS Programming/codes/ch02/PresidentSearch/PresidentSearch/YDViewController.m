//
//  YDViewController.m
//  PresidentSearch
//
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
@interface YDViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>


@end

@implementation YDViewController

    // @synthesize searchDisplayController;
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
               [YDPresident presidentWithFirstName:@"Martin" lastName:@"van Buren"],
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
    
  
/*	UISearchBar* mySearchBar = [[UISearchBar alloc] init];
	mySearchBar.delegate = self;
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mySearchBar sizeToFit];
	self.mTableView.tableHeaderView = mySearchBar;
    // programmatically set up search display controller
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
	[self setSearchDisplayController:self.searchDisplayController];
    //set the delegate and data source
	[self.searchDisplayController setDelegate:self];
	[self.searchDisplayController setSearchResultsDataSource:self];
 */
  }

#pragma mark Table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
        {
        return [self.filteredPresidents count];
        }
	else
        {
        return [self.presidents count];
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	YDPresident *president;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        {   //search result
            president = [self.filteredPresidents objectAtIndex:indexPath.row];
        }
	else
        {  //normal result
            president = [self.presidents objectAtIndex:indexPath.row];
        }
    if (president)
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                               president.firstName, president.lastName];
    return cell;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{   //create an NSPredicate to search the properties firstName and lastName with an OR operator
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchText,searchText];
	self.filteredPresidents = [self.presidents filteredArrayUsingPredicate:predicate];
}

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles]
	  objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles]
	  objectAtIndex:searchOption]];
        // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end