//
//  YDViewController.m
//  NewContact
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
#import <AddressBookUI/AddressBookUI.h>
@interface YDViewController ()<ABNewPersonViewControllerDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)createNewContact:(UIButton *)sender
{
    ABNewPersonViewController* newPersonController = [[ABNewPersonViewController alloc] init];
    newPersonController.newPersonViewDelegate=self;
    UINavigationController* newNavController = [[UINavigationController alloc]
                                                initWithRootViewController:newPersonController];
    [self presentViewController:newNavController animated:YES completion:nil];
}
#pragma mark ABNewPersonViewControllerDelegate
// Called when the user selects Save or Cancel. If the new person was saved, person will be
// a valid person that was saved into the Address Book. Otherwise, person will be NULL.
// It is up to the delegate to dismiss the view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (person)
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"Contact is created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        }
    else
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Contact creating is cancelled" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
