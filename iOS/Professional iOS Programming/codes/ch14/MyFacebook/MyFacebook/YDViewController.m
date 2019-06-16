//
//  YDViewController.m
//  MyFacebook
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
	// Do any additional setup after loading the view, typically from a nib.
    [self requestAccessToAccountStore];
    UIBarButtonItem *addEventButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                           UIBarButtonSystemItemAdd target:self action:@selector(newPost:)];
	self.navigationItem.rightBarButtonItem = addEventButtonItem;
}
- (void)newPost:(id)sender
{
    //check if there are facebook account
    if ([self.facebookAccounts count] >0)
        {
        SLRequestHandler requestHandler =
        ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (responseData) {
                NSInteger statusCode = urlResponse.statusCode;
                if (statusCode >= 200 && statusCode < 300) {
                   /* NSDictionary *postResponseData =
                    [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:NSJSONReadingMutableContainers
                                                      error:NULL];
                    */
                    //SUCCESS
                }
                else {
                    //Error
                }
            }
            else {
                    //Error
            }
        };
        ACAccount* currentAccount = [self.facebookAccounts objectAtIndex:0];
        NSDictionary* fbPost = @{@"access_token":self.accessToken,@"message": @"My first FBpost using the SLRequest class"};
        NSURL* requestURL = [NSURL
                             URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",self.facebookUserID]];
       
        SLRequest* postRequest = [SLRequest
                                  requestForServiceType:SLServiceTypeFacebook
                                  requestMethod:SLRequestMethodPOST
                                  URL:requestURL parameters:fbPost];
        postRequest.account = currentAccount;
        [postRequest performRequestWithHandler:requestHandler];
        }
    else
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Configure a Facebook account" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        }
    
}
-(void)requestAccessToAccountStore
{
    
    self.accountStore = [[ACAccountStore alloc] init];
    self.facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                               ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"151575221693657",
                              ACFacebookPermissionsKey: @[@"email"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    [self.accountStore requestAccessToAccountsWithType:self.facebookAccountType options:options
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

-(void)requestAdditionalPermissions
{
    
    self.accountStore = [[ACAccountStore alloc] init];
    self.facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                                ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"151575221693657",
                              ACFacebookPermissionsKey: @[@"publish_stream"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    [self.accountStore requestAccessToAccountsWithType:self.facebookAccountType options:options
                                            completion:^(BOOL granted, NSError *error)
     {
     if (granted == YES)
         {
             // do what you need to do here
         /*
         dispatch_async(dispatch_get_main_queue(),^{
             
                 //call loadAccounts here now you now the user has granted access
             [self loadAccounts];
         });
          */
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
    if ([self.facebookAccountType accessGranted])
        {
        self.facebookAccounts = [[NSArray alloc] initWithArray:[self.accountStore accountsWithAccountType:self.facebookAccountType]];
        [self loadWallPosts];
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

-(void)loadWallPosts
{
    if ([self.facebookAccounts count] >0)
        {
        SLRequestHandler requestHandler =
        ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (responseData) {
                NSInteger statusCode = urlResponse.statusCode;
                if (statusCode >= 200 && statusCode < 300) {
                    
                    
                    NSDictionary* postsDictionary =  [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                    self.posts= [[NSMutableArray alloc]  init];
                    NSArray* wall = [postsDictionary  objectForKey:@"data"];
                    for (NSDictionary* wallpost in wall)
                        {
                        [self.posts addObject:wallpost];
                        }
                    if (self.posts.count != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mTableView reloadData];
                            [self requestAdditionalPermissions];
                            
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
        
        ACAccount* currentAccount = [self.facebookAccounts objectAtIndex:0];
        self.facebookUserID = [NSString stringWithFormat:@"%@", [[currentAccount valueForKey:@"properties"] valueForKey:@"uid"]] ;
        //access the credential to obtain the acces token
        ACAccountCredential* credential = currentAccount.credential;
        self.accessToken = [credential oauthToken];
        
        NSURL* requestURL = [NSURL
                             URLWithString:@"https://graph.facebook.com/me/posts"];
        
        SLRequest* getRequest = [SLRequest
                                 requestForServiceType:SLServiceTypeFacebook
                                 requestMethod:SLRequestMethodGET
                                 URL:requestURL parameters:nil];
        getRequest.account = currentAccount;
        [getRequest performRequestWithHandler:requestHandler];
        }
    else
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Configure a Facebook account" delegate:self cancelButtonTitle:@"OK"
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
	return [self.posts count];;
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
     NSDictionary* post = [(NSArray *)self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text =  post[@"message"];
	return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
