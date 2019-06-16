//
//  YDViewController.m
//  PresentActionSheet
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

#import "YDViewController.h"

@interface YDViewController ()
- (IBAction)popQuestion:(UIButton *)sender;
 
@end

@implementation YDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)popQuestion:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose action"
                                                             delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];	// show from your view
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 
@end