//
//  YDViewController.m
//  CorePerformance
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
#import "YDAppDelegate.h"
#import "Something.h"
@interface YDViewController ()
- (IBAction)createDefaultData:(UIButton *)sender;

@end

@implementation YDViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

}




- (IBAction)createDefaultData:(UIButton *)sender
{
    [[self appDelegate] resetStore];
    for (int i = 0 ;i<10000;i++)
        {
        Something*  something =[NSEntityDescription
                                insertNewObjectForEntityForName:@"Something"
                                inManagedObjectContext:[self  appDelegate].managedObjectContext];
        something.val = [NSNumber numberWithInt:i];
        something.power = [NSNumber numberWithInt:(pow(i,2))];
        }
    NSError *error = nil;
    if (![[self  appDelegate].managedObjectContext save:&error]) {
            //handle your error
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
@end
