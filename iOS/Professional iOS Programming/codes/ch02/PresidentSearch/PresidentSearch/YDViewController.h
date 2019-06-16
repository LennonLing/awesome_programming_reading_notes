//
//  YDViewController.h
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

#import <UIKit/UIKit.h>

@interface YDViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView* mTableView;
@property (nonatomic, strong) NSArray* presidents;
@property (nonatomic, strong) NSArray* filteredPresidents;
    //@property (nonatomic, retain) UISearchDisplayController* searchDisplayController;
@end
