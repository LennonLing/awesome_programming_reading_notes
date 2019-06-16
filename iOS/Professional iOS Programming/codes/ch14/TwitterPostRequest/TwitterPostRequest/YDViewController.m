//
//  YDViewController.m
//  TwitterPostRequest
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
	// Do any additional setup after loading the view, typically from a nib.
    [self requestAccessToAccountStore];
    UIBarButtonItem *addEventButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                           UIBarButtonSystemItemAdd target:self action:@selector(newTweet:)];
	self.navigationItem.rightBarButtonItem = addEventButtonItem;
   
}
/*
 Use this implementation if you wish to post an image with your tweet
-(void)newTweet:(id)sender
{
    
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    
    ACAccount* currentAccount = [self.twitterAccounts objectAtIndex:0];
    
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com"
                  @"/1.1/statuses/update_with_media.json"];
    NSDictionary* params = @{@"status": @"Wow  a plane"};
    SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    UIImage* plane = [UIImage imageNamed:@"plane.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(plane, 1.f);
    [request addMultipartData:imageData
                     withName:@"media[]"
                         type:@"image/jpeg"
                     filename:@"image.jpg"];
    [request setAccount:currentAccount];
    [request performRequestWithHandler:requestHandler];
    
    
}
*/
- (void)newTweet:(id)sender
{
        //check if there are twitter accounts
    if ([self.twitterAccounts count] >0)
        {
        SLRequestHandler requestHandler =
        ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (responseData) {
                NSInteger statusCode = urlResponse.statusCode;
                if (statusCode >= 200 && statusCode < 300) {
                    NSDictionary *postResponseData =
                    [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:NSJSONReadingMutableContainers
                                                      error:NULL];
                    NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                }
                else {
                    NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                          [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                }
            }
            else {
                NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            }
        };
         
        ACAccount* currentAccount = [self.twitterAccounts objectAtIndex:0];
        NSDictionary* message = @{@"status": @"My first post using the SLRequest class"};
        NSURL* requestURL = [NSURL
                             URLWithString:@"http://api.twitter.com/1.1/statuses/update.json"];
        
        SLRequest* postRequest = [SLRequest
                                  requestForServiceType:SLServiceTypeTwitter
                                  requestMethod:SLRequestMethodPOST
                                  URL:requestURL parameters:message];
        postRequest.account = currentAccount;
        [postRequest performRequestWithHandler:requestHandler];
         }
    else
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                            message:@"Configure a Twitter account" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        }
    
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
         [self loadTweets];
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

-(void)loadTweets
{
    if ([self.twitterAccounts count] >0)
        {
        SLRequestHandler requestHandler =
        ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (responseData) {
                NSInteger statusCode = urlResponse.statusCode;
                if (statusCode >= 200 && statusCode < 300) {
                    
                    self.tweets = [NSJSONSerialization
                                       JSONObjectWithData:responseData
                                       options:NSJSONReadingMutableLeaves
                                       error:&error];
                    
                    if (self.tweets.count != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mTableView reloadData];
                        });
                    }
                  
                }
                else {
                    NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                          [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                }
            }
            else {
                NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            }
        };
        
        ACAccount* currentAccount = [self.twitterAccounts objectAtIndex:0];

        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        // [params setObject:@"1" forKey:@"include_entities"];
        NSURL* requestURL = [NSURL
                             URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
        
        SLRequest* getRequest = [SLRequest
                                  requestForServiceType:SLServiceTypeTwitter
                                  requestMethod:SLRequestMethodGET
                                  URL:requestURL parameters:params];
        getRequest.account = currentAccount;
        [getRequest performRequestWithHandler:requestHandler];
        }
    else
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Configure a Twitter account" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        }
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return [self.tweets count];;
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
        //Get the Tweet from the NSArray
    NSDictionary* tweet = [self.tweets objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet[@"text"];
	return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
