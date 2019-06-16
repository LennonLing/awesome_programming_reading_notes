//
//  YDViewController.h
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

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface YDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property(nonatomic,strong) ACAccountStore* accountStore;
@property(nonatomic,strong) ACAccountType*  twitterAccountType;
@property(nonatomic,strong) NSArray* twitterAccounts;
@property(nonatomic,strong) NSArray *tweets;
@end
