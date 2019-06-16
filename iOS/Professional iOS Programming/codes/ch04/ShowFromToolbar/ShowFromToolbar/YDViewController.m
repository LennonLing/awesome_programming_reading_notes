//
//  YDViewController.m
//  ShowFromToolbar
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
        //Create a UIToolbar
    self.toolbar =[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    self.toolbar.translucent=YES;
        //Create UIBarButtonItems
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(presentActionSheet:)];
        //Create the Array with items
    NSArray *items = [[NSArray alloc] initWithObjects:flexibleItem,item1, nil];
        //set the items to the toolbar
    [self.toolbar setItems:items animated:NO];
        //add the toolbar to the View
    [self.view addSubview:self.toolbar];
}
-(void)presentActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose action"
                                                              delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Take picture"];
    [actionSheet addButtonWithTitle:@"Choose picture"];
    [actionSheet addButtonWithTitle:@"Take video"];
    [actionSheet addButtonWithTitle:@"Cancel"];
        //set the desctructiveButtonIndex to the button that is responsible for the cancel function
    actionSheet.destructiveButtonIndex=3;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showFromToolbar:self.toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
