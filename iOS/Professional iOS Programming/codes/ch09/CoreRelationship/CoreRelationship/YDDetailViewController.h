//
//  YDDetailViewController.h
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

#import <UIKit/UIKit.h>
#import "YDAppDelegate.h"
#import "Continent.h"
#import "Country.h"
@interface YDDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* countryArr;
}
@property(nonatomic,strong)IBOutlet UITableView* mTableView;
@property(nonatomic,strong)Continent* thisContinent;
@end
