//
//  YDViewController.m
//  AlertViews

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

@interface YDViewController ()<UIAlertViewDelegate>
-(IBAction)simpleAlert:(id)sender;
-(IBAction)simpleAlertWithCancel:(id)sender;
-(IBAction)alertWithUserName:(id)sender;
-(IBAction)alertWithPassword:(id)sender;
-(IBAction)alertWithUserNameAndPassword:(id)sender;
@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)simpleAlert:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"simpleAlert" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];

}
-(IBAction)simpleAlertWithCancel:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"simpleAlertWithCancel" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}
-(IBAction)alertWithUserName:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"alertWithUserName" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [alert show];
}
-(IBAction)alertWithPassword:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"alertWithPassword" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput ;
    [alert show];
}
-(IBAction)alertWithUserNameAndPassword:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"alertWithUserNameAndPassword" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput ;
    [alert show];
}
#pragma mark delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //NO Selection or single button action
        }
            break;
        case 1:
        {//OK
 
        }
            break;
        default:
            break;
    }
    //to access the UITextFields you can use
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
        {
          UITextField* username = [alertView textFieldAtIndex:0];
          //use the username instance
        }
    else if (alertView.alertViewStyle == UIAlertViewStyleSecureTextInput)
        {
        UITextField* password = [alertView textFieldAtIndex:0];
        //use the password instance
        }
    else  if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
        {
        
        UITextField* username = [alertView textFieldAtIndex:0];
        UITextField* password = [alertView textFieldAtIndex:1];
        //use the username and password instance
        }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
