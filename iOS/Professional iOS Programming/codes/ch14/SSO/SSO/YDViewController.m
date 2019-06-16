//
//  YDViewController.m
//  SSO
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

@interface YDViewController ()

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)facebookSignin:(UIButton *)sender
{
    self.accountStore= [[ACAccountStore alloc] init];
    self.facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                                ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"151575221693657",
                              ACFacebookPermissionsKey: @[@"email"],
                              ACFacebookAudienceKey: ACFacebookAudienceOnlyMe
                              };
    
    [self.accountStore requestAccessToAccountsWithType:self.facebookAccountType options:options
                                            completion:^(BOOL granted, NSError *error)
     {
     if (granted == YES)
         {
             // do what you need to do here
         dispatch_async(dispatch_get_main_queue(),^{
             if ([self.facebookAccountType accessGranted])
                 {
                 NSArray* facebookAccounts = [[NSArray alloc] initWithArray:[self.accountStore accountsWithAccountType:self.facebookAccountType]];
                 self.currentAccount = [facebookAccounts objectAtIndex:0];
                  [self signedIn];
                 }
             else
                 {
                  
                 [self showAuthorizationError];
                 }
                 
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

- (IBAction)twitterSignin:(UIButton *)sender
{
     self.accountStore = [[ACAccountStore alloc] init];
     self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                                ACAccountTypeIdentifierTwitter];
       [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType options:nil
                                            completion:^(BOOL granted, NSError *error)
     {
     if (granted == YES)
         {
             // do what you need to do here
         dispatch_async(dispatch_get_main_queue(),^{
             
             if ([self.twitterAccountType accessGranted])
                 {
                 NSArray* twitterAccounts = [[NSArray alloc] initWithArray:[self.accountStore accountsWithAccountType:self.twitterAccountType]];
                 self.currentAccount = [twitterAccounts objectAtIndex:0];
                 [self signedIn];
                 }
             else
                 {
                 [self showAuthorizationError];
                 }
             
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
-(void)signedIn
{
 
    NSLog(@"username: %@", self.currentAccount.username);
    //you can use self.currentAccount.username to pass to your backend system
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                                    message:@"You have been signed-in" delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)showAuthorizationError
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"You are not authorized" delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


 

@end
