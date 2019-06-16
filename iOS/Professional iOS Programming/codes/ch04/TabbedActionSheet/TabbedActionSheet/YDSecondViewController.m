//
//  YDSecondViewController.m
//  TabbedActionSheet
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDSecondViewController.h"

@interface YDSecondViewController ()
-(IBAction)popQuestion:(id)sender;
@end

@implementation YDSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)popQuestion:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose action"
                                                             delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Take picture"];
    [actionSheet addButtonWithTitle:@"Choose picture"];
    [actionSheet addButtonWithTitle:@"Take video"];
    [actionSheet addButtonWithTitle:@"Cancel"];
        //set the desctructiveButtonIndex to the button that is responsible for the cancel function
    actionSheet.destructiveButtonIndex=3;
        // [actionSheet showFromTabBar:self.tabBarController.tabBar];
        // to display for iPad from a UIBarButtonItem
        //get the current selectedItem and typecast it to a UIBarButtonItem
    UIBarButtonItem* current =(UIBarButtonItem *)self.tabBarController.tabBar.selectedItem;
    [actionSheet showFromBarButtonItem:current animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
