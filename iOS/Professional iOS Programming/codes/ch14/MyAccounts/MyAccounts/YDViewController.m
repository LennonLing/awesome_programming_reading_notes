//
//  YDViewController.m
//  MyAccounts
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
    [super viewDidLoad];
    [self requestAccessToAccountStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accountStoreChanged:)
                                                 name:ACAccountStoreDidChangeNotification
                                               object:nil];
}

-(void)requestAccessToAccountStore
{
   
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    NSDictionary* options = nil;
    [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType options:options
                                  completion:^(BOOL granted, NSError *error)
    {
        if (granted == YES)
        {
            // do what you need to do here
        dispatch_async(dispatch_get_main_queue(),^{
           
            //call loadAccounts here now you now the user has granted access
            [self loadAccounts];
        });
        }
    else
        {
          dispatch_async(dispatch_get_main_queue(),^{
              [self showAuthorizationError];
               });
        }
    }];
}
 
-(void)loadAccounts
{
  //check if we have been granted access to the twitter accounts
 if ([self.twitterAccountType accessGranted])
 {
     self.twitterAccounts = [[NSArray alloc] initWithArray:[self.accountStore accountsWithAccountType:self.twitterAccountType]];
     [self.mTableView reloadData];
 }
 else
     {
     [self showAuthorizationError];
     }
}

-(void)showAuthorizationError
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"You are not authorized" delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)accountStoreChanged:(NSNotification *)storeNotification
{
    //Do what you need to do here
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return [self.twitterAccounts count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
	}
    //Get the currentAccount from the NSArray
    ACAccount* currentAccount = [self.twitterAccounts objectAtIndex:indexPath.row];
   
    //Display the accountDescription
    cell.textLabel.text = currentAccount.accountDescription;
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
