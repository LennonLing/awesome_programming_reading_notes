//
//  YDViewController.m
//  MyAddressBook
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

@interface YDViewController ()<ABPeoplePickerNavigationControllerDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)selectContact:(UIButton *)sender
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL)
        {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                 accessGranted = granted;
                                                 dispatch_async(dispatch_get_main_queue(),^{
                                                     accessGranted=YES;
                                                     
                                                     ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
                                                     peoplePicker.peoplePickerDelegate=self;
                                                         //optional to limit the number of properties displayed
                                                     NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                                                                [NSNumber numberWithInt:kABPersonEmailProperty],
                                                                                [NSNumber numberWithInt:kABPersonFirstNameProperty], nil];
                                                     peoplePicker.displayedProperties = displayedItems;
                                                     
                                                     [self presentViewController: peoplePicker animated:NO completion:nil];
                                                     
                                                 });
                                                 });
        }
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            //Access is not determined
        }
    else   if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied)
        {
            //Access is denied
        }
    else   if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            //Access is authorized
      
        
        
        }
    else   if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted)
        {
            //Access is restricted
        }
    
 
    
}
#pragma mark delegates
// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    //[self dismissViewControllerAnimated:NO completion:nil];

    return YES;
}
// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


@end
