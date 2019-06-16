//
//  YDViewController.m
//  NumberFormats
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

@interface YDViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor whiteColor];
}
#pragma mark UITableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"English local for 1234.99";
            break;
        case 1:
            return @"French local for 1234.99";
            break;
        default:
            break;
    }
    return @"unknown";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    switch (indexPath.row) {
        case 0:
        {
        if (indexPath.section==0){
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        }
        else
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr"]];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            cell.textLabel.text = [NSString stringWithFormat:@"DecimalStyle: %@",[numberFormatter stringFromNumber:@1234.99]];
        }
            break;
        case 1:
        { if (indexPath.section==0){
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        }
        else
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr"]];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            cell.textLabel.text = [NSString stringWithFormat:@"CurrencyStyle: %@",[numberFormatter stringFromNumber:@1234.99]];
        }
            break;
        case 2:
        { if (indexPath.section==0){
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        }
        else
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr"]];
            [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
            cell.textLabel.text = [NSString stringWithFormat:@"PercentStyle: %@",[numberFormatter stringFromNumber:@1234.99]];
        }
            break;
        case 3:
        { if (indexPath.section==0){
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        }
        else
            [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr"]];
            [numberFormatter setPositiveFormat:@"###0.##"];
            cell.textLabel.text = [NSString stringWithFormat:@"###0.##: %@",[numberFormatter stringFromNumber:@1234.99]];
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end