//
//  YDViewController.m
//  ShowFromRect
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
-(IBAction)popQuestion:(id)sender;
@property(nonatomic,weak) IBOutlet UIButton* popBtn;

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    [actionSheet showFromRect:self.popBtn.frame inView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
