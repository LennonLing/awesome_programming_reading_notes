//
//  YDViewController.m
//  SimpleHTTPCall
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
{
    NSURLConnection* connection;
    NSMutableData* webData;

}
- (IBAction)downloadHTML:(UIButton *)sender;

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadHTML:(UIButton *)sender
{
    self.responseView.text=@"";
        //create a NSURL object with the string using the HTTP protocol
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"];
        //Create a NSURLRequest from the URL
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        //it's not required to set the HTTP method since if not set it will default to GET
    [theRequest setHTTPMethod:@"GET"];
     connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( connection )
        {
        webData = [[NSMutableData alloc] init];
        }
    
}
#pragma mark delegates
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response
{
    [webData setLength: 0];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't make a connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *responseString = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    self.responseView.text=responseString;
    
}


@end
