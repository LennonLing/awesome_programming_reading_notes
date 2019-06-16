//
//  YDViewController.m
//  ProgAB
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
#import <AddressBook/AddressBook.h>

@interface YDViewController ()

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadAddressBook];
}
-(void)loadAddressBook
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
    
        //Register for notifications
    ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookChanged, (__bridge void *)(self));
    
    if (ABAddressBookHasUnsavedChanges(addressBook))
        {
            //save changes
            BOOL didSave = ABAddressBookSave(addressBook, &error);
            if (!didSave)
                {
                //handle the error here
                }
        //abandon changes
            //ABAddressBookRevert(addressBook);
    }
}
//Listing 12-11
-(void)sampleAddContact
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
                                                 });
                                                 });
        }
    ABRecordRef newPerson = ABPersonCreate();
   
    //add firstname
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(@"Peter"), &error);
    //add lastname
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(@"van de Put"), &error);
        //add mobile phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(@"+3311111111"), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    
        //Add the record to the address book
    ABAddressBookAddRecord(addressBook, newPerson, &error);
        //Save the changes
    ABAddressBookSave(addressBook, &error);
    if (error != NULL)
        {
            //handle your error here
        }
     CFRelease(addressBook);
}
-(void)loadAllPeople
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
                                                 });
                                                 });
        }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    for( int i = 0 ; i < nPeople ; i++ )
        {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i );
        ABRecordType rectype = ABRecordGetRecordType(ref);
        //check if record is a person record
        if  (rectype == kABPersonType)
            {
            //do what you want to do
            }
        }
    //release the addressBook
    CFRelease(addressBook);
    
}
-(void)filterContacts
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
                                                 });
                                                 });
        }
    //Create an NSArray containing all contacts
    NSArray* allContacts= (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook));
    // Build a predicate that searches for contacts with at least one phone number starting with +33.
    NSPredicate* predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary* bindings) {
        ABMultiValueRef phoneNumbers = ABRecordCopyValue( (__bridge ABRecordRef)record, kABPersonPhoneProperty);
        BOOL result = NO;
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString* phoneNumber = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            if ([phoneNumber hasPrefix:@"+33"]) {
                result = YES;
                break;
            }
        }
        
        CFRelease(phoneNumbers);
        return result;
    }];
       //release the addressBook
    CFRelease(addressBook);
}
#pragma mark Callback function
void addressBookChanged(ABAddressBookRef reference,
                        CFDictionaryRef dictionary,
                        void *context)
{
        //Something has changed perform your action

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
