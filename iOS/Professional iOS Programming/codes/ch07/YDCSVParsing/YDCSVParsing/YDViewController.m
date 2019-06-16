//
//  YDViewController.m
//  YDCSVParsing
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
#import "NSArray+CSV.h"
@interface YDViewController ()

@end

@implementation YDViewController
 
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countriessmall" ofType:@"csv"];
    NSError* error = nil;
    NSString *myCountries = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    self.countries = [NSArray arrayWithCSVString:myCountries];
        /*
         another option is
    self.countries = [NSArray arrayWithCSVFile:filePath];
        //or even shorter
    self.countries = [NSArray arrayWithCSVFile:[[NSBundle mainBundle] pathForResource:@"countriessmall" ofType:@"csv"]];
         */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [self.countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        //This call will return the datarow that represents the line from the original CSV
    NSArray* datarow = [_countries objectAtIndex:indexPath.row];
        //obtain the datafield dictionary for a field at index
        // in this example the sixth field is returned
   NSDictionary* datafield = [datarow objectAtIndex:6];
     // Configure the cell...
        //access the datafield dictionary with key fieldvalue or fieldname
    cell.textLabel.text=[datafield objectForKey:@"fieldvalue"];
    return cell;
}



@end
